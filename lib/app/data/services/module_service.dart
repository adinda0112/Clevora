import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/models/module_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class ModuleService extends GetxService {
  final ApiProvider _apiProvider = ApiProvider();

  // Get all learning modules
  Future<List<ModuleModel>> getModules() async {
    try {
      final response = await _apiProvider.dio.get('/modul');
      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ModuleModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get module by ID
  Future<ModuleModel> getModuleById(String id) async {
    try {
      final response = await _apiProvider.dio.get('/modul/$id');
      if (response.data != null && response.data['data'] != null) {
        return ModuleModel.fromJson(response.data['data']);
      }
      throw 'Gagal memuat detail modul';
    } catch (e) {
      rethrow;
    }
  }

  // Create learning module (Guru)
  Future<ModuleModel> createModule({
    required String judul,
    required String konten,
    String? deskripsi,
    String? mapel,
    String? jenjang,
    String? kelas,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/modul',
        data: {
          'judul': judul,
          'konten': konten,
          'deskripsi': deskripsi,
          'mapel': mapel,
          'jenjang': jenjang,
          'kelas': kelas,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        return ModuleModel.fromJson(response.data['data']);
      }
      throw 'Gagal membuat modul';
    } catch (e) {
      rethrow;
    }
  }

  // Update learning module (Guru)
  Future<ModuleModel> updateModule(
    String id, {
    String? judul,
    String? konten,
    String? deskripsi,
    String? mapel,
    String? jenjang,
    String? kelas,
  }) async {
    try {
      final response = await _apiProvider.dio.put(
        '/modul/$id',
        data: {
          if (judul != null) 'judul': judul,
          if (konten != null) 'konten': konten,
          if (deskripsi != null) 'deskripsi': deskripsi,
          if (mapel != null) 'mapel': mapel,
          if (jenjang != null) 'jenjang': jenjang,
          if (kelas != null) 'kelas': kelas,
        },
      );
      if (response.data != null && response.data['data'] != null) {
        return ModuleModel.fromJson(response.data['data']);
      }
      throw 'Gagal memperbarui modul';
    } catch (e) {
      rethrow;
    }
  }

  // Delete learning module (Guru)
  Future<bool> deleteModule(String id) async {
    try {
      final response = await _apiProvider.dio.delete('/modul/$id');
      return response.data != null && response.data['success'] == true;
    } catch (e) {
      rethrow;
    }
  }

  // Generate learning materials or quizzes using Gemini AI
  Future<String> generateAiDevice({
    required String type,
    required String topic,
    required String kelas,
    required String mapel,
    String? additionalPrompt,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/ai/generate',
        data: {
          'type': type,
          'topic': topic,
          'kelas': kelas,
          'mapel': mapel,
          'additionalPrompt': additionalPrompt,
        },
      );
      if (response.data != null && response.data['data'] != null && response.data['data']['result'] != null) {
        return response.data['data']['result'];
      }
      throw 'Gagal mendapatkan hasil AI';
    } catch (e) {
      rethrow;
    }
  }
}
