import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';

import 'package:clevora/app/data/services/auth_service.dart';

class TeacherHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userName = ''.obs;
  final userRole = ''.obs;
  final searchQuery = ''.obs;

  final stats = <Map<String, dynamic>>[
    {
      'title': 'Modul Ajar',
      'value': '0',
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Kuis Aktif',
      'value': '0',
      'color': AppColors.teal,
    },
    {
      'title': 'Siswa',
      'value': '0',
      'color': AppColors.amber,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _bindUserData();
    fetchDashboardStats();
  }

  void _bindUserData() {
    final user = _authService.currentUser.value;
    if (user != null) {
      userName.value = user.nama;
      userRole.value = 'Guru ${user.mapel ?? "Informatika"} · ${user.sekolah ?? user.jenjang ?? "Clevora"}';
    }

    ever(_authService.currentUser, (user) {
      if (user != null) {
        userName.value = user.nama;
        userRole.value = 'Guru ${user.mapel ?? "Informatika"} · ${user.sekolah ?? user.jenjang ?? "Clevora"}';
      }
    });
  }

  Future<void> fetchDashboardStats() async {
    try {
      final data = await _authService.getTeacherStats();
      stats[0]['value'] = (data['activeModulesCount'] ?? 0).toString();
      stats[1]['value'] = (data['activeQuizzesCount'] ?? 0).toString();
      stats[2]['value'] = (data['studentsCount'] ?? 0).toString();
      stats.refresh();
    } catch (_) {}
  }

  final menuItems = <Map<String, dynamic>>[
    {
      'title': 'ATP & Modul Ajar',
      'subtitle': 'Generate otomatis',
      'icon': Icons.description_outlined,
      'bg': AppColors.lightPurple,
      'text': AppColors.darkPurple,
    },
    {
      'title': 'Bank Materi',
      'subtitle': 'Konten pembelajaran',
      'icon': Icons.auto_stories_outlined,
      'bg': AppColors.lightTeal,
      'text': const Color(0xFF085041),
    },
    {
      'title': 'Kelola Kuis',
      'subtitle': 'Pretest · Postest · Ujian',
      'icon': Icons.assignment_turned_in_outlined,
      'bg': AppColors.lightAmber,
      'text': const Color(0xFF633806),
    },
    {
      'title': 'Laporan Nilai',
      'subtitle': 'Rekap & infografis',
      'icon': Icons.bar_chart_outlined,
      'bg': AppColors.lightCoral,
      'text': const Color(0xFF711b13),
    },
  ].obs;

  final activities = <Map<String, dynamic>>[
    {
      'title': 'Modul Pemrograman Web',
      'subtitle': 'Kelas X · Diperbarui 2j lalu',
      'status': 'Aktif',
      'icon': Icons.description_outlined,
      'color': AppColors.primaryPurple,
      'bg': AppColors.lightPurple,
      'statusColor': const Color(0xFF3B6D11),
      'statusBg': const Color(0xFFEAF3DE),
    },
    {
      'title': 'Pretest Basis Data',
      'subtitle': 'Kelas XI · 25 siswa belum',
      'status': 'Pending',
      'icon': Icons.assignment_turned_in_outlined,
      'color': AppColors.teal,
      'bg': AppColors.lightTeal,
      'statusColor': const Color(0xFF633806),
      'statusBg': AppColors.lightAmber,
    },
    {
      'title': 'Ujian Tengah Semester',
      'subtitle': 'Kelas XII · Nilai rata-rata 82',
      'status': 'Selesai',
      'icon': Icons.stars_outlined,
      'color': AppColors.amber,
      'bg': AppColors.lightAmber,
      'statusColor': const Color(0xFF3B6D11),
      'statusBg': const Color(0xFFEAF3DE),
    },
  ].obs;
}
