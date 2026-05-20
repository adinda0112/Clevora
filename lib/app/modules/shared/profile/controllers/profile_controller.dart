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
    {'title': 'Account settings', 'icon': Icons.person_outline},
    {'title': 'Notifications', 'icon': Icons.notifications_none},
    {'title': 'Privacy & security', 'icon': Icons.lock_outline},
    {'title': 'Help center', 'icon': Icons.help_outline},
  ].obs;

  Rxn<UserModel> get currentUser => _authService.currentUser;

  @override
  void onInit() {
    super.onInit();
    // Synchronize details with the global auth session changes
    ever(_authService.currentUser, (user) {
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

  void logout() {
    _authService.logout();
  }
}
