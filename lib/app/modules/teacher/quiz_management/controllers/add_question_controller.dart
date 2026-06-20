import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/quiz_service.dart';

class AddQuestionController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();

  final formKey = GlobalKey<FormState>();

  final pertanyaanController = TextEditingController();
  final pilihanControllers = List.generate(4, (_) => TextEditingController());
  final penjelasanController = TextEditingController();

  final kunciJawaban = 0.obs; // Index of correct answer (0=A, 1=B, 2=C, 3=D)
  final isLoading = false.obs;

  String get quizId => Get.arguments as String? ?? '';

  @override
  void onClose() {
    pertanyaanController.dispose();
    for (final c in pilihanControllers) {
      c.dispose();
    }
    penjelasanController.dispose();
    super.onClose();
  }

  Future<void> submitQuestion() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;

      final pilihan = pilihanControllers.map((c) => c.text.trim()).toList();

      await _quizService.addQuestion(
        quizId,
        pertanyaan: pertanyaanController.text.trim(),
        pilihan: pilihan,
        kunciJawaban: kunciJawaban.value,
        penjelasan: penjelasanController.text.trim().isNotEmpty
            ? penjelasanController.text.trim()
            : null,
      );

      // Clear form for the next question
      pertanyaanController.clear();
      for (final c in pilihanControllers) {
        c.clear();
      }
      penjelasanController.clear();
      kunciJawaban.value = 0;

      Get.snackbar(
        'Berhasil',
        'Soal berhasil ditambahkan! Tambah soal lagi atau tekan Kembali.',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
