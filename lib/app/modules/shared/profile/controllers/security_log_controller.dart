import 'package:get/get.dart';
import 'package:clevora/app/data/services/profil_service.dart';

class SecurityLogController extends GetxController {
  final ProfilService _profilService = Get.find<ProfilService>();

  final logs = <dynamic>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedLogs = await _profilService.getLogs();
      logs.assignAll(fetchedLogs);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
