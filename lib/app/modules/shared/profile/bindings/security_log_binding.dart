import 'package:get/get.dart';
import 'package:clevora/app/modules/shared/profile/controllers/security_log_controller.dart';

class SecurityLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityLogController>(() => SecurityLogController());
  }
}
