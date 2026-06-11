import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class OtpController extends GetxController {
  final otpCode = ''.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final countdown = 300.obs;
  final canResend = false.obs;

  String email = '';
  Timer? _countdownTimer;
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    canResend.value = false;
    countdown.value = 300;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        _countdownTimer?.cancel();
      }
    });
  }

  String get countdownFormatted {
    final minutes = countdown.value ~/ 60;
    final seconds = countdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verify() async {
    final code = otpCode.value;
    if (code.length < 6) {
      Get.snackbar(
        "Peringatan",
        "Kode OTP harus 6 digit lengkap",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    try {
      isLoading.value = true;
      final result = await _authService.verifyOtp(email: email, otp: code);

      if (result.success) {
        isSuccess.value = true;
        await Future.delayed(const Duration(milliseconds: 1500));
        
        final user = _authService.currentUser.value;
        if (user != null) {
          if (user.role == 'guru') {
            Get.offAllNamed(Routes.TEACHER_MAIN);
          } else {
            Get.offAllNamed(Routes.STUDENT_MAIN);
          }
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      } else {
        Get.snackbar(
          "Verifikasi Gagal",
          result.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Verifikasi Gagal",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      final success = await _authService.resendOtp(email: email);
      if (success) {
        Get.snackbar(
          "OTP Dikirim Ulang",
          "Kode verifikasi baru telah dikirim ke email Anda",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        _startCountdown();
      } else {
        Get.snackbar(
          "Gagal",
          "Gagal mengirim ulang kode OTP",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}
