import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class LoginController extends GetxController {
  final selectedRole = 'guru'.obs;
  final obscurePass = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (!EmailValidator.validate(email)) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Password tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await _authService.login(
        email: email,
        password: password,
        role: selectedRole.value,
      );

      Get.snackbar(
        "Berhasil",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      if (selectedRole.value == 'guru') {
        Get.offAllNamed(Routes.TEACHER_MAIN);
      } else {
        Get.offAllNamed(Routes.STUDENT_MAIN);
      }
    } catch (e) {
      Get.snackbar(
        "Login Gagal",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}