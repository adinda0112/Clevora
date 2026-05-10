import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class GenerateFormController extends GetxController {
  final generateType = ''.obs;
  
  final mataPelajaran = ''.obs;
  final kelas = 'X'.obs;
  final topik = ''.obs;
  final tingkatKesulitan = 'Sedang'.obs;
  final jumlahSoal = '10'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
    }
  }

  void startGenerate() {
    Get.toNamed(Routes.GENERATING_STATE, arguments: {
      'type': generateType.value,
      'topik': topik.value.isEmpty ? 'Topik Umum' : topik.value,
      'kelas': kelas.value,
    });
  }
}
