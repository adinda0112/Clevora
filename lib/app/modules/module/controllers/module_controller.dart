import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter/material.dart';

class ModuleController extends GetxController {
  final filters = ['Semua', 'Kelas X', 'Kelas XI', 'Kelas XII'].obs;
  final selectedFilter = 'Semua'.obs;

  final modules = <Map<String, dynamic>>[
    {
      'title': 'Pemrograman Web Dasar',
      'subtitle': 'Informatika · Kelas X · Fase E · 18 JP',
      'progress': 0.75,
      'status': 'Aktif',
      'statusColor': AppColors.darkPurple,
      'statusBg': AppColors.lightPurple,
      'progressColor': AppColors.primaryPurple,
      'pertemuan': '4 dari 6 pertemuan',
    },
    {
      'title': 'Basis Data & SQL',
      'subtitle': 'Informatika · Kelas XI · Fase F · 24 JP',
      'progress': 0.40,
      'status': 'Berjalan',
      'statusColor': const Color(0xFF085041),
      'statusBg': AppColors.lightTeal,
      'progressColor': AppColors.teal,
      'pertemuan': '2 dari 5 pertemuan',
    },
    {
      'title': 'Algoritma & Pemrograman',
      'subtitle': 'Informatika · Kelas X · Fase E · 20 JP',
      'progress': 0.15,
      'status': 'Draft',
      'statusColor': const Color(0xFF633806),
      'statusBg': AppColors.lightAmber,
      'progressColor': AppColors.amber,
      'pertemuan': 'Belum dimulai',
    },
  ].obs;

  void chooseFilter(String filter) {
    selectedFilter.value = filter;
  }
}
