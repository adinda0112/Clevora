import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class LoginController extends GetxController {
  late AuthRepository _authRepository;

  final selectedRole = 'guru'.obs;
  final obscurePass = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;

  late final emailController;
  late final passwordController;

  @override
  void onInit() {
    super.onInit();
    _authRepository = Get.find<AuthRepository>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  bool validatePassword(String password) {
    return password.length >= 8;
  }

  Future<void> login() async {
    if (!validateEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (!validatePassword(passwordController.text)) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    final result = await _authRepository.login(
      email: emailController.text.trim(),
      password: passwordController.text,
      role: selectedRole.value,
    );

    isLoading.value = false;

    if (result.success) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Login Gagal',
        result.message ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
