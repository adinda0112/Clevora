import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class QuizManagementController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final AuthService _authService = Get.find<AuthService>();

  final quizzes = <QuizModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final activeFilter = 'Semua'.obs;

  List<QuizModel> get filteredQuizzes {
    if (activeFilter.value == 'Semua') {
      return quizzes;
    }
    return quizzes.where((q) {
      final judulLower = q.judul.toLowerCase();
      if (activeFilter.value == 'Pretest') return judulLower.contains('pretest');
      if (activeFilter.value == 'Posttest') return judulLower.contains('posttest');
      if (activeFilter.value == 'Ujian') return judulLower.contains('ujian') || judulLower.contains('uts') || judulLower.contains('uas');
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final allQuizzes = await _quizService.getQuizzes();
      final currentUser = _authService.currentUser.value;
      
      if (currentUser != null && currentUser.role == 'guru') {
        // Filter quizzes created by this teacher
        quizzes.value = allQuizzes.where((q) => q.guru?.id == currentUser.id).toList();
      } else {
        quizzes.value = allQuizzes;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
