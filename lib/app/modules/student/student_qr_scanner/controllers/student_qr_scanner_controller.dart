import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clevora/app/data/services/attendance_service.dart';

class StudentQrScannerController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();
  final isProcessing = false.obs;
  
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final rawValue = barcode.rawValue;

      if (rawValue != null) {
        isProcessing.value = true;
        try {
          final data = jsonDecode(rawValue);
          if (data['type'] == 'attendance' && data['kelas'] != null && data['tanggal'] != null) {
            final success = await _attendanceService.scanQr(
              kelas: data['kelas'],
              mapel: data['mapel'] ?? '',
              tanggal: data['tanggal'],
            );

            if (success) {
              Get.back(); // close scanner
              Get.snackbar(
                'Berhasil!',
                'Absensi Anda (Hadir) berhasil dicatat',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade900,
                duration: const Duration(seconds: 4),
              );
            }
          } else {
            Get.snackbar(
              'QR Tidak Valid',
              'QR Code tidak dikenali sebagai format absensi.',
              backgroundColor: Colors.orange.shade100,
              colorText: Colors.orange.shade900,
            );
            await Future.delayed(const Duration(seconds: 3));
          }
        } catch (e) {
          Get.snackbar(
            'Gagal Absen',
            e.toString().contains('FormatException') ? 'Bukan QR Absensi Clevora' : e.toString(),
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
          );
          await Future.delayed(const Duration(seconds: 3));
        } finally {
          isProcessing.value = false;
        }
      }
    }
  }
}
