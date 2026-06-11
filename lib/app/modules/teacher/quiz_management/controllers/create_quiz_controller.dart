import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/auth_service.dart';

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

      await _quizService.createQuiz(
        judul: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        mapel: mapelController.text.trim(),
        kelas: selectedKelas.value,
        durasi: durasi,
      );

      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        'Kuis berhasil dibuat',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
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
