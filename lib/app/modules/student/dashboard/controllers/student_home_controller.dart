import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';

class StudentHomeController extends GetxController {
  final userName = 'Budi Santoso'.obs;
  final userRole = 'Siswa Kelas X PPLG'.obs;
  final searchQuery = ''.obs;

  final stats = <Map<String, dynamic>>[
    {
      'title': 'Tugas Selesai',
      'value': '8/10',
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Nilai Rata-rata',
      'value': '85',
      'color': AppColors.teal,
    },
    {
      'title': 'Peringkat',
      'value': '3',
      'color': AppColors.amber,
    },
  ].obs;

  final menuItems = <Map<String, dynamic>>[
    {
      'title': 'Progress Belajar',
      'subtitle': 'Lanjutkan materi',
      'icon': Icons.trending_up,
      'bg': AppColors.lightPurple,
      'text': AppColors.darkPurple,
    },
    {
      'title': 'Quiz Aktif',
      'subtitle': 'Ada 2 quiz',
      'icon': Icons.timer_outlined,
      'bg': AppColors.lightTeal,
      'text': const Color(0xFF085041),
    },
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

  final activities = <Map<String, dynamic>>[
    {
      'title': 'Membaca Modul Algoritma',
      'subtitle': 'Selesai 80%',
      'status': 'Lanjut',
      'icon': Icons.menu_book,
      'color': AppColors.primaryPurple,
      'bg': AppColors.lightPurple,
      'statusColor': const Color(0xFF3B6D11),
      'statusBg': const Color(0xFFEAF3DE),
    },
    {
      'title': 'Quiz Struktur Data',
      'subtitle': 'Tenggat besok 23:59',
      'status': 'Pending',
      'icon': Icons.timer_outlined,
      'color': AppColors.teal,
      'bg': AppColors.lightTeal,
      'statusColor': const Color(0xFF633806),
      'statusBg': AppColors.lightAmber,
    },
  ].obs;
}
