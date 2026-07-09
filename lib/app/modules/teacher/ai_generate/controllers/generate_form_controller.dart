import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class GenerateFormController extends GetxController {
  final generateType = ''.obs;
  
  final mataPelajaran = ''.obs;
  final kelas = 'X'.obs;
  final topik = ''.obs;
  final jumlahSoal = '10'.obs;
  final quizType = 'Ujian'.obs;
  
  final selectedFilePath = ''.obs;
  final selectedFileName = ''.obs;

  final mapelOptions = <String>[
    'Bahasa Indonesia', 'Bahasa Inggris', 'Matematika', 
    'Informatika', 'Fisika', 'Kimia', 'Biologi', 
    'Sejarah', 'Geografi', 'Ekonomi', 'Sosiologi', 
    'Pendidikan Pancasila', 'Seni Budaya', 'PJOK', 'Prakarya'
  ].obs;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedFilePath.value = result.files.single.path!;
        selectedFileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih file: $e');
    }
  }

  void removeFile() {
    selectedFilePath.value = '';
    selectedFileName.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
    }

    // Lock mapel to the teacher's own subject
    try {
      final authService = Get.find<AuthService>();
      final user = authService.currentUser.value;
      if (user != null && user.mapel != null && user.mapel!.isNotEmpty) {
        // Only show the teacher's own mapel
        mapelOptions.assignAll([user.mapel!]);
        mataPelajaran.value = user.mapel!;
      }
    } catch (e) {
      debugPrint('Could not find auth service for mapel');
    }
  }

  void startGenerate() {
    Get.toNamed(Routes.GENERATING_STATE, arguments: {
      'type': generateType.value,
      'topik': topik.value.isEmpty ? 'Topik Semua' : topik.value,
      'kelas': kelas.value,
      'mapel': mataPelajaran.value.isEmpty ? 'Informatika' : mataPelajaran.value,
      'tipeKuis': quizType.value,
      'jumlahSoal': int.tryParse(jumlahSoal.value) ?? 10,
      'referenceFilePath': selectedFilePath.value,
    });
  }
}
