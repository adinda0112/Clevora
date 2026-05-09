import 'package:get/get.dart';
import 'package:clevora/app/modules/student/student_exam/controllers/student_exam_controller.dart';

class StudentExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentExamController>(() => StudentExamController());
  }
}
