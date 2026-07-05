import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final fullName = ''.obs;
  final role = ''.obs;
  final email = ''.obs;

  final settings = <Map<String, dynamic>>[
    {'title': 'Account settings', 'icon': Icons.person_outline, 'route': ''},
    {'title': 'Log Keamanan & Audit', 'icon': Icons.security, 'route': '/security-log'},
    {'title': 'Notifications', 'icon': Icons.notifications_none, 'route': ''},
    {'title': 'Help center', 'icon': Icons.help_outline, 'route': ''},
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
}
