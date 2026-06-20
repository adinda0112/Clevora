import 'package:get/get.dart';
import '../controllers/teacher_history_controller.dart';

class TeacherHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherHistoryController>(() => TeacherHistoryController());
  }
}
