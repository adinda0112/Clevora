import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class GeneratingStateController extends GetxController {
  final generateType = ''.obs;
  final topik = ''.obs;
  
  final statusText = 'Memulai proses...'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
      topik.value = args['topik'] ?? 'Topik Umum';
    }
    _simulateLoading();
  }

  void _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    statusText.value = 'Menganalisis kurikulum dan topik...';
    
    await Future.delayed(const Duration(seconds: 1));
    statusText.value = 'Menyusun kerangka ${generateType.value}...';
    
    await Future.delayed(const Duration(seconds: 1));
    statusText.value = 'Menggenerate konten secara cerdas...';
    
    await Future.delayed(const Duration(seconds: 1));
    statusText.value = 'Melakukan finalisasi...';
    
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offNamed(Routes.AI_RESULT, arguments: {
      'type': generateType.value,
      'topik': topik.value,
    });
  }
}
