import 'package:get/get.dart';
import 'package:clevora/app/data/models/module_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:dio/dio.dart' as dio;

class ModuleService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

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
    String? jenis,
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
          'jenis': jenis,
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
      final Map<String, dynamic> reqData = {};
      if (judul != null) reqData['judul'] = judul;
      if (konten != null) reqData['konten'] = konten;
      if (deskripsi != null) reqData['deskripsi'] = deskripsi;
      if (mapel != null) reqData['mapel'] = mapel;
      if (jenjang != null) reqData['jenjang'] = jenjang;
      if (kelas != null) reqData['kelas'] = kelas;

      final response = await _apiProvider.dio.put(
        '/modul/$id',
        data: reqData,
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
  Future<Map<String, dynamic>> generateAiDevice({
    required String type,
    required String topik,
    required String kelas,
    required String mapel,
    String? jurusan,
    String? catatan,
    String? tipeKuis,
    int? jumlahSoal,
    String? referenceFilePath,
  }) async {
    try {
      dynamic data;
      
      final Map<String, dynamic> reqData = {
        'type': type,
        'topik': topik,
        'kelas': kelas,
        'mapel': mapel,
      };

      if (jurusan != null) reqData['jurusan'] = jurusan;
      if (catatan != null) reqData['catatan'] = catatan;
      if (tipeKuis != null) reqData['tipeKuis'] = tipeKuis;
      if (jumlahSoal != null) reqData['jumlahSoal'] = jumlahSoal.toString();

      if (referenceFilePath != null && referenceFilePath.isNotEmpty) {
        reqData['referenceFile'] = await dio.MultipartFile.fromFile(referenceFilePath);
        data = dio.FormData.fromMap(reqData);
      } else {
        data = reqData;
      }

      final response = await _apiProvider.dio.post(
        '/ai/generate',
        data: data,
        options: dio.Options(
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
        ),
      );
      if (response.data != null && response.data['data'] != null && response.data['data']['result'] != null) {
        return {
          'result': response.data['data']['result'],
          'kontenId': response.data['data']['kontenId'],
        };
      }
      throw 'Gagal mendapatkan hasil AI';
    } catch (e) {
      rethrow;
    }
  }

  // Update status history AI in Konten DB
  Future<bool> saveAiHistory(String kontenId, String status, {List<String>? kelasTarget}) async {
    try {
      if (status == 'published' && kelasTarget != null && kelasTarget.isNotEmpty) {
        final response = await _apiProvider.dio.put('/ai/publish/$kontenId', data: {'kelasTarget': kelasTarget});
        return response.statusCode == 200;
      } else {
        final response = await _apiProvider.dio.post('/ai/save', data: {'kontenId': kontenId, 'status': status});
        return response.statusCode == 200;
      }
    } catch (e) {
      print('Gagal update history AI (Bisa diabaikan jika Modul utama tersimpan): $e');
      return false;
    }
  }
}
