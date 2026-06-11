import 'package:get/get.dart';
import 'package:clevora/app/modules/auth/complete_profile/controllers/complete_profile_controller.dart';

class CompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteProfileController>(() => CompleteProfileController());
  }
}
