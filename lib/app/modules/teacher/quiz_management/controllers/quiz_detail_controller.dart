import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';

class QuizDetailController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  
  final quizId = ''.obs;
  final quiz = Rxn<QuizModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String?;
    if (id != null) {
      quizId.value = id;
      fetchQuizDetail();
    } else {
      errorMessage.value = 'ID Kuis tidak ditemukan';
    }
  }

  Future<void> fetchQuizDetail() async {
    if (quizId.value.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _quizService.getQuizById(quizId.value);
      quiz.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
