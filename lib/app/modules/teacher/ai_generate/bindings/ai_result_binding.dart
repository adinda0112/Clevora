import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/ai_result_controller.dart';

class AiResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiResultController>(() => AiResultController());
  }
}
