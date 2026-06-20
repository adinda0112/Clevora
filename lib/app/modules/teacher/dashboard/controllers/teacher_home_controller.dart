import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/routes/app_routes.dart';

import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class TeacherHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userName = ''.obs;
  final userRole = ''.obs;
  final searchQuery = ''.obs;
  final isStatsLoading = false.obs;

  final stats = <Map<String, dynamic>>[
    {
      'title': 'ATP',
      'value': '0',
      'color': AppColors.primaryPurple,
      'route': Routes.TEACHER_HISTORY,
      'args': {'type': 'ATP'},
    },
    {
      'title': 'Modul Ajar',
      'value': '0',
      'color': AppColors.teal,
      'route': Routes.TEACHER_HISTORY,
      'args': {'type': 'Modul'},
    },
    {
      'title': 'Materi',
      'value': '0',
      'color': AppColors.amber,
      'route': Routes.TEACHER_HISTORY,
      'args': {'type': 'Materi'},
    },
    {
      'title': 'Kuis',
      'value': '0',
      'color': AppColors.red,
      'route': Routes.QUIZ_MANAGEMENT,
    },
  ].obs;

  late final Worker _userWorker;

  @override
  void onInit() {
    super.onInit();
    _bindUserData();
    fetchDashboardStats();
  }

  @override
  void onClose() {
    _userWorker.dispose();
    super.onClose();
  }

  void _bindUserData() {
    final user = _authService.currentUser.value;
    if (user != null) {
      userName.value = user.nama;
      userRole.value = 'Guru ${user.mapel ?? "Informatika"} · ${user.sekolah ?? user.jenjang ?? "Clevora"}';
    }

    _userWorker = ever(_authService.currentUser, (user) {
      if (user != null) {
        userName.value = user.nama;
        userRole.value = 'Guru ${user.mapel ?? "Informatika"} · ${user.sekolah ?? user.jenjang ?? "Clevora"}';
      }
    });
  }

  Future<void> fetchDashboardStats() async {
    isStatsLoading.value = true;
    try {
      final res = await Get.find<ApiProvider>().dio.get('/dashboard/teacher');
      if (res.statusCode == 200) {
        final data = res.data['data'] ?? {};
        stats[0]['value'] = (data['atpCount'] ?? 0).toString();
        stats[1]['value'] = (data['modulCount'] ?? 0).toString();
        stats[2]['value'] = (data['materiCount'] ?? 0).toString();
        stats[3]['value'] = (data['kuisCount'] ?? 0).toString();
        stats.refresh();

        if (data['recentActivities'] != null) {
          final List<dynamic> recent = data['recentActivities'];
          if (recent.isNotEmpty) {
            activities.value = recent.map((item) {
              final isModule = item['type'] == 'module';
              return {
                'title': item['title'] ?? 'Tanpa Judul',
                'subtitle': item['subtitle'] ?? '',
                'status': isModule ? 'Aktif' : 'Tersedia',
                'icon': isModule ? Icons.description_outlined : Icons.assignment_turned_in_outlined,
                'color': isModule ? AppColors.primaryPurple : AppColors.teal,
                'bg': isModule ? AppColors.lightPurple : AppColors.lightTeal,
                'statusColor': isModule ? const Color(0xFF3B6D11) : const Color(0xFF633806),
                'statusBg': isModule ? const Color(0xFFEAF3DE) : AppColors.lightAmber,
              };
            }).toList();
          } else {
            activities.clear();
          }
        }
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat statistik dashboard: $e',
        snackPosition: SnackPosition.BOTTOM);
    } finally {
      isStatsLoading.value = false;
    }
  }

  final menuItems = <Map<String, dynamic>>[
    {
      'title': 'Absen Siswa',
      'subtitle': 'Kehadiran harian',
      'icon': Icons.co_present_outlined,
      'bg': AppColors.lightPurple,
      'text': AppColors.darkPurple,
      'route': Routes.ATTENDANCE,
    },
    {
      'title': 'Laporan Nilai',
      'subtitle': 'Rekap & infografis',
      'icon': Icons.bar_chart_outlined,
      'bg': AppColors.lightCoral,
      'text': const Color(0xFF711b13),
      'route': Routes.REPORT,
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
