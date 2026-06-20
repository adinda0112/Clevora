import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class FaceService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  /// Register user face
  Future<String> registerFace(String imagePath) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _apiProvider.dio.post(
        '/face/register',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data != null && response.data['foto_wajah_url'] != null) {
        return response.data['foto_wajah_url'];
      }
      throw 'Gagal mendaftarkan wajah';
    } catch (e) {
      rethrow;
    }
  }

  /// Verify user face (Pretest, Posttest, Exam start)
  Future<bool> verifyFace(String imagePath) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _apiProvider.dio.post(
        '/face/verify',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data != null && response.data['verified'] != null) {
        return response.data['verified'] as bool;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Send live exam proctoring frame
  Future<Map<String, dynamic>> sendProctorFrame(
    String resultId,
    String imagePath,
  ) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'resultId': resultId,
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _apiProvider.dio.post(
        '/face/proctor',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data != null) {
        return Map<String, dynamic>.from(response.data);
      }
      throw 'Gagal mengirim data proctoring';
    } catch (e) {
      rethrow;
    }
  }
}
