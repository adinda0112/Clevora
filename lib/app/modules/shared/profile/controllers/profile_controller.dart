import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final fullName = 'Amelia Hart'.obs;
  final role = 'AI Educator'.obs;
  final email = 'amelia@clevora.com'.obs;
  final settings = <Map<String, dynamic>>[
    {'title': 'Account settings', 'icon': Icons.person_outline},
    {'title': 'Notifications', 'icon': Icons.notifications_none},
    {'title': 'Privacy & security', 'icon': Icons.lock_outline},
    {'title': 'Help center', 'icon': Icons.help_outline},
  ].obs;
}
