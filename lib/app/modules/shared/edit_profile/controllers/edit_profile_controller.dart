import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/services/profil_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final fullName = ''.obs;
  final email = ''.obs;
  final profileImagePath = ''.obs;
  final fotoProfilBase64 = ''.obs;
  final _imagePicker = ImagePicker();

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController nipController;
  late final TextEditingController nisnController;
  late final TextEditingController sekolahController;

  late final TextEditingController mapelController;

  final selectedKelas = ''.obs;
  final kelasOptions = ['X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2', 'X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2'];

  final selectedMapel = ''.obs;
  final mapelOptions = [
    'Informatika', 'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sosiologi', 'Ekonomi',
    'Biologi', 'Fisika', 'Sejarah', 'PJOK', 'Prakarya dan Kewirausahaan',
    'Pendidikan Agama Islam', 'Seni Budaya', 'Bahasa Jawa', 'Kimia'
  ];

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    fullName.value = user?.nama ?? '';
    email.value = user?.email ?? '';
    fotoProfilBase64.value = user?.fotoProfilBase64 ?? '';
    
    namaController = TextEditingController(text: user?.nama ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    nipController = TextEditingController(text: user?.nip ?? '');
    nisnController = TextEditingController(text: user?.nisn ?? '');
    sekolahController = TextEditingController(text: user?.sekolah ?? '');
    mapelController = TextEditingController(text: user?.mapel ?? '');
    selectedKelas.value = user?.kelas ?? 'X IPA 1';
    
    // Init dropdown values for guru
    final userMapel = user?.mapel ?? '';
    if (userMapel.isNotEmpty && mapelOptions.contains(userMapel)) {
      selectedMapel.value = userMapel;
    } else if (mapelOptions.isNotEmpty) {
      selectedMapel.value = mapelOptions.first;
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    nipController.dispose();
    nisnController.dispose();
    sekolahController.dispose();
    mapelController.dispose();
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

      if (emailController.text.trim() != user.email) {
        data['email'] = emailController.text.trim();
      }

      if (profileImagePath.value.isNotEmpty) {
        final bytes = await File(profileImagePath.value).readAsBytes();
        final base64String = base64Encode(bytes);
        data['foto_profil_base64'] = base64String;
      }

      if (userRole == 'guru') {
        if (nipController.text.trim().isNotEmpty) {
          data['nip'] = nipController.text.trim();
        }
        if (sekolahController.text.trim().isNotEmpty) {
          data['sekolah'] = sekolahController.text.trim();
        }
        data['mapel'] = selectedMapel.value;
      } else {
        if (nisnController.text.trim().isNotEmpty) {
          data['nisn'] = nisnController.text.trim();
        }
        data['kelas'] = selectedKelas.value;
        if (sekolahController.text.trim().isNotEmpty) {
          data['sekolah'] = sekolahController.text.trim();
        }
      }

      // 1. Update using AuthService for role-specific fields (nip, kelas, dll)
      await _authService.updateUser(user.id, data);
      
      // 2. Update core profile fields using the new ProfilService
      final ProfilService profilService = Get.find<ProfilService>();
      final updatedUser = await profilService.updateProfil(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        fotoProfilBase64: data['foto_profil_base64'],
      );
      
      await _authService.updateCurrentUserState(updatedUser);
      
      // Update local observables
      fullName.value = updatedUser.nama;
      email.value = updatedUser.email;

      isLoading.value = false;
      Get.back(); // Pindah halaman DULU

      Get.snackbar( // BARU munculkan snackbar
        'Berhasil',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      Get.snackbar(
        'Gagal',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      isLoading.value = false;
    }
  }
}
