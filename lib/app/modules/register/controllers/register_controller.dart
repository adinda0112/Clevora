import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final currentStep = 0.obs;
  final selectedRole = 'guru'.obs;
  final obscurePass = true.obs;
  final obscureConfirm = true.obs;
  final isLoading = false.obs;
  final passwordStrength = 0.0.obs;

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController nipController;

  final selectedMapel = 'Informatika'.obs;
  final mapelOptions = ['Informatika', 'Matematika', 'Bahasa Inggris', 'Fisika'];

  final selectedJenjang = 'SMA'.obs;
  final jenjangOptions = ['SD', 'SMP', 'SMA', 'SMK'];

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    nipController = TextEditingController();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nipController.dispose();
    super.onClose();
  }

  void checkPasswordStrength(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0.0;
    } else if (value.length < 6) {
      passwordStrength.value = 0.3;
    } else if (value.length < 10) {
      passwordStrength.value = 0.6;
    } else {
      passwordStrength.value = 1.0;
    }
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      register();
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void register() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.toNamed(Routes.OTP, arguments: {'email': emailController.text});
  }
}
