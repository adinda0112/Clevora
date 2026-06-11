import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/module_service.dart';

class GeneratingStateController extends GetxController {
  final ModuleService _moduleService = Get.find<ModuleService>();

  final generateType = ''.obs;
  final topik = ''.obs;
  final kelas = ''.obs;
  final mapel = ''.obs;
  final additionalPrompt = ''.obs;
  
  final statusText = 'Memulai proses...'.obs;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
      topik.value = args['topik'] ?? 'Topik Umum';
      kelas.value = args['kelas'] ?? 'X';
      mapel.value = args['mapel'] ?? 'Informatika';
      additionalPrompt.value = args['additionalPrompt'] ?? '';
    }
    _startAiGeneration();
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }

  void _startAiGeneration() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      if (_isDisposed) return;
      statusText.value = 'Menganalisis kompetensi dasar & topik...';
      
      await Future.delayed(const Duration(milliseconds: 600));
      if (_isDisposed) return;
      statusText.value = 'Menyusun prompt pembelajaran terbaik...';
      
      await Future.delayed(const Duration(milliseconds: 600));
      if (_isDisposed) return;
      statusText.value = 'Menghubungi mesin kecerdasan buatan Gemini AI...';
      
      // Make the actual REST API call to backend
      final result = await _moduleService.generateAiDevice(
        type: generateType.value,
        topic: topik.value,
        kelas: kelas.value,
        mapel: mapel.value,
        additionalPrompt: additionalPrompt.value,
      );

      if (_isDisposed) return;
      statusText.value = 'Memformulasikan format dokumen Merdeka...';
      await Future.delayed(const Duration(milliseconds: 500));

      if (_isDisposed) return;
      Get.offNamed(Routes.AI_RESULT, arguments: {
        'type': generateType.value,
        'topik': topik.value,
        'result': result,
        'kelas': kelas.value,
        'mapel': mapel.value,
      });
    } catch (e) {
      if (_isDisposed) return;
      Get.snackbar(
        'Gagal',
        'Gagal membuat perangkat ajar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (_isDisposed) return;
        Get.back(); // Go back to form
      });
    }
  }
}
