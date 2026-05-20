import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';

class StudentExamController extends GetxController with WidgetsBindingObserver {
  final QuizService _quizService = Get.find<QuizService>();

  final quiz = Rxn<QuizModel>();
  final warningCount = 0.obs;
  final currentQuestionIndex = 0.obs;
  final timeRemaining = 1800.obs; // Default 30 min in seconds
  final isSubmitting = false.obs;

  Timer? _timer;

  // Reactively track selected answers for each question (-1 means unselected)
  final selectedAnswers = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    final args = Get.arguments as QuizModel?;
    if (args != null) {
      quiz.value = args;
      timeRemaining.value = args.durasi * 60;
      // Initialize selected answers with -1
      selectedAnswers.assignAll(List.generate(args.soal.length, (_) => -1));
    }
    startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      simulateWarning();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        timer.cancel();
        submitExam(autoSubmit: true);
      }
    });
  }

  String get formattedTime {
    int minutes = timeRemaining.value ~/ 60;
    int seconds = timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectOption(int index) {
    if (currentQuestionIndex.value < selectedAnswers.length) {
      selectedAnswers[currentQuestionIndex.value] = index;
    }
  }

  void nextQuestion() {
    if (quiz.value != null && currentQuestionIndex.value < quiz.value!.soal.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void simulateWarning() {
    warningCount.value++;
    Get.snackbar(
      'Peringatan Sistem',
      'Terdeteksi pelanggaran (${warningCount.value}/3). Jangan tinggalkan layar!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
    );

    if (warningCount.value >= 3) {
      _timer?.cancel();
      submitExam(autoSubmit: false, forced: true);
    }
  }

  void confirmSubmit() {
    Get.defaultDialog(
      title: 'Submit Ujian',
      middleText: 'Apakah Anda yakin ingin menyelesaikan ujian ini? Jawaban tidak dapat diubah setelah disubmit.',
      textConfirm: 'Ya, Submit',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryPurple,
      onConfirm: () {
        Get.back();
        submitExam();
      },
    );
  }

  Future<void> submitExam({bool autoSubmit = false, bool forced = false}) async {
    if (isSubmitting.value) return;
    _timer?.cancel();
    isSubmitting.value = true;

    try {
      if (quiz.value == null) {
        Get.offAllNamed(Routes.STUDENT_RESULT);
        return;
      }

      // Format answers to match backend expectations: [{ soalId, jawabanSiswa }]
      final List<Map<String, dynamic>> payload = [];
      for (int i = 0; i < quiz.value!.soal.length; i++) {
        payload.add({
          'soalId': quiz.value!.soal[i].id,
          'jawabanSiswa': selectedAnswers[i],
        });
      }

      final totalTime = quiz.value!.durasi * 60;
      final timeSpent = totalTime - timeRemaining.value;

      final resultData = await _quizService.submitQuiz(
        quiz.value!.id,
        jawaban: payload,
        durasiPengerjaan: timeSpent,
      );

      if (autoSubmit) {
        Get.snackbar('Waktu Habis', 'Ujian otomatis disubmit.', snackPosition: SnackPosition.TOP);
      } else if (forced) {
        Get.snackbar('Pelanggaran Maksimal', 'Ujian ditutup otomatis akibat pelanggaran.', snackPosition: SnackPosition.TOP);
      }

      // Pass grading result details to StudentResultView!
      Get.offAllNamed(
        Routes.STUDENT_RESULT,
        arguments: {
          'quizTitle': quiz.value!.judul,
          'nilai': resultData['nilai'] ?? 0,
          'benar': resultData['benar'] ?? 0,
          'salah': resultData['salah'] ?? 0,
        },
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengumpulkan jawaban: $e', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.STUDENT_MAIN);
    } finally {
      isSubmitting.value = false;
    }
  }
}
