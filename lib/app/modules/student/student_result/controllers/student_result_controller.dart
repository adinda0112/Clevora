import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class StudentResultController extends GetxController {
  final score = 85.obs;
  final correctAnswers = 17.obs;
  final wrongAnswers = 3.obs;
  final totalQuestions = 20.obs;

  void backToDashboard() {
    Get.offAllNamed(Routes.STUDENT_MAIN);
  }
}
