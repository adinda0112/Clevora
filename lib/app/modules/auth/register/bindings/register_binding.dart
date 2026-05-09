import 'package:get/get.dart';
import 'package:clevora/app/modules/auth/register/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}
