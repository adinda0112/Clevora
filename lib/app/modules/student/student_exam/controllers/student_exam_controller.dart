import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class StudentExamController extends GetxController {
  final warningCount = 0.obs;
  final currentQuestionIndex = 0.obs;
  final timeRemaining = 3600.obs; // 60 minutes in seconds

  Timer? _timer;

  final questions = <Map<String, dynamic>>[
    {
      'question': 'Apa yang dimaksud dengan Primary Key dalam basis data?',
      'options': [
        'A. Kunci yang digunakan untuk menghubungkan dua tabel',
        'B. Kunci yang unik untuk setiap baris dalam tabel',
        'C. Kunci yang boleh memiliki nilai null',
        'D. Kunci untuk mengenkripsi data'
      ],
      'selected': Rxn<int>(),
    },
    {
      'question': 'Perintah SQL untuk mengambil data dari database adalah...',
      'options': [
        'A. GET',
        'B. OPEN',
        'C. EXTRACT',
        'D. SELECT'
      ],
      'selected': Rxn<int>(),
    },
    {
      'question': 'Tipe data yang paling tepat untuk menyimpan teks panjang adalah...',
      'options': [
        'A. VARCHAR',
        'B. INT',
        'C. TEXT',
        'D. BOOLEAN'
      ],
      'selected': Rxn<int>(),
    }
  ];

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
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
    questions[currentQuestionIndex.value]['selected'].value = index;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
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
      Get.defaultDialog(
        title: 'Ujian Dihentikan',
        middleText: 'Anda telah mencapai batas maksimal pelanggaran (3/3). Ujian otomatis diakhiri.',
        barrierDismissible: false,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            Get.offAllNamed(Routes.STUDENT_RESULT);
          },
          child: const Text('Lihat Hasil'),
        ),
      );
    }
  }

  void confirmSubmit() {
    Get.defaultDialog(
      title: 'Submit Ujian',
      middleText: 'Apakah Anda yakin ingin menyelesaikan ujian ini? Jawaban tidak dapat diubah setelah disubmit.',
      textConfirm: 'Ya, Submit',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        submitExam();
      },
    );
  }

  void submitExam({bool autoSubmit = false}) {
    _timer?.cancel();
    if (autoSubmit) {
      Get.snackbar('Waktu Habis', 'Ujian otomatis disubmit.', snackPosition: SnackPosition.TOP);
    }
    Get.offAllNamed(Routes.STUDENT_RESULT);
  }
}
