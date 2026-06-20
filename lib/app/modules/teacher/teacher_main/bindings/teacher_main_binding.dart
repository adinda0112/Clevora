import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/teacher_main/controllers/teacher_main_controller.dart';
import 'package:clevora/app/modules/teacher/dashboard/controllers/teacher_home_controller.dart';
import 'package:clevora/app/modules/shared/profile/controllers/profile_controller.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import 'package:clevora/app/modules/teacher/report/controllers/report_controller.dart';

class TeacherMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherMainController>(() => TeacherMainController());
    Get.lazyPut<TeacherHomeController>(() => TeacherHomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<HasilService>(() => HasilService());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
