import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/module_service.dart';
import 'package:clevora/app/data/services/quiz_service.dart';

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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
      topik.value = args['topik'] ?? 'Topik Umum';
      resultText.value = args['result'] ?? 'Tidak ada konten hasil generate.';
      kelas.value = args['kelas'] ?? 'X';
      mapel.value = args['mapel'] ?? 'Informatika';
    }
  }

  List<ParsedQuestion> _parseQuizMarkdown(String text) {
    final List<ParsedQuestion> questions = [];
    final lines = text.split('\n');

    // 1. First, locate the "Kunci Jawaban" or "Kunci" section
    int kunciSectionIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toLowerCase();
      if (line.contains('kunci jawaban') || line.contains('kunci:') || (line.contains('###') && line.contains('kunci'))) {
        kunciSectionIndex = i;
        break;
      }
    }

    // Parse keys and explanations from keys section if found
    final Map<int, String> correctLetters = {};
    final Map<int, String> explanations = {};

    if (kunciSectionIndex != -1) {
      final keyRegex = RegExp(
        r'(\d+)[\.\s:]+\*?\*?([A-D])\*?\*?\s*(?:\((.*?)\)|-\s*(.*?)|:\s*(.*?)|(.*))?',
        caseSensitive: false,
      );

      for (int i = kunciSectionIndex + 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        final match = keyRegex.firstMatch(line);
        if (match != null) {
          final qNum = int.tryParse(match.group(1) ?? '');
          final letter = match.group(2)?.toUpperCase();
          if (qNum != null && letter != null) {
            correctLetters[qNum] = letter;
            
            String exp = '';
            for (int g = 3; g <= 6; g++) {
              final val = match.group(g)?.trim();
              if (val != null && val.isNotEmpty) {
                exp = val;
                break;
              }
            }
            if (exp.endsWith(')')) {
              exp = exp.substring(0, exp.length - 1);
            }
            explanations[qNum] = exp;
          }
        }
      }
    }

    // 2. Parse the questions
    final int endSearchIndex = kunciSectionIndex != -1 ? kunciSectionIndex : lines.length;
    
    String currentQuestionText = '';
    List<String> currentOptions = [];
    int currentQuestionNum = -1;

    void commitQuestion() {
      if (currentQuestionNum != -1 && currentQuestionText.isNotEmpty && currentOptions.length >= 2) {
        final String letter = correctLetters[currentQuestionNum] ?? 'A';
        int correctIdx = 0;
        if (letter == 'B') {
          correctIdx = 1;
        } else if (letter == 'C') {
          correctIdx = 2;
        } else if (letter == 'D') {
          correctIdx = 3;
        }

        final explanationText = explanations[currentQuestionNum] ?? '';

        questions.add(ParsedQuestion(
          questionText: currentQuestionText.trim(),
          options: List.from(currentOptions),
          correctIndex: correctIdx,
          explanation: explanationText,
        ));
      }
      currentQuestionText = '';
      currentOptions = [];
      currentQuestionNum = -1;
    }

    final questionRegex = RegExp(
      r'^(?:\*?\*?\s*Soal\s+(\d+)\s*[:\.]?\s*\*?\*?|^\s*(\d+)[\.\s]+(?![A-D][\.\s]))\s*(.*)',
      caseSensitive: false,
    );

    final optionRegex = RegExp(
      r'^\s*[\*\-]?\s*\*?\*?\s*([A-D])\s*[\.\):]\s*\*?\*?\s*(.*)',
      caseSensitive: false,
    );

    for (int i = 0; i < endSearchIndex; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      final qMatch = questionRegex.firstMatch(trimmed);
      if (qMatch != null) {
        commitQuestion();
        final qNumStr = qMatch.group(1) ?? qMatch.group(2) ?? '';
        currentQuestionNum = int.tryParse(qNumStr) ?? -1;
        currentQuestionText = qMatch.group(3) ?? '';
        continue;
      }

      final optMatch = optionRegex.firstMatch(trimmed);
      if (optMatch != null && currentQuestionNum != -1) {
        final optText = optMatch.group(2) ?? '';
        currentOptions.add(optText.trim());
        continue;
      }

      if (currentQuestionNum != -1) {
        if (currentOptions.isEmpty) {
          currentQuestionText += '\n$line';
        } else {
          currentOptions[currentOptions.length - 1] += '\n$line';
        }
      }
    }

    commitQuestion();
    return questions;
  }

  Future<void> saveAndPublish() async {
    isSaving.value = true;
    try {
      if (generateType.value == 'Modul' || generateType.value == 'Materi' || generateType.value == 'ATP') {
        await _moduleService.createModule(
          judul: '${generateType.value}: ${topik.value}',
          konten: resultText.value,
          deskripsi: 'Dokumen ${generateType.value} hasil rancangan Clevora AI untuk Kelas ${kelas.value} mata pelajaran ${mapel.value}.',
          mapel: mapel.value,
          kelas: kelas.value,
          jenjang: 'SMA',
        );
      } else if (generateType.value == 'Quiz') {
        final parsed = _parseQuizMarkdown(resultText.value);
        if (parsed.isEmpty) {
          throw 'Format kuis hasil AI tidak dapat diproses secara otomatis. Harap buat kuis manual atau generate ulang.';
        }

        final newQuiz = await _quizService.createQuiz(
          judul: 'Kuis AI: ${topik.value}',
          deskripsi: 'Evaluasi Pembelajaran Mandiri untuk Kelas ${kelas.value} mata pelajaran ${mapel.value} hasil rancangan Clevora AI.',
          mapel: mapel.value,
          kelas: kelas.value,
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
        '${generateType.value} berhasil disimpan dan dipublish ke siswa!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEAF3DE),
        colorText: const Color(0xFF3B6D11),
        margin: const EdgeInsets.all(16),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mempublikasikan dokumen: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}

