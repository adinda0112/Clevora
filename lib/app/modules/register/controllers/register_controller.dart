import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  late AuthRepository _authRepository;

  // Step state
  final currentStep = 0.obs;
  final selectedRole = Rx<String?>(null);
  final selectedMapel = Rx<String?>(null);
  final selectedJenjang = Rx<String?>(null);
  final obscurePass = true.obs;
  final obscureConfirm = true.obs;
  final isLoading = false.obs;
  final passwordStrength = 0.obs;

  // Form controllers
  late final namaController;
  late final emailController;
  late final nipController;
  late final passwordController;
  late final confirmPasswordController;

  // Dropdowns data
  final List<String> mapelOptions = [
    'Matematika',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'IPA',
    'IPS',
  ];

  final List<String> jenjangOptions = [
    'SD',
    'SMP',
    'SMA',
    'Umum',
  ];

  @override
  void onInit() {
    super.onInit();
    _authRepository = Get.find<AuthRepository>();
    namaController = TextEditingController();
    emailController = TextEditingController();
    nipController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    nipController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void checkPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    passwordStrength.value = strength;
  }

  bool validateStep0() {
    if (selectedRole.value == null) {
      Get.snackbar(
        'Error',
        'Pilih peran terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
    return true;
  }

  bool validateStep1() {
    if (namaController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (!EmailValidator.validate(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (selectedRole.value == 'guru' && nipController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'NIP wajib diisi untuk guru',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (selectedMapel.value == null) {
      Get.snackbar(
        'Error',
        'Pilih mapel/mata pelajaran',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (selectedJenjang.value == null) {
      Get.snackbar(
        'Error',
        'Pilih jenjang pendidikan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    return true;
  }

  void nextStep() {
    if (currentStep.value == 0 && !validateStep0()) return;
    if (currentStep.value == 1 && !validateStep1()) return;

    if (currentStep.value == 1) {
      _register();
    } else {
      currentStep.value++;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> _register() async {
    isLoading.value = true;

    final registerData = {
      'nama': namaController.text,
      'email': emailController.text.trim(),
      'role': selectedRole.value,
      'nip': selectedRole.value == 'guru' ? nipController.text : null,
      'mapel': selectedMapel.value,
      'jenjang': selectedJenjang.value,
      'password': passwordController.text,
    };

    final result = await _authRepository.register(registerData);

    isLoading.value = false;

    if (result.success) {
      Get.toNamed(Routes.OTP, arguments: {'email': emailController.text.trim()});
    } else {
      Get.snackbar(
        'Registrasi Gagal',
        result.message ?? 'Terjadi kesalahan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE24B4A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
