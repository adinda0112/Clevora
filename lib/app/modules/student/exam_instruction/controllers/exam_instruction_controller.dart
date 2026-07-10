import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/widgets/smart_camera_dialog.dart';

class ExamInstructionController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final AuthService _authService = Get.find<AuthService>();
  final isChecked = false.obs;
  final quiz = Rxn<QuizModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    quiz.value = Get.arguments as QuizModel?;
  }

  void toggleCheck(bool? value) {
    if (value != null) isChecked.value = value;
  }

  Future<void> startExam() async {
    if (quiz.value == null || isLoading.value) return;

    isLoading.value = true;
    try {
      // 1. Fetch quiz with full questions before starting
      final fullQuiz = await _quizService.getQuizById(quiz.value!.id);

      // 2. Initialize result session in DB to get a resultId
      final resultData = await _quizService.startQuiz(fullQuiz.id);
      final resultId = resultData['_id'] ?? resultData['id'] ?? '';

      final title = fullQuiz.judul.toLowerCase();
      // Proctoring (dan verifikasi) hanya aktif untuk ujian, bukan pretest/posttest
      final isProctoringActive = !title.contains('pretest') && !title.contains('posttest');

      bool isVerified = true;

      if (isProctoringActive) {
        // 3. Check if student has registered face
        final user = _authService.currentUser.value;
        if (user != null && !user.sudahDaftarWajah) {
          Get.snackbar(
            'Registrasi Wajah Diperlukan',
            'Silakan daftarkan wajah Anda terlebih dahulu.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFFF9800),
            colorText: const Color(0xFFFFFFFF),
            duration: const Duration(seconds: 4),
          );
          return;
        }

        // 4. Trigger face verification dialog
        final dialogResult = await Get.dialog<bool>(
          const SmartCameraDialog(title: 'Verifikasi Wajah Sebelum Mulai'),
          barrierDismissible: false,
        );
        isVerified = dialogResult ?? false;
      }

      if (isVerified) {
        Get.offNamed(
          Routes.STUDENT_EXAM,
          arguments: {
            'quiz': fullQuiz,
            'resultId': resultId,
          },
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memulai sesi ujian: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
