import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/auth_service.dart';

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
  late final TextEditingController nisnController;
  late final TextEditingController kelasController;
  late final TextEditingController sekolahController;

  final selectedMapel = 'Informatika'.obs;
  final mapelOptions = ['Informatika', 'Matematika', 'Bahasa Inggris', 'Fisika'];

  final selectedJenjang = 'SMA'.obs;
  final jenjangOptions = ['SD', 'SMP', 'SMA', 'SMK'];

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    nipController = TextEditingController();
    nisnController = TextEditingController();
    kelasController = TextEditingController();
    sekolahController = TextEditingController();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nipController.dispose();
    nisnController.dispose();
    kelasController.dispose();
    sekolahController.dispose();
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
    if (currentStep.value == 0) {
      currentStep.value = 1;
    } else {
      register();
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value = 0;
    }
  }

  Future<void> register() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();
    final role = selectedRole.value;
    final nip = role == 'guru' ? nipController.text.trim() : null;
    final nisn = role == 'siswa' ? nisnController.text.trim() : null;
    final kelas = role == 'siswa' ? kelasController.text.trim() : null;
    final sekolah = role == 'siswa' ? sekolahController.text.trim() : null;
    final mapel = selectedMapel.value;
    final jenjang = selectedJenjang.value;

    if (nama.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nama lengkap tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

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

    if (role == 'guru' && (nip == null || nip.isEmpty)) {
      Get.snackbar(
        "Peringatan",
        "NIP tidak boleh kosong untuk guru",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (role == 'siswa') {
      if (nisn == null || nisn.isEmpty) {
        Get.snackbar(
          "Peringatan",
          "NISN tidak boleh kosong untuk siswa",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.shade100,
          colorText: Colors.black87,
        );
        return;
      }
      if (kelas == null || kelas.isEmpty) {
        Get.snackbar(
          "Peringatan",
          "Kelas tidak boleh kosong untuk siswa",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.shade100,
          colorText: Colors.black87,
        );
        return;
      }
      if (sekolah == null || sekolah.isEmpty) {
        Get.snackbar(
          "Peringatan",
          "Sekolah tidak boleh kosong untuk siswa",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.shade100,
          colorText: Colors.black87,
        );
        return;
      }
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

    if (password.length < 8) {
      Get.snackbar(
        "Peringatan",
        "Password minimal harus 8 karakter",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (password != confirmPass) {
      Get.snackbar(
        "Peringatan",
        "Konfirmasi password tidak sesuai",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    try {
      isLoading.value = true;
      final success = await _authService.register(
        nama: nama,
        email: email,
        password: password,
        role: role,
        nip: nip,
        nisn: nisn,
        kelas: kelas,
        sekolah: sekolah,
        mapel: mapel,
        jenjang: jenjang,
      );

      if (success) {
        Get.snackbar(
          "Registrasi Berhasil",
          "Silakan masukkan kode OTP yang telah dikirim ke email Anda",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        Get.toNamed(Routes.OTP, arguments: {'email': email});
      } else {
        Get.snackbar(
          "Registrasi Gagal",
          "Terjadi kesalahan saat membuat akun Anda",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Registrasi Gagal",
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
