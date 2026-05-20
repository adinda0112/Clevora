import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/quiz_model.dart';
import 'package:clevora/app/data/models/question_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class QuizService extends GetxService {
  final ApiProvider _apiProvider = ApiProvider();

  // Get all quizzes
  Future<List<QuizModel>> getQuizzes() async {
    try {
      final response = await _apiProvider.dio.get('/kuis');
      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => QuizModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get quiz by ID (with questions)
  Future<QuizModel> getQuizById(String id) async {
    try {
      final response = await _apiProvider.dio.get('/kuis/$id');
      if (response.data != null && response.data['data'] != null) {
        return QuizModel.fromJson(response.data['data']);
      }
      throw 'Gagal memuat detail kuis';
    } catch (e) {
      rethrow;
    }
  }

  // Create new quiz (Guru)
  Future<QuizModel> createQuiz({
    required String judul,
    String? deskripsi,
    String? mapel,
    String? kelas,
    int? durasi,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/kuis',
        data: {
          'judul': judul,
          'deskripsi': deskripsi,
          'mapel': mapel,
          'kelas': kelas,
          'durasi': durasi ?? 30,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        return QuizModel.fromJson(response.data['data']);
      }
      throw 'Gagal membuat kuis';
    } catch (e) {
      rethrow;
    }
  }

  // Add question to quiz (Guru)
  Future<QuestionModel> addQuestion(
    String quizId, {
    required String pertanyaan,
    required List<String> pilihan,
    required int kunciJawaban,
    String? penjelasan,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/kuis/$quizId/soal',
        data: {
          'pertanyaan': pertanyaan,
          'pilihan': pilihan,
          'kunciJawaban': kunciJawaban,
          'penjelasan': penjelasan,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        return QuestionModel.fromJson(response.data['data']);
      }
      throw 'Gagal menambahkan soal kuis';
    } catch (e) {
      rethrow;
    }
  }

  // Submit quiz / grading (Siswa)
  Future<Map<String, dynamic>> submitQuiz(
    String quizId, {
    required List<Map<String, dynamic>> jawaban,
    required int durasiPengerjaan,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/kuis/$quizId/submit',
        data: {
          'jawaban': jawaban,
          'durasiPengerjaan': durasiPengerjaan,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        return Map<String, dynamic>.from(response.data['data']);
      }
      throw 'Gagal mengumpulkan kuis';
    } catch (e) {
      rethrow;
    }
  }
}
