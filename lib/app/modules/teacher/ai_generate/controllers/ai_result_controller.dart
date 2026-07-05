import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/module_service.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'dart:convert';

class ParsedQuestion {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  ParsedQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class AiResultController extends GetxController {
  final ModuleService _moduleService = Get.find<ModuleService>();
  final QuizService _quizService = Get.find<QuizService>();

  final generateType = ''.obs;
  final topik = ''.obs;
  final resultText = ''.obs;
  final kelas = ''.obs;
  final mapel = ''.obs;

  final isSaving = false.obs;
  final isEditing = false.obs;
  final hasSaved = false.obs;
  final textEditController = TextEditingController();
  
  // Store original parsed questions for Quiz
  List<ParsedQuestion> _originalParsedQuestions = [];
  bool _wasEdited = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
      topik.value = args['topik'] ?? 'Topik Umum';
      kelas.value = args['kelas'] ?? 'X';
      mapel.value = args['mapel'] ?? 'Informatika';
      
      String rawResult = args['result'] ?? '';
      
      if (generateType.value == 'Quiz') {
        _originalParsedQuestions = _parseQuizJson(rawResult);
        // Format to beautiful markdown for viewing
        resultText.value = _formatQuizToMarkdown(_originalParsedQuestions);
      } else {
        resultText.value = rawResult;
      }
      
      textEditController.text = resultText.value;
    }
  }

  String _formatQuizToMarkdown(List<ParsedQuestion> qs) {
    if (qs.isEmpty) return 'Gagal memproses kuis dari AI.';
    StringBuffer sb = new StringBuffer();
    sb.writeln('### Kuis: ${topik.value}\n');
    for (int i = 0; i < qs.length; i++) {
      sb.writeln('**Soal ${i + 1}:** ${qs[i].questionText}');
      for (int j = 0; j < qs[i].options.length; j++) {
        sb.writeln('- ${qs[i].options[j]}');
      }
      sb.writeln('');
    }
    sb.writeln('### Kunci Jawaban & Pembahasan\n');
    final letters = ['A', 'B', 'C', 'D'];
    for (int i = 0; i < qs.length; i++) {
      String letter = qs[i].correctIndex >= 0 && qs[i].correctIndex < 4 ? letters[qs[i].correctIndex] : 'A';
      sb.writeln('${i + 1}. **$letter** - ${qs[i].explanation}');
    }
    return sb.toString();
  }

  @override
  void onClose() {
    textEditController.dispose();
    super.onClose();
  }

  List<ParsedQuestion> _parseQuizJson(String text) {
    try {
      // Find the first '[' and last ']' to extract JSON array
      final startIndex = text.indexOf('[');
      final endIndex = text.lastIndexOf(']');
      
      if (startIndex == -1 || endIndex == -1) {
        throw 'Bukan JSON array';
      }
      
      final jsonString = text.substring(startIndex, endIndex + 1);
      final List<dynamic> decodedList = jsonDecode(jsonString);
      
      return decodedList.map((item) {
        return ParsedQuestion(
          questionText: item['questionText']?.toString() ?? '',
          options: (item['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          correctIndex: item['correctIndex'] is int ? item['correctIndex'] : 0,
          explanation: item['explanation']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      print('Failed to parse Quiz JSON: $e');
      return [];
    }
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Save changes
      resultText.value = textEditController.text;
      _wasEdited = true;
    } else {
      textEditController.text = resultText.value;
    }
    isEditing.toggle();
  }

  void finishProcess() {
    Get.until((route) => 
        route.settings.name == Routes.MODULE_AI || 
        route.settings.name == Routes.TEACHER_MAIN || 
        route.settings.name == Routes.TEACHER_HOME);
  }

  /// Save only — no share dialog
  Future<void> saveOnly() async {
    await _doSave(shareClass: null);
    if (hasSaved.value) {
      // Navigate to appropriate history page
      if (generateType.value == 'Quiz') {
        Get.until((route) =>
            route.settings.name == Routes.QUIZ_MANAGEMENT ||
            route.settings.name == Routes.TEACHER_MAIN ||
            route.settings.name == Routes.TEACHER_HOME);
      } else {
        Get.until((route) =>
            route.settings.name == Routes.MODULE_AI ||
            route.settings.name == Routes.TEACHER_MAIN ||
            route.settings.name == Routes.TEACHER_HOME);
      }
    }
  }

  /// Save + share to a selected class
  Future<void> saveAndShare({required String shareClass}) async {
    await _doSave(shareClass: shareClass);
  }

  Future<void> _doSave({String? shareClass}) async {
    isSaving.value = true;
    try {
      if (generateType.value == 'Modul' ||
          generateType.value == 'Materi' ||
          generateType.value == 'ATP') {
        await _moduleService.createModule(
          judul: '${generateType.value}: ${topik.value}',
          konten: resultText.value,
          deskripsi:
              'Dokumen ${generateType.value} hasil rancangan Clevora AI untuk Kelas ${kelas.value} mata pelajaran ${mapel.value}.',
          mapel: mapel.value,
          kelas: shareClass ?? kelas.value,
          jenjang: 'SMA',
          jenis: generateType.value,
        );
      } else if (generateType.value == 'Quiz') {
        List<ParsedQuestion> parsed;
        if (!_wasEdited && _originalParsedQuestions.isNotEmpty) {
          parsed = _originalParsedQuestions;
        } else {
          throw 'Anda telah mengedit kuis secara manual. Saat ini sistem hanya mendukung penyimpanan kuis murni dari AI tanpa editan agar struktur (A/B/C/D) tidak rusak. Silakan Generate Ulang atau simpan tanpa mengedit.';
        }
        
        if (parsed.isEmpty) {
          throw 'Format kuis hasil AI tidak dapat diproses.';
        }
        final newQuiz = await _quizService.createQuiz(
          judul: 'Kuis AI: ${topik.value}',
          deskripsi:
              'Evaluasi Pembelajaran Mandiri untuk Kelas ${shareClass ?? kelas.value} mata pelajaran ${mapel.value} hasil rancangan Clevora AI.',
          mapel: mapel.value,
          kelas: shareClass ?? kelas.value,
          durasi: 30,
        );
        for (var q in parsed) {
          await _quizService.addQuestion(
            newQuiz.id,
            pertanyaan: q.questionText,
            pilihan: q.options,
            kunciJawaban: q.correctIndex,
            penjelasan: q.explanation.isNotEmpty ? q.explanation : null,
          );
        }
      }

      Get.snackbar(
        'Berhasil',
        '${generateType.value} berhasil disimpan${shareClass != null ? ' dan dishare ke kelas $shareClass!' : '!'}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEAF3DE),
        colorText: const Color(0xFF3B6D11),
        margin: const EdgeInsets.all(16),
      );

      hasSaved.value = true;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}

