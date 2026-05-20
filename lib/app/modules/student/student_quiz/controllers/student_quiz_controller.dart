import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';

class StudentQuizController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();

  final quizzes = <QuizModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    isLoading.value = true;
    try {
      final fetched = await _quizService.getQuizzes();
      quizzes.assignAll(fetched);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat kuis: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
