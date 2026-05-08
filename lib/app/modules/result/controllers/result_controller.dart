import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ResultController extends GetxController {
  final score = 85.obs;
  final grade = 'Sangat Baik'.obs;

  final stats = <Map<String, dynamic>>[
    {
      'label': 'Jawaban Benar',
      'value': '12',
      'total': '15',
      'color': AppColors.teal,
      'isCorrect': true,
    },
    {
      'label': 'Jawaban Salah',
      'value': '3',
      'total': '15',
      'color': AppColors.red,
      'isCorrect': false,
    },
    {
      'label': 'Rata-rata Kelas',
      'value': '78',
      'total': '100',
      'color': AppColors.primaryPurple,
      'isCorrect': null,
    },
  ].obs;

  final chartData = <Map<String, dynamic>>[
    {'label': 'Logika', 'value': 0.9, 'color': AppColors.primaryPurple},
    {'label': 'Sintaks', 'value': 0.7, 'color': AppColors.teal},
    {'label': 'Teori', 'value': 0.85, 'color': AppColors.amber},
  ].obs;

  String get percentage => '${score.value}';
}
