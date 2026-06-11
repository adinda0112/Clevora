import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:clevora/app/data/services/auth_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final fullName = ''.obs;
  final email = ''.obs;
  final profileImagePath = ''.obs;
  final _imagePicker = ImagePicker();

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController nipController;
  late final TextEditingController nisnController;
  late final TextEditingController sekolahController;

  final selectedKelas = ''.obs;
  final kelasOptions = ['X', 'XI', 'XII'];

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    fullName.value = user?.nama ?? '';
    email.value = user?.email ?? '';
    
    namaController = TextEditingController(text: user?.nama ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    nipController = TextEditingController(text: user?.nip ?? '');
    nisnController = TextEditingController(text: user?.nisn ?? '');
    sekolahController = TextEditingController(text: user?.sekolah ?? '');
    selectedKelas.value = user?.kelas ?? 'X';
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    nipController.dispose();
    nisnController.dispose();
    sekolahController.dispose();
    super.onClose();
  }

  String get userRole => _authService.currentUser.value?.role ?? 'siswa';

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar dari galeri');
    }
  }

  Future<void> saveProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;
      final user = _authService.currentUser.value;
      if (user == null) return;

      final data = <String, dynamic>{
        'nama': namaController.text.trim(),
      };

      if (userRole == 'guru') {
        data['nip'] = nipController.text.trim();
      } else {
        data['nisn'] = nisnController.text.trim();
        data['kelas'] = selectedKelas.value;
        data['sekolah'] = sekolahController.text.trim();
      }

      await _authService.updateUser(user.id, data);
      
      // Update local observables
      fullName.value = namaController.text.trim();
      email.value = emailController.text.trim();

      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      Get.back();
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      Get.snackbar(
        'Gagal',
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