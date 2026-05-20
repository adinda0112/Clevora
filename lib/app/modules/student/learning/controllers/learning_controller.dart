import 'package:get/get.dart';
import 'package:clevora/app/data/models/module_model.dart';
import 'package:clevora/app/data/services/module_service.dart';

class LearningController extends GetxController {
  final ModuleService _moduleService = Get.find<ModuleService>();

  final modules = <ModuleModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchModules();
  }

  Future<void> fetchModules() async {
    isLoading.value = true;
    try {
      final fetched = await _moduleService.getModules();
      modules.assignAll(fetched);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat modul belajar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
