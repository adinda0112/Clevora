import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

class DashboardController extends GetxController {
  final userName = 'Bpk. Andi Saputra'.obs;
  final userRole = 'Guru Informatika · SMAN 1 Tegal'.obs;
  final searchQuery = ''.obs;

  final stats = <Map<String, dynamic>>[
    {
      'title': 'Modul Ajar',
      'value': '12',
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Kuis Aktif',
      'value': '34',
      'color': AppColors.teal,
    },
    {
      'title': 'Siswa',
      'value': '128',
      'color': AppColors.amber,
    },
  ].obs;

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

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
