import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';

class StudentQuizController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();

  final quizzes = <QuizModel>[].obs;
  final isLoading = false.obs;
  final completedQuizIds = <String>{}.obs;

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
      if (fetched.isNotEmpty) {
        // Mocking the first quiz as completed for demonstration
        completedQuizIds.add(fetched.first.id);
      }
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

  bool isCompleted(String quizId) {
    return completedQuizIds.contains(quizId);
  }
}
