import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/face_service.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class CameraDialog extends StatefulWidget {
  final String title;

  const CameraDialog({
    super.key,
    this.title = 'Verifikasi Wajah',
  });

  @override
  State<CameraDialog> createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isCapturing = false;
  final FaceService _faceService = Get.find<FaceService>();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error Kamera',
        'Gagal mengakses kamera depan: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      Get.back(result: false);
    }
  }

  Future<void> _captureAndVerify() async {
    if (_cameraController == null || !_isInitialized || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Take picture
      final image = await _cameraController!.takePicture();

      // Call backend face verification api
      final isVerified = await _faceService.verifyFace(image.path);

      if (isVerified) {
        Get.snackbar(
          'Sukses',
          'Identitas terverifikasi. Selamat mengerjakan!',
          backgroundColor: AppColors.teal,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Verifikasi Gagal',
          'Wajah tidak cocok dengan profil terdaftar. Silakan coba lagi.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.back(result: false);
      }
    } catch (e) {
      Get.snackbar(
        'Verifikasi Error',
        'Terjadi kesalahan saat memverifikasi wajah: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      Get.back(result: false);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkPurple,
            ),
          ),
          const Gap(16),
          // Camera frame
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 220,
              height: 220,
              color: Colors.black,
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: CameraPreview(_cameraController!),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryPurple,
                        ),
                      ),
                    ),
            ),
          ),
          const Gap(12),
          const Text(
            'Posisikan wajah Anda di tengah kamera',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isCapturing ? null : () => Get.back(result: false),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: AppColors.grey600),
                ),
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: (_isInitialized && !_isCapturing)
                    ? _captureAndVerify
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: AppColors.grey300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: _isCapturing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Ambil Foto & Verifikasi',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
