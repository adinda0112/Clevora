import 'package:get/get.dart';
import 'package:clevora/app/modules/student/student_main/controllers/student_main_controller.dart';
import 'package:clevora/app/modules/student/dashboard/controllers/student_home_controller.dart';
import 'package:clevora/app/modules/student/student_result/controllers/student_result_controller.dart';
import 'package:clevora/app/modules/shared/profile/controllers/profile_controller.dart';
import 'package:clevora/app/modules/student/learning/controllers/learning_controller.dart';
import 'package:clevora/app/modules/student/student_quiz/controllers/student_quiz_controller.dart';

class StudentMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentMainController>(() => StudentMainController());
    Get.lazyPut<StudentHomeController>(() => StudentHomeController());
    Get.lazyPut<StudentResultController>(() => StudentResultController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<LearningController>(() => LearningController());
    Get.lazyPut<StudentQuizController>(() => StudentQuizController());
  }
}
