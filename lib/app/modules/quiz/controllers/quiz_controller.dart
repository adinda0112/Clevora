import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class QuizController extends GetxController {
  final filters = ['Semua', 'Pretest', 'Postest', 'Ujian'].obs;
  final selectedFilter = 'Semua'.obs;

  final quizzes = <Map<String, dynamic>>[
    {
      'title': 'Pretest Pemrograman Web',
      'subtitle': 'Kelas X · 15 soal',
      'category': 'Pretest',
      'icon': Icons.assignment_outlined,
      'headerColor': AppColors.lightTeal,
      'iconColor': AppColors.teal,
      'badgeColor': AppColors.lightTeal,
      'badgeTextColor': const Color(0xFF085041),
      'time': '30 menit',
      'students': '32 siswa',
      'completed': '28 selesai',
      'action': 'Lihat hasil',
    },
    {
      'title': 'Postest Basis Data',
      'subtitle': 'Kelas XI · 20 soal',
      'category': 'Postest',
      'icon': Icons.assignment_turned_in_outlined,
      'headerColor': AppColors.lightPurple,
      'iconColor': AppColors.primaryPurple,
      'badgeColor': AppColors.lightPurple,
      'badgeTextColor': AppColors.darkPurple,
      'time': '45 menit',
      'students': '30 siswa',
      'completed': 'Besok',
      'action': 'Publikasi',
    },
    {
      'title': 'UTS Informatika Kelas XII',
      'subtitle': 'Kelas XII · 40 soal',
      'category': 'Ujian',
      'icon': Icons.school_outlined,
      'headerColor': AppColors.lightAmber,
      'iconColor': AppColors.amber,
      'badgeColor': AppColors.lightAmber,
      'badgeTextColor': const Color(0xFF633806),
      'time': '90 menit',
      'students': '18 Mei',
      'completed': 'Terkunci',
      'action': 'Buka kuis',
    },
  ].obs;

  void chooseFilter(String filter) {
    selectedFilter.value = filter;
  }
}
