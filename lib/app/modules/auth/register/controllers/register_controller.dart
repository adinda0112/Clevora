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

  final formKey = GlobalKey<FormState>();

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController nipController;
  late final TextEditingController nisnController;
  late final TextEditingController sekolahController;

  final selectedKelas = 'X'.obs;
  final kelasOptions = ['X', 'XI', 'XII'];

  final selectedMapel = <String>[].obs;
  final mapelOptions = [
    'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sosiologi', 'Ekonomi', 
    'Biologi', 'Fisika', 'Sejarah', 'PJOK', 'Prakarya dan Kewirausahaan', 
    'Pendidikan Agama Islam', 'Seni Budaya', 'Bahasa Jawa', 'Kimia'
  ];

  final selectedJurusan = 'IPA'.obs;
  final jurusanOptions = ['IPA', 'IPS'];

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
      if (formKey.currentState?.validate() ?? false) {
        register();
      }
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
    final kelas = role == 'siswa' ? selectedKelas.value : null;
    final sekolah = role == 'siswa' ? sekolahController.text.trim() : null;
    final mapel = role == 'guru' ? selectedMapel.join(', ') : null;
    final jurusan = role == 'siswa' ? selectedJurusan.value : null;

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
        jurusan: jurusan,
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
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      Get.snackbar(
        "Registrasi Gagal",
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
