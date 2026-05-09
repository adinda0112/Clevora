import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/generating_state_controller.dart';

class GeneratingStateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneratingStateController>(() => GeneratingStateController());
  }
}
