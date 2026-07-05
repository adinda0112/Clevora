import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/services/profil_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final fullName = ''.obs;
  final role = ''.obs;
  final email = ''.obs;

  final settings = <Map<String, dynamic>>[
    {'title': 'Ubah Password', 'icon': Icons.lock_outline, 'action': 'change_password'},
    {'title': 'Log Keamanan & Audit', 'icon': Icons.security, 'route': '/security-log'},
    {'title': 'Logout Semua Perangkat', 'icon': Icons.phonelink_erase, 'action': 'logout_all', 'color': Colors.red},
  ].obs;

  late final Worker _userWorker;

  Rxn<UserModel> get currentUser => _authService.currentUser;

  @override
  void onInit() {
    super.onInit();
    // Synchronize details with the global auth session changes
    _userWorker = ever(_authService.currentUser, (user) {
      if (user != null) {
        fullName.value = user.nama;
        role.value = user.role == 'guru' ? 'Guru' : 'Siswa';
        email.value = user.email;
      }
    });

    // Populate initial state
    final user = _authService.currentUser.value;
    if (user != null) {
      fullName.value = user.nama;
      role.value = user.role == 'guru' ? 'Guru' : 'Siswa';
      email.value = user.email;
    }
  }

  @override
  void onClose() {
    _userWorker.dispose();
    super.onClose();
  }

  void logout() {
    _authService.logout();
  }

  void handleSettingAction(String action) {
    if (action == 'change_password') {
      // TBD: Show bottom sheet / dialog to change password
      _showChangePasswordDialog();
    } else if (action == 'logout_all') {
      _showLogoutAllDialog();
    }
  }

  void _showChangePasswordDialog() {
    final passwordLamaController = TextEditingController();
    final passwordBaruController = TextEditingController();
    
    Get.defaultDialog(
      title: 'Ubah Password',
      content: Column(
        children: [
          TextField(
            controller: passwordLamaController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password Lama'),
          ),
          TextField(
            controller: passwordBaruController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password Baru'),
          ),
        ],
      ),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          Get.back();
          Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
          final profilService = Get.find<ProfilService>();
          await profilService.updatePassword(passwordLamaController.text, passwordBaruController.text);
          Get.back();
          Get.snackbar('Sukses', 'Password berhasil diubah');
        } catch (e) {
          Get.back();
          Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''));
        }
      },
    );
  }

  void _showLogoutAllDialog() {
    Get.defaultDialog(
      title: 'Logout Semua Perangkat',
      middleText: 'Apakah Anda yakin ingin keluar dari semua perangkat yang terhubung? Anda harus login ulang setelah ini.',
      textConfirm: 'Ya, Logout Semua',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          Get.back();
          Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
          final profilService = Get.find<ProfilService>();
          await profilService.logoutAll();
          Get.back();
          logout();
        } catch (e) {
          Get.back();
          Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''));
        }
      },
    );
  }
}
