import 'package:get/get.dart';
import 'package:clevora/app/modules/student/student_quiz/controllers/student_quiz_controller.dart';

class StudentQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentQuizController>(() => StudentQuizController());
  }
}
