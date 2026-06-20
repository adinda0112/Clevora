import 'package:get/get.dart';
import 'package:clevora/app/data/models/module_model.dart';
import 'package:clevora/app/data/services/module_service.dart';

class TeacherHistoryController extends GetxController {
  final ModuleService _moduleService = Get.find<ModuleService>();

  final modules = <ModuleModel>[].obs;
  final isLoading = false.obs;
  String type = 'Riwayat';
  String backendJenis = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    type = args['type'] ?? 'Riwayat';

    // Map display name to backend jenis enum
    if (['ATP', 'Modul', 'Materi'].contains(type)) {
      backendJenis = type;
    } else {
      backendJenis = '';
    }

    fetchModules();
  }

  Future<void> fetchModules() async {
    isLoading.value = true;
    try {
      final all = await _moduleService.getModules();
      if (backendJenis.isNotEmpty) {
        modules.assignAll(all.where((m) => m.jenis == backendJenis));
      } else {
        modules.assignAll(all);
      }
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat riwayat: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
