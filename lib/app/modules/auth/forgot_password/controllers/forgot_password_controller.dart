import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final emailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email wajib diisi');
      return;
    }

    try {
      isLoading.value = true;
      final success = await _authService.forgotPassword(email: email);
      if (success) {
        emailSent.value = true;
        Get.snackbar('Sukses', 'Kode OTP reset password telah dikirim ke email Anda');
        Get.toNamed(Routes.RESET_PASSWORD);
      } else {
        Get.snackbar('Gagal', 'Gagal mengirim OTP');
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (otp.length != 6) {
      Get.snackbar('Error', 'Kode OTP harus 6 digit');
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar('Error', 'Password baru minimal 6 karakter');
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok');
      return;
    }

    try {
      isLoading.value = true;
      final success = await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      if (success) {
        Get.snackbar('Sukses', 'Password Anda berhasil direset. Silakan login kembali.');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Gagal', 'Gagal mereset password');
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
