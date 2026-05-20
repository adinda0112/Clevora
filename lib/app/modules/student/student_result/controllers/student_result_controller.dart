import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

class StudentResultController extends GetxController {
  final quizTitle = 'Ujian'.obs;
  final score = 0.obs;
  final correctAnswers = 0.obs;
  final wrongAnswers = 0.obs;
  final totalQuestions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      quizTitle.value = args['quizTitle'] ?? 'Ujian';
      score.value = args['nilai'] ?? 0;
      correctAnswers.value = args['benar'] ?? 0;
      wrongAnswers.value = args['salah'] ?? 0;
      totalQuestions.value = correctAnswers.value + wrongAnswers.value;
    }
  }

  void backToDashboard() {
    Get.offAllNamed(Routes.STUDENT_MAIN);
  }
}
