import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/routes/app_routes.dart';

class ExamInstructionController extends GetxController {
  final isChecked = false.obs;
  final quiz = Rxn<QuizModel>();

  @override
  void onInit() {
    super.onInit();
    quiz.value = Get.arguments as QuizModel?;
  }

  void toggleCheck(bool? value) {
    if (value != null) isChecked.value = value;
  }

  void startExam() {
    if (quiz.value != null) {
      Get.offNamed(Routes.STUDENT_EXAM, arguments: quiz.value);
    } else {
      Get.offNamed(Routes.STUDENT_EXAM);
    }
  }
}
