import 'dart:async';
import 'dart:io';
import 'dart:math' as math;


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:clevora/app/data/services/face_service.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:flutter/foundation.dart';

/// Status internal deteksi wajah yang ditampilkan ke pengguna
enum _FaceStatus {
  noCameraYet,   // Kamera belum siap
  noFace,        // Tidak ada wajah terdeteksi
  multipleFaces, // Lebih dari 1 wajah
  tooFar,        // Wajah terlalu jauh
  notCentered,   // Wajah belum di tengah
  blinkNow,      // Menunggu kedipan (liveness)
  ready,         // Semua OK, siap capture
  capturing,     // Sedang memproses
  done,          // Selesai
}

class SmartCameraDialog extends StatefulWidget {
  final String title;
  final bool isRegistration;

  const SmartCameraDialog({
    super.key,
    this.title = 'Verifikasi Wajah',
    this.isRegistration = false,
  });

  @override
  State<SmartCameraDialog> createState() => _SmartCameraDialogState();
}

class _SmartCameraDialogState extends State<SmartCameraDialog>
    with WidgetsBindingObserver {
  // Camera
  CameraController? _cameraController;
  CameraDescription? _frontCamera;
  bool _isCameraInitialized = false;

  // ML Kit Face Detector
  late final FaceDetector _faceDetector;
  bool _isProcessingFrame = false;

  // Face Service (backend)
  final FaceService _faceService = Get.find<FaceService>();

  // State
  _FaceStatus _status = _FaceStatus.noCameraYet;
  String _statusMessage = 'Mempersiapkan kamera...';
  Rect? _detectedFaceRect; // Posisi wajah relatif terhadap preview
  double _faceOvalProgress = 0.0; // 0.0 - 1.0 animasi progress oval

  // Liveness: blink detection
  bool _wasEyesOpen = true;
  bool _blinkDetected = false;
  int _consecutiveReadyFrames = 0;

  // Timer untuk auto-capture delay setelah semua kondisi terpenuhi
  Timer? _autoCaptureTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // Untuk deteksi mata terbuka/tertutup (liveness)
        enableContours: false,
        enableLandmarks: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
        minFaceSize: 0.25, // Wajah minimal 25% dari frame
      ),
    );

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoCaptureTimer?.cancel();
    _stopImageStream();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Jangan crash saat app di-background
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopImageStream();
      _cameraController?.dispose();
      _cameraController = null;
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // ---------------------------------------------------------------------------
  // CAMERA SETUP
  // ---------------------------------------------------------------------------

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _status = _FaceStatus.noFace;
        _statusMessage = 'Posisikan wajah Anda di dalam lingkaran';
      });

      // Mulai streaming frame ke ML Kit
      _startImageStream();
    } catch (e) {
      _showError('Gagal mengakses kamera: $e');
    }
  }

  void _startImageStream() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    _cameraController!.startImageStream(_processFrame);
  }

  void _stopImageStream() {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          _cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // FRAME PROCESSING (ML Kit Face Detection)
  // ---------------------------------------------------------------------------

  void _processFrame(CameraImage image) {
    // Jangan proses jika masih memproses frame sebelumnya atau sudah selesai
    if (_isProcessingFrame ||
        _status == _FaceStatus.capturing ||
        _status == _FaceStatus.done) {
      return;
    }
    _isProcessingFrame = true;
    _detectFaces(image).then((_) {
      _isProcessingFrame = false;
    });
  }

  Future<void> _detectFaces(CameraImage image) async {
    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector.processImage(inputImage);

      if (!mounted) return;

      if (faces.isEmpty) {
        _updateStatus(_FaceStatus.noFace, 'Wajah tidak terdeteksi');
        _consecutiveReadyFrames = 0;
        return;
      }

      if (faces.length > 1) {
        _updateStatus(
            _FaceStatus.multipleFaces, 'Hanya boleh ada 1 wajah di kamera');
        _consecutiveReadyFrames = 0;
        return;
      }

      final face = faces.first;

      // Simpan posisi wajah untuk overlay
      _updateFaceRect(face, image);

      // Cek apakah wajah cukup besar (tidak terlalu jauh)
      final faceAreaRatio = (face.boundingBox.width * face.boundingBox.height) /
          (image.width * image.height);
      if (faceAreaRatio < 0.08) {
        _updateStatus(_FaceStatus.tooFar, 'Dekatkan wajah Anda ke kamera');
        _consecutiveReadyFrames = 0;
        return;
      }

      // Cek apakah wajah cukup di tengah frame
      final centerX =
          face.boundingBox.center.dx / image.width;
      final centerY =
          face.boundingBox.center.dy / image.height;
      if ((centerX - 0.5).abs() > 0.25 || (centerY - 0.5).abs() > 0.25) {
        _updateStatus(
            _FaceStatus.notCentered, 'Posisikan wajah ke tengah lingkaran');
        _consecutiveReadyFrames = 0;
        return;
      }

      // Liveness: Blink Detection
      final leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
      final rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;
      final eyesOpen = leftEyeOpen > 0.5 && rightEyeOpen > 0.5;
      final eyesClosed = leftEyeOpen < 0.3 && rightEyeOpen < 0.3;

      if (!_blinkDetected) {
        if (_wasEyesOpen && eyesClosed) {
          // Transisi dari terbuka ke tertutup = mulai kedipan
        } else if (!_wasEyesOpen && eyesOpen) {
          // Transisi dari tertutup ke terbuka = kedipan selesai!
          _blinkDetected = true;
        }
        _wasEyesOpen = eyesOpen;

        if (!_blinkDetected) {
          _updateStatus(_FaceStatus.blinkNow,
              'Wajah terdeteksi! Silakan berkedip untuk verifikasi');
          return;
        }
      }

      // Semua kondisi terpenuhi!
      _consecutiveReadyFrames++;
      _updateStatus(_FaceStatus.ready, 'Wajah terverifikasi! Mengambil foto...');

      // Auto-capture setelah beberapa frame stabil (mencegah blur)
      if (_consecutiveReadyFrames >= 5 && _autoCaptureTimer == null) {
        _autoCaptureTimer = Timer(const Duration(milliseconds: 500), () {
          _captureAndProcess();
        });
      }
    } catch (e) {
      // Gagal proses frame, skip saja (jangan crash)
      debugPrint('Face detection error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // HELPER: Convert CameraImage → InputImage (ML Kit)
  // ---------------------------------------------------------------------------

  InputImage? _convertCameraImage(CameraImage image) {
    if (_frontCamera == null) return null;

    final sensorOrientation = _frontCamera!.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isAndroid) {
      rotation = InputImageRotation.values.firstWhere(
        (r) => r.rawValue == sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );
    } else {
      rotation = InputImageRotation.rotation0deg;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? 
                   (Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888);

    if (format != InputImageFormat.nv21 &&
        format != InputImageFormat.yuv420 &&
        format != InputImageFormat.bgra8888) {
      return null;
    }

    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  // ---------------------------------------------------------------------------
  // FACE RECT → kotak di UI overlay
  // ---------------------------------------------------------------------------

  void _updateFaceRect(Face face, CameraImage image) {
    // Koordinat wajah relatif [0..1]
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    // Front camera mirrored, jadi kita flip X
    final left = 1.0 - (face.boundingBox.right / imgW);
    final top = face.boundingBox.top / imgH;
    final width = face.boundingBox.width / imgW;
    final height = face.boundingBox.height / imgH;

    if (mounted) {
      setState(() {
        _detectedFaceRect = Rect.fromLTWH(left, top, width, height);
        _faceOvalProgress = _status == _FaceStatus.ready ? 1.0 : 0.6;
      });
    }
  }

  void _updateStatus(_FaceStatus status, String message) {
    if (mounted && (_status != status || _statusMessage != message)) {
      setState(() {
        _status = status;
        _statusMessage = message;
        if (status != _FaceStatus.ready) {
          _faceOvalProgress = status == _FaceStatus.blinkNow ? 0.6 : 0.0;
          _detectedFaceRect = status == _FaceStatus.noFace ? null : _detectedFaceRect;
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // CAPTURE & SEND TO BACKEND
  // ---------------------------------------------------------------------------

  int _verifyAttempts = 0;
  static const int _maxVerifyAttempts = 3;

  Future<void> _captureAndProcess() async {
    if (_status == _FaceStatus.capturing || _status == _FaceStatus.done) return;

    setState(() {
      _status = _FaceStatus.capturing;
      _statusMessage = widget.isRegistration
          ? 'Mendaftarkan wajah...'
          : 'Memverifikasi identitas...';
    });

    try {
      // Langsung ambil gambar tanpa menghentikan stream terlebih dahulu.
      // Menghentikan stream sebelum takePicture menyebabkan crash (BufferQueue abandoned) di beberapa device Android.
      final image = await _cameraController!.takePicture();
      
      // Hentikan stream setelah gambar berhasil diambil
      _stopImageStream();

      if (widget.isRegistration) {
        // --- REGISTRASI ---
        await _faceService.registerFace(image.path);
        setState(() {
          _status = _FaceStatus.done;
          _statusMessage = 'Wajah berhasil didaftarkan!';
        });
        await Future.delayed(const Duration(milliseconds: 800));
        await _closeDialog(true);
        try {
          Get.snackbar(
            'Sukses',
            'Wajah berhasil didaftarkan!',
            backgroundColor: AppColors.teal,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } catch (_) {}
      } else {
        // --- VERIFIKASI ---
        _verifyAttempts++;
        final isVerified = await _faceService.verifyFace(image.path);

        if (isVerified) {
          setState(() {
            _status = _FaceStatus.done;
            _statusMessage = 'Identitas terverifikasi!';
          });
          await Future.delayed(const Duration(milliseconds: 800));
          await _closeDialog(true);
          try {
            Get.snackbar(
              'Sukses',
              'Identitas terverifikasi. Selamat mengerjakan!',
              backgroundColor: AppColors.teal,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          } catch (_) {}
        } else if (_verifyAttempts < _maxVerifyAttempts) {
          // RETRY: Masih ada kesempatan, ulang proses tanpa tutup dialog
          setState(() {
            _status = _FaceStatus.noFace;
            _statusMessage =
                'Tidak cocok. Coba lagi ($_verifyAttempts/$_maxVerifyAttempts)';
            _blinkDetected = false;
            _wasEyesOpen = true;
            _consecutiveReadyFrames = 0;
            _autoCaptureTimer?.cancel();
            _autoCaptureTimer = null;
          });

          // Unlock focus/exposure lalu mulai ulang stream
          try {
            await _cameraController!.setFocusMode(FocusMode.auto);
            await _cameraController!.setExposureMode(ExposureMode.auto);
          } catch (_) {}
          _startImageStream();
        } else {
          // Sudah 3x gagal, tutup dialog
          await _closeDialog(false);
          try {
            Get.snackbar(
              'Verifikasi Gagal',
              'Wajah tidak cocok setelah $_maxVerifyAttempts percobaan. Pastikan pencahayaan cukup dan wajah menghadap kamera.',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
            );
          } catch (_) {}
        }
      }
    } catch (e) {
      // Jika error terjadi saat proses, beri kesempatan retry juga
      if (!widget.isRegistration && _verifyAttempts < _maxVerifyAttempts) {
        setState(() {
          _status = _FaceStatus.noFace;
          _statusMessage = 'Error, mencoba ulang...';
          _blinkDetected = false;
          _wasEyesOpen = true;
          _consecutiveReadyFrames = 0;
          _autoCaptureTimer?.cancel();
          _autoCaptureTimer = null;
        });
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setExposureMode(ExposureMode.auto);
        } catch (_) {}
        _startImageStream();
      } else {
        await _closeDialog(false);
        try {
          Get.snackbar(
            'Error',
            widget.isRegistration
                ? 'Gagal mendaftarkan wajah: $e'
                : 'Gagal memverifikasi wajah: $e',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } catch (_) {}
      }
    }
  }

  Future<void> _closeDialog(bool result) async {
    _autoCaptureTimer?.cancel();
    _stopImageStream();
    
    final controller = _cameraController;
    if (mounted) {
      setState(() {
        _isCameraInitialized = false;
        _cameraController = null;
      });
    }

    // Beri waktu 1 frame agar UI menghapus CameraPreview dari layar
    await Future.delayed(const Duration(milliseconds: 100));

    if (controller != null) {
      await controller.dispose();
    }
    
    // Tunggu resource kamera native benar-benar lepas
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Get.back(result: result);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error Kamera',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    Get.back(result: false);
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  Color get _statusColor {
    switch (_status) {
      case _FaceStatus.ready:
      case _FaceStatus.done:
        return const Color(0xFF22C55E); // green
      case _FaceStatus.blinkNow:
        return const Color(0xFFF59E0B); // amber
      case _FaceStatus.capturing:
        return AppColors.primaryPurple;
      default:
        return const Color(0xFFEF4444); // red
    }
  }

  IconData get _statusIcon {
    switch (_status) {
      case _FaceStatus.ready:
      case _FaceStatus.done:
        return Icons.check_circle;
      case _FaceStatus.blinkNow:
        return Icons.visibility;
      case _FaceStatus.capturing:
        return Icons.hourglass_top;
      case _FaceStatus.multipleFaces:
        return Icons.group;
      case _FaceStatus.tooFar:
        return Icons.zoom_in;
      case _FaceStatus.notCentered:
        return Icons.center_focus_strong;
      default:
        return Icons.face;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const Gap(4),
            Text(
              widget.isRegistration
                  ? 'Daftarkan wajah Anda untuk keamanan'
                  : 'Verifikasi identitas untuk melanjutkan',
              style: const TextStyle(fontSize: 12, color: AppColors.grey600),
            ),
            const Gap(16),

            // Camera Preview with Face Oval Overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 260,
                height: 320,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Camera feed
                    Container(
                      color: const Color(0xFF1A1A2E),
                      child: _isCameraInitialized && _cameraController != null
                          ? FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _cameraController!
                                    .value.previewSize!.height,
                                height: _cameraController!
                                    .value.previewSize!.width,
                                child: CameraPreview(_cameraController!),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryPurple),
                              ),
                            ),
                    ),

                    // Face Oval Guide Overlay
                    CustomPaint(
                      painter: _FaceOvalPainter(
                        progress: _faceOvalProgress,
                        statusColor: _statusColor,
                      ),
                    ),

                    // Status chip at bottom of camera view
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_status == _FaceStatus.capturing)
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            else
                              Icon(_statusIcon, size: 16, color: _statusColor),
                            const Gap(8),
                            Flexible(
                              child: Text(
                                _statusMessage,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(16),

            // Progress Steps
            _buildProgressSteps(),

            const Gap(16),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: (_status == _FaceStatus.capturing)
                    ? null
                    : () => _closeDialog(false),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: _status == _FaceStatus.capturing
                        ? AppColors.grey300
                        : AppColors.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = [
      _StepData('Deteksi Wajah', _status.index >= _FaceStatus.blinkNow.index),
      _StepData(
          'Kedipan Mata', _status.index >= _FaceStatus.ready.index),
      _StepData(
          widget.isRegistration ? 'Daftarkan' : 'Verifikasi',
          _status == _FaceStatus.done),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _buildStepDot(steps[i].label, steps[i].completed, i + 1),
          if (i < steps.length - 1)
            Container(
              width: 30,
              height: 2,
              color: steps[i].completed
                  ? const Color(0xFF22C55E)
                  : AppColors.grey300,
            ),
        ],
      ],
    );
  }

  Widget _buildStepDot(String label, bool completed, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? const Color(0xFF22C55E) : AppColors.grey200,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: completed ? Colors.white : AppColors.grey600,
                    ),
                  ),
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: AppColors.grey600),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// STEP DATA MODEL
// ---------------------------------------------------------------------------

class _StepData {
  final String label;
  final bool completed;
  const _StepData(this.label, this.completed);
}

// ---------------------------------------------------------------------------
// FACE OVAL PAINTER (Custom overlay dengan lingkaran pemandu)
// ---------------------------------------------------------------------------

class _FaceOvalPainter extends CustomPainter {
  final double progress; // 0.0 = merah/tidak ada, 0.6 = kuning/proses, 1.0 = hijau/ok
  final Color statusColor;

  _FaceOvalPainter({required this.progress, required this.statusColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Gambar overlay gelap di luar oval
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.45),
      width: size.width * 0.65,
      height: size.height * 0.55,
    );

    // Path overlay luar (seluruh area) dikurangi oval
    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final ovalPath = Path()..addOval(ovalRect);
    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, ovalPath);

    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );

    // Gambar border oval sesuai status
    final borderPaint = Paint()
      ..color = statusColor.withValues(alpha: math.max(0.5, progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawOval(ovalRect, borderPaint);

    // Gambar corner dots (4 sudut)
    final dotPaint = Paint()..color = statusColor;
    const dotRadius = 4.0;
    canvas.drawCircle(Offset(ovalRect.left, ovalRect.top + ovalRect.height * 0.2), dotRadius, dotPaint);
    canvas.drawCircle(Offset(ovalRect.right, ovalRect.top + ovalRect.height * 0.2), dotRadius, dotPaint);
    canvas.drawCircle(Offset(ovalRect.left, ovalRect.bottom - ovalRect.height * 0.2), dotRadius, dotPaint);
    canvas.drawCircle(Offset(ovalRect.right, ovalRect.bottom - ovalRect.height * 0.2), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(_FaceOvalPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.statusColor != statusColor;
}
