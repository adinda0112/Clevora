import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/generate_form_controller.dart';

class GenerateFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateFormController>(() => GenerateFormController());
  }
}
