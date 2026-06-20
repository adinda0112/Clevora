import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/routes/app_routes.dart';

class CreateQuizController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final durasiController = TextEditingController(text: '30'); // Default 30 min
  
  final selectedKelas = ''.obs;
  final kelasOptions = ['X', 'XI', 'XII'];

  final mapelController = TextEditingController(); // Or could be dropdown

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null) {
      if (user.kelas != null && user.kelas!.isNotEmpty) {
        selectedKelas.value = user.kelas!;
      } else {
        selectedKelas.value = 'X';
      }
      mapelController.text = user.mapel ?? '';
    }
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    durasiController.dispose();
    mapelController.dispose();
    super.onClose();
  }

  Future<void> createQuiz() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;
      
      final durasi = int.tryParse(durasiController.text) ?? 30;

      final newQuiz = await _quizService.createQuiz(
        judul: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        mapel: mapelController.text.trim(),
        kelas: selectedKelas.value,
        durasi: durasi,
      );

      // Navigate to question builder
      Get.offNamed(
        Routes.MANUAL_QUIZ_QUESTIONS,
        arguments: {
          'quizId': newQuiz.id,
          'quizTitle': judulController.text.trim(),
        },
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
