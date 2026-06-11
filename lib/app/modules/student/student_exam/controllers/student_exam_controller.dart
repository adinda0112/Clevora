import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/face_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';

class StudentExamController extends GetxController with WidgetsBindingObserver {
  final QuizService _quizService = Get.find<QuizService>();
  final FaceService _faceService = Get.find<FaceService>();

  final quiz = Rxn<QuizModel>();
  final warningCount = 0.obs;
  final currentQuestionIndex = 0.obs;
  final timeRemaining = 1800.obs; // Default 30 min in seconds
  final isSubmitting = false.obs;

  Timer? _timer;
  Timer? _proctorTimer;

  // Reactively track selected answers for each question (-1 means unselected)
  final selectedAnswers = <int>[].obs;

  // Proctoring Camera variables
  CameraController? cameraController;
  final isCameraInitialized = false.obs;
  bool isProctoringActive = false;
  String resultId = '';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final quizObj = args['quiz'] as QuizModel?;
      resultId = args['resultId'] as String? ?? '';
      
      if (quizObj != null) {
        quiz.value = quizObj;
        timeRemaining.value = quizObj.durasi * 60;
        selectedAnswers.assignAll(List.generate(quizObj.soal.length, (_) => -1));

        // Proctoring active ONLY for Ujian (not pretest or posttest)
        final title = quizObj.judul.toLowerCase();
        isProctoringActive = !title.contains('pretest') && !title.contains('posttest');
      }
    }

    startTimer();

    if (isProctoringActive) {
      _initializeProctoringCamera();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _proctorTimer?.cancel();
    cameraController?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      simulateWarning();
    }
  }

  Future<void> _initializeProctoringCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.low, // Use low resolution for lightweight frames transmission
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
      _startProctoringTimer();
    } catch (e) {
      print('Failed to initialize proctoring camera: $e');
    }
  }

  void _startProctoringTimer() {
    // Send frame to backend every 4 seconds for processing
    _proctorTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (cameraController == null || !isCameraInitialized.value || isSubmitting.value) return;

      try {
        final image = await cameraController!.takePicture();
        
        // Compress frame to reduce bandwidth and latency
        final targetPath = '${image.path}_compressed.jpg';
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          image.path, 
          targetPath,
          quality: 50, // Low quality is enough for simple face detection
          minWidth: 480, // Scale down to max 480px width
          minHeight: 480,
        );

        if (compressedFile == null) return;

        // Send frame to backend
        final result = await _faceService.sendProctorFrame(resultId, compressedFile.path);

        // Delete temporary captured file on local storage to save space
        final file = File(image.path);
        if (file.existsSync()) {
          file.deleteSync();
        }
        final cFile = File(compressedFile.path);
        if (cFile.existsSync()) {
          cFile.deleteSync();
        }

        // Process response
        final violationDetected = result['violationDetected'] as bool? ?? false;
        final serverWarningCount = result['warningCount'] as int? ?? 0;
        final berakhirPaksa = result['berakhirPaksa'] as bool? ?? false;

        if (violationDetected) {
          warningCount.value = serverWarningCount;
          final violationType = result['violationType'] as String? ?? '';

          String friendlyMessage = 'Terdeteksi pelanggaran!';
          if (violationType == 'wajah_tidak_ada') {
            friendlyMessage = 'Wajah tidak terdeteksi di kamera.';
          } else if (violationType == 'multi_wajah') {
            friendlyMessage = 'Terdeteksi lebih dari satu wajah.';
          } else if (violationType == 'menoleh') {
            friendlyMessage = 'Jangan menoleh terlalu lama dari layar.';
          } else if (violationType == 'dua_tangan') {
            friendlyMessage = 'Terdeteksi posisi tangan mencurigahkan.';
          }

          Get.snackbar(
            'Peringatan Sistem',
            '$friendlyMessage (${warningCount.value}/3)',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.warning, color: Colors.white),
          );

          if (berakhirPaksa || warningCount.value >= 3) {
            _timer?.cancel();
            _proctorTimer?.cancel();
            submitExam(autoSubmit: false, forced: true);
          }
        }
      } catch (e) {
        print('Error during periodic proctoring frame check: $e');
      }
    });
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
      _proctorTimer?.cancel();
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
    _proctorTimer?.cancel();
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
