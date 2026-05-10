import 'package:get/get.dart';
import 'package:clevora/app/modules/student/student_result/controllers/student_result_controller.dart';

class StudentResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentResultController>(() => StudentResultController());
  }
}
