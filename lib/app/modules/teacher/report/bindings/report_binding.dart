import 'package:get/get.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import '../controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilService>(() => HasilService());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
