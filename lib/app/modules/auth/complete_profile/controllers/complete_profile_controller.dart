import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/widgets/smart_camera_dialog.dart';

class CompleteProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  final role = 'siswa'.obs;

  final formKey = GlobalKey<FormState>();

  late final TextEditingController namaLengkapController;
  late final TextEditingController nipController;
  late final TextEditingController nisnController;
  late final TextEditingController sekolahController;

  final selectedKelas = 'X IPA 1'.obs;
  final kelasOptions = [
    'X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2',
    'X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2',
  ];

  final selectedMapel = 'Informatika'.obs;
  final mapelOptions = [
    'Informatika', 'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sosiologi', 'Ekonomi', 
    'Biologi', 'Fisika', 'Sejarah', 'PJOK', 'Prakarya dan Kewirausahaan', 
    'Pendidikan Agama Islam', 'Seni Budaya', 'Bahasa Jawa', 'Kimia'
  ];

  @override
  void onInit() {
    super.onInit();
    namaLengkapController = TextEditingController();
    nipController = TextEditingController();
    nisnController = TextEditingController();
    sekolahController = TextEditingController();

    final user = _authService.currentUser.value;
    if (user != null) {
      role.value = user.role;
      namaLengkapController.text = user.nama;
    }
  }

  @override
  void onClose() {
    // namaLengkapController.dispose();
    // nipController.dispose();
    // nisnController.dispose();
    // sekolahController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    try {
      isLoading.value = true;
      final data = <String, dynamic>{};
      data['nama'] = namaLengkapController.text.trim();
      data['sekolah'] = sekolahController.text.trim();
      
      if (role.value == 'guru') {
        data['nip'] = nipController.text.trim();
        data['mapel'] = selectedMapel.value;
      } else {
        data['nisn'] = nisnController.text.trim();
        data['kelas'] = selectedKelas.value;
      }

      await _authService.updateUser(user.id, data);

      // For siswa, ask to register face after profile completion
      if (role.value != 'guru') {
        final userAfterUpdate = _authService.currentUser.value;
        if (userAfterUpdate != null && !userAfterUpdate.sudahDaftarWajah) {
          await Get.dialog<bool>(
            const SmartCameraDialog(
              title: 'Daftarkan Wajah',
              isRegistration: true,
            ),
            barrierDismissible: false,
          );
          // Refresh user data after face registration
          await _authService.getMe();
        }
      }
      
      Get.snackbar(
        "Berhasil", 
        "Profil berhasil dilengkapi",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      isLoading.value = false;
      if (role.value == 'guru') {
        Get.offAllNamed(Routes.TEACHER_MAIN);
      } else {
        Get.offAllNamed(Routes.STUDENT_MAIN);
      }
    } catch (e) {
      debugPrint("COMPLETE PROFILE ERROR: ${e.toString()}");
      try {
        Get.snackbar(
          "Gagal", 
          e.toString(),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      } catch (_) {}
      isLoading.value = false;
    }
  }
}
