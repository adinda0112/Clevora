import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/teacher_main/controllers/teacher_main_controller.dart';
import 'package:clevora/app/modules/teacher/dashboard/controllers/teacher_home_controller.dart';
import 'package:clevora/app/modules/shared/profile/controllers/profile_controller.dart';

class TeacherMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherMainController>(() => TeacherMainController());
    Get.lazyPut<TeacherHomeController>(() => TeacherHomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
