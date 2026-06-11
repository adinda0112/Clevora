import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/routes/app_routes.dart';

class CompleteProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  final role = 'siswa'.obs;

  final formKey = GlobalKey<FormState>();

  late final TextEditingController nipController;
  late final TextEditingController nisnController;
  late final TextEditingController sekolahController;

  final selectedKelas = 'X'.obs;
  final kelasOptions = ['X', 'XI', 'XII'];

  final selectedMapel = 'Informatika'.obs;
  final mapelOptions = ['Informatika', 'Matematika', 'Bahasa Inggris', 'Fisika'];

  final selectedJenjang = 'SMA'.obs;
  final jenjangOptions = ['SD', 'SMP', 'SMA', 'SMK'];

  @override
  void onInit() {
    super.onInit();
    nipController = TextEditingController();
    nisnController = TextEditingController();
    sekolahController = TextEditingController();

    final user = _authService.currentUser.value;
    if (user != null) {
      role.value = user.role;
    }
  }

  @override
  void onClose() {
    nipController.dispose();
    nisnController.dispose();
    sekolahController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    try {
      isLoading.value = true;
      final data = <String, dynamic>{};
      if (role.value == 'guru') {
        data['nip'] = nipController.text.trim();
        data['mapel'] = selectedMapel.value;
        data['jenjang'] = selectedJenjang.value;
      } else {
        data['nisn'] = nisnController.text.trim();
        data['kelas'] = selectedKelas.value;
        data['sekolah'] = sekolahController.text.trim();
      }

      await _authService.updateUser(user.id, data);
      
      Get.snackbar(
        "Berhasil", 
        "Profil berhasil dilengkapi",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      if (role.value == 'guru') {
        Get.offAllNamed(Routes.TEACHER_MAIN);
      } else {
        Get.offAllNamed(Routes.STUDENT_MAIN);
      }
    } catch (e) {
      Get.snackbar(
        "Gagal", 
        e.toString(),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
