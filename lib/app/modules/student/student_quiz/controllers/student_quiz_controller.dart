import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/hasil_service.dart';

class StudentQuizController extends GetxController {
  final QuizService _quizService = Get.find<QuizService>();
  final HasilService _hasilService = Get.find<HasilService>();

  final quizzes = <QuizModel>[].obs;
  final isLoading = false.obs;
  final completedQuizIds = <String>{}.obs;
  final resultDataMap = <String, Map<String, dynamic>>{}.obs;

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
    isLoading.value = true;
    try {
      final fetched = await _quizService.getQuizzes();
      quizzes.assignAll(fetched);

      // Fetch actual completed results to determine which quizzes are done
      final results = await _hasilService.getHasil();
      resultDataMap.clear();
      completedQuizIds.clear();
      for (final r in results) {
        final qId = r.kuis is Map ? r.kuis['_id'] ?? r.kuis['id'] ?? '' : '';
        if (qId.isNotEmpty) {
          completedQuizIds.add(qId);
          resultDataMap[qId] = {
            'quizTitle': r.kuisJudul,
            'nilai': r.nilai,
            'benar': r.benar,
            'salah': r.salah,
          };
        }
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

  Map<String, dynamic>? getResultData(String quizId) {
    return resultDataMap[quizId];
  }
}
