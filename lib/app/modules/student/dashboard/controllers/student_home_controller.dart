import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';

import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class StudentHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userName = ''.obs;
  final userRole = ''.obs;
  final searchQuery = ''.obs;
  final isStatsLoading = false.obs;

  final stats = <Map<String, dynamic>>[
    {
      'title': 'Tugas Selesai',
      'value': '0',
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Nilai Rata-rata',
      'value': '0',
      'color': AppColors.teal,
    },
    {
      'title': 'Peringkat',
      'value': '0',
      'color': AppColors.amber,
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
      final String jurusan = (user.jurusan != null && user.jurusan!.isNotEmpty) ? ' ${user.jurusan}' : '';
      userRole.value = 'Siswa Kelas ${user.kelas ?? "-"} $jurusan · ${user.sekolah ?? "Clevora"}';
    }

    _userWorker = ever(_authService.currentUser, (user) {
      if (user != null) {
        userName.value = user.nama;
        final String jurusan = (user.jurusan != null && user.jurusan!.isNotEmpty) ? ' ${user.jurusan}' : '';
        userRole.value = 'Siswa Kelas ${user.kelas ?? "-"} $jurusan · ${user.sekolah ?? "Clevora"}';
      }
    });
  }

  Future<void> fetchDashboardStats() async {
    isStatsLoading.value = true;
    try {
      final res = await Get.find<ApiProvider>().dio.get('/dashboard/student');
      if (res.statusCode == 200) {
        final data = res.data['data'] ?? {};
        stats[0]['value'] = (data['tugas_selesai'] ?? 0).toString();
        stats[1]['value'] = (data['rata_rata_nilai'] ?? 0.0).toString();
        stats[2]['value'] = (data['peringkat'] ?? 0).toString();
        stats.refresh();

        // Parse recent activities
        if (data['recentActivities'] != null) {
          final List rawActivities = data['recentActivities'];
          activities.value = rawActivities.map((act) {
            final isQuiz = act['type'] == 'quiz';
            return {
              'title': act['title'] ?? '-',
              'subtitle': act['subtitle'] ?? '-',
              'status': act['status'] ?? 'Baru',
              'icon': isQuiz ? Icons.timer_outlined : Icons.menu_book,
              'color': isQuiz ? AppColors.teal : AppColors.primaryPurple,
              'bg': isQuiz ? AppColors.lightTeal : AppColors.lightPurple,
              'statusColor': isQuiz ? const Color(0xFF633806) : const Color(0xFF3B6D11),
              'statusBg': isQuiz ? AppColors.lightAmber : const Color(0xFFEAF3DE),
            };
          }).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat statistik: $e',
        snackPosition: SnackPosition.BOTTOM);
    } finally {
      isStatsLoading.value = false;
    }
  }

  final menuItems = <Map<String, dynamic>>[
    // {
    //   'title': 'Progress Belajar',
    //   'subtitle': 'Lanjutkan materi',
    //   'icon': Icons.trending_up,
    //   'bg': AppColors.lightPurple,
    //   'text': AppColors.darkPurple,
    // },
    // {
    //   'title': 'Quiz Aktif',
    //   'subtitle': 'Ada 2 quiz',
    //   'icon': Icons.timer_outlined,
    //   'bg': AppColors.lightTeal,
    //   'text': const Color(0xFF085041),
    // },
    {
      'title': 'Materi Terbaru',
      'subtitle': 'Modul algoritma',
      'icon': Icons.menu_book,
      'bg': AppColors.lightAmber,
      'text': const Color(0xFF633806),
    },
    {
      'title': 'Pretest',
      'subtitle': 'Belum dikerjakan',
      'icon': Icons.assignment_outlined,
      'bg': AppColors.lightCoral,
      'text': const Color(0xFF711b13),
    },
    {
      'title': 'Posttest',
      'subtitle': 'Sudah selesai',
      'icon': Icons.check_circle_outline,
      'bg': const Color(0xFFEAF3DE),
      'text': const Color(0xFF3B6D11),
    },
    {
      'title': 'Ujian',
      'subtitle': 'Jadwal UAS',
      'icon': Icons.event_note_outlined,
      'bg': AppColors.grey200,
      'text': AppColors.grey800,
    },
  ].obs;

  final activities = <Map<String, dynamic>>[].obs;
}
