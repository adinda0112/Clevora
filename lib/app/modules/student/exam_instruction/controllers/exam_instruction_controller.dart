import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class ExamInstructionController extends GetxController {
  final isChecked = false.obs;

  void toggleCheck(bool? value) {
    if (value != null) isChecked.value = value;
  }

  void startExam() {
    Get.offNamed(Routes.STUDENT_EXAM);
  }
}
