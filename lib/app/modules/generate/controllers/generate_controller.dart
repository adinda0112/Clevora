import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class GenerateController extends GetxController {
  final subjects = ['Informatika', 'Matematika', 'Bahasa Inggris', 'Fisika'].obs;
  final selectedSubject = 'Informatika'.obs;

  final questionType = ['Pilihan ganda', 'Essay', 'Benar/Salah'].obs;
  final selectedQuestionType = 'Pilihan ganda'.obs;

  final questionCounts = ['5 soal', '10 soal', '15 soal', '20 soal'].obs;
  final selectedCount = '10 soal'.obs;

  final generatedQuestions = <Map<String, dynamic>>[
    {
      'num': '1',
      'question': 'Elemen HTML mana yang digunakan untuk menentukan judul dokumen?',
      'options': [
        {'letter': 'A', 'text': '<head>', 'correct': false},
        {'letter': 'B', 'text': '<title>', 'correct': true},
        {'letter': 'C', 'text': '<header>', 'correct': false},
        {'letter': 'D', 'text': '<body>', 'correct': false},
      ],
    },
    {
      'num': '2',
      'question': 'Apa kepanjangan dari CSS?',
      'options': [
        {'letter': 'A', 'text': 'Colorful Style Sheets', 'correct': false},
        {'letter': 'B', 'text': 'Creative Style Sheets', 'correct': false},
        {'letter': 'C', 'text': 'Cascading Style Sheets', 'correct': true},
        {'letter': 'D', 'text': 'Computer Style Sheets', 'correct': false},
      ],
    },
  ].obs;

  void chooseSubject(String? value) {
    if (value != null) selectedSubject.value = value;
  }

  void chooseQuestionType(String? value) {
    if (value != null) selectedQuestionType.value = value;
  }

  void chooseCount(String? value) {
    if (value != null) selectedCount.value = value;
  }

  void generateQuestion() {
    // Logic to generate questions
  }
}
