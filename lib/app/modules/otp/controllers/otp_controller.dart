import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class OtpController extends GetxController {
  late AuthRepository _authRepository;

  final otpCode = ''.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final countdown = 300.obs;
  final canResend = false.obs;

  late String _email;
  late Timer _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    _authRepository = Get.find<AuthRepository>();
    _email = Get.arguments?['email'] ?? '';
    _startCountdown();
  }

  void _startCountdown() {
    canResend.value = false;
    countdown.value = 300;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;
      if (countdown.value == 0) {
        canResend.value = true;
        _countdownTimer.cancel();
      }
    });
  }

  String get countdownFormatted {
    final minutes = countdown.value ~/ 60;
    final seconds = countdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verify() async {
    if (otpCode.value.length != 6) {
      Get.snackbar(
        'Error',
        'Masukkan 6 digit kode OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    final result = await _authRepository.verifyOtp(
      email: _email,
      otp: otpCode.value,
    );

    isLoading.value = false;

    if (result.success) {
      isSuccess.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Verifikasi Gagal',
        result.message ?? 'Kode OTP salah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    isLoading.value = true;
    final result = await _authRepository.resendOtp(email: _email);
    isLoading.value = false;

    if (result.success) {
      _startCountdown();
      Get.snackbar(
        'Sukses',
        'Kode OTP telah dikirim',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1D9E75),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Error',
        result.message ?? 'Gagal mengirim ulang OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void onClose() {
    _countdownTimer.cancel();
    super.onClose();
  }
}
