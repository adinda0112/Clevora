import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/widgets/camera_dialog.dart';

class ExamInstructionController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final isChecked = false.obs;
  final quiz = Rxn<QuizModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    quiz.value = Get.arguments as QuizModel?;
  }

  void toggleCheck(bool? value) {
    if (value != null) isChecked.value = value;
  }

  Future<void> startExam() async {
    if (quiz.value == null || isLoading.value) return;

    isLoading.value = true;
    try {
      // 1. Initialize result session in DB to get a resultId
      final resultData = await _quizService.startQuiz(quiz.value!.id);
      final resultId = resultData['_id'] ?? resultData['id'] ?? '';

      // 2. Trigger face verification dialog
      final isVerified = await Get.dialog<bool>(
        const CameraDialog(title: 'Verifikasi Wajah Sebelum Mulai'),
        barrierDismissible: false,
      );

      if (isVerified == true) {
        Get.offNamed(
          Routes.STUDENT_EXAM,
          arguments: {
            'quiz': quiz.value,
            'resultId': resultId,
          },
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memulai sesi ujian: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
