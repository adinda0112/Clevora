import 'package:get/get.dart';
import 'package:clevora/app/modules/student/learning/controllers/learning_controller.dart';

class LearningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearningController>(() => LearningController());
  }
}
