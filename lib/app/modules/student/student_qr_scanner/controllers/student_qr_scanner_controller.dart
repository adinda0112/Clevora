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

      if (rawValue != null && rawValue.isNotEmpty) {
        isProcessing.value = true;
        try {
          // Check if it's a JWT token (new format) or old JSON format
          bool isJwt = rawValue.contains('.') && rawValue.split('.').length == 3;

          if (isJwt) {
            // New: JWT-based QR token — send directly
            final success = await _attendanceService.scanQr(qrToken: rawValue);

            if (success) {
              Get.back();
              Get.snackbar(
                'Berhasil! ✅',
                'Absensi Anda (Hadir) berhasil dicatat',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade900,
                duration: const Duration(seconds: 4),
              );
            }
          } else {
            // Legacy: Try old JSON format for backward compatibility
            try {
              final data = jsonDecode(rawValue);
              if (data['type'] == 'attendance' && data['kelas'] != null && data['tanggal'] != null) {
                Get.snackbar(
                  'Format Lama',
                  'QR ini menggunakan format lama. Hubungi guru untuk memperbarui aplikasi.',
                  backgroundColor: Colors.orange.shade100,
                  colorText: Colors.orange.shade900,
                );
              } else {
                Get.snackbar(
                  'QR Tidak Valid',
                  'QR Code tidak dikenali sebagai format absensi.',
                  backgroundColor: Colors.orange.shade100,
                  colorText: Colors.orange.shade900,
                );
              }
            } catch (_) {
              Get.snackbar(
                'QR Tidak Valid',
                'QR Code tidak dikenali sebagai format absensi Clevora.',
                backgroundColor: Colors.orange.shade100,
                colorText: Colors.orange.shade900,
              );
            }
            await Future.delayed(const Duration(seconds: 3));
          }
        } catch (e) {
          String message = 'Gagal memproses absensi';
          final errStr = e.toString();
          if (errStr.contains('kedaluwarsa') || errStr.contains('expired')) {
            message = 'QR Code sudah kadaluwarsa. Minta guru generate QR baru.';
          } else if (errStr.contains('luar area')) {
            message = 'Anda berada di luar area sekolah.';
          } else if (errStr.contains('tidak terdaftar')) {
            message = 'Anda tidak terdaftar di kelas ini.';
          }
          
          Get.snackbar(
            'Gagal Absen ❌',
            message,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            duration: const Duration(seconds: 4),
          );
          await Future.delayed(const Duration(seconds: 3));
        } finally {
          isProcessing.value = false;
        }
      }
    }
  }
}
