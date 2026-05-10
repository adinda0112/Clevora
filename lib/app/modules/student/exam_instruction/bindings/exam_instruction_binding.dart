import 'package:get/get.dart';
import 'package:clevora/app/modules/student/exam_instruction/controllers/exam_instruction_controller.dart';

class ExamInstructionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamInstructionController>(() => ExamInstructionController());
  }
}
