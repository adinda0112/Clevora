import 'package:get/get.dart';
import 'package:clevora/app/modules/student/dashboard/controllers/student_home_controller.dart';

class StudentHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentHomeController>(
      () => StudentHomeController(),
    );
  }
}
