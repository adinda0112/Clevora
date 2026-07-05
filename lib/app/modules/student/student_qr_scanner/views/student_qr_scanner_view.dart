import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clevora/app/modules/student/student_qr_scanner/controllers/student_qr_scanner_controller.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class StudentQrScannerView extends GetView<StudentQrScannerController> {
  const StudentQrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Absensi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => controller.cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.cameraController,
            onDetect: controller.onDetect,
          ),
          Obx(() {
            if (controller.isProcessing.value) {
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primaryPurple),
                      Gap(16),
                      Text('Memverifikasi absensi...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Gap(8),
                      Text('Memeriksa lokasi & QR...', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              );
            }
            return _buildOverlay();
          }),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Column(
      children: [
        Expanded(
          child: Container(color: Colors.black54),
        ),
        Row(
          children: [
            Expanded(child: Container(color: Colors.black54, height: 250)),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryPurple, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Expanded(child: Container(color: Colors.black54, height: 250)),
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.black54,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
            child: const Column(
              children: [
                Text(
                  'Arahkan kamera ke QR Code guru',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Gap(8),
                Text(
                  'QR Code berubah setiap 30 detik.\nPastikan Anda berada di area sekolah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
