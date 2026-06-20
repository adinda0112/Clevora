import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/attendance/controllers/attendance_history_controller.dart';

class AttendanceHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceHistoryController());
  }
}
