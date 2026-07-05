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
                      Text('Mencatat Absensi...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.only(top: 24),
            child: const Text(
              'Arahkan kamera ke layar guru untuk absen',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
