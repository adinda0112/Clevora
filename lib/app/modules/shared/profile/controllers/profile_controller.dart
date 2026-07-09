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

  final _baseSettings = <Map<String, dynamic>>[
    {'title': 'Ubah Password', 'icon': Icons.lock_outline, 'action': 'change_password'},
  ];

  List<Map<String, dynamic>> get settings {
    final list = List<Map<String, dynamic>>.from(_baseSettings);
    if (role.value == 'Guru' || role.value == 'Admin') {
      list.add({'title': 'Log Keamanan & Audit', 'icon': Icons.security, 'route': '/security-log'});
    }
    list.add({'title': 'Logout Semua Perangkat', 'icon': Icons.phonelink_erase, 'action': 'logout_all', 'color': Colors.red});
    return list;
  }

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
      _showChangePasswordBottomSheet();
    } else if (action == 'logout_all') {
      _showLogoutAllDialog();
    }
  }

  void _showChangePasswordBottomSheet() {
    final passwordLamaController = TextEditingController();
    final passwordBaruController = TextEditingController();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ubah Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3C3489))),
            const SizedBox(height: 8),
            const Text('Masukkan password lama dan password baru Anda.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(
              controller: passwordLamaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordBaruController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: const Icon(Icons.lock_reset),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C3489),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (passwordLamaController.text.isEmpty || passwordBaruController.text.isEmpty) {
                    Get.snackbar('Error', 'Semua field harus diisi', backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
                    return;
                  }
                  try {
                    Get.back(); // close bottom sheet
                    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                    final profilService = Get.find<ProfilService>();
                    await profilService.updatePassword(passwordLamaController.text, passwordBaruController.text);
                    Get.back(); // close loading
                    Get.snackbar('Sukses', 'Password berhasil diubah', backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
                  } catch (e) {
                    Get.back(); // close loading
                    Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''), backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
                  }
                },
                child: const Text('Simpan Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showLogoutAllDialog() {
    Get.defaultDialog(
      title: 'Logout Semua Perangkat',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      titlePadding: const EdgeInsets.only(top: 24),
      contentPadding: const EdgeInsets.all(24),
      radius: 16,
      content: const Column(
        children: [
          Icon(Icons.phonelink_erase, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Apakah Anda yakin ingin keluar dari semua perangkat yang terhubung? Anda harus login ulang setelah ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () async {
          try {
            Get.back();
            Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
            final profilService = Get.find<ProfilService>();
            await profilService.logoutAll();
            Get.back();
            logout();
          } catch (e) {
            Get.back();
            Get.snackbar('Gagal', e.toString().replaceAll('Exception: ', ''), backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
          }
        },
        child: const Text('Ya, Logout Semua', style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Batal', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
