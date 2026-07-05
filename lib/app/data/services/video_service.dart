import 'package:clevora/app/data/providers/api_provider.dart';

class VideoService {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<dynamic>> getVideos() async {
    try {
      final response = await _apiProvider.dio.get('/videos');
      if (response.statusCode == 200) {
        return response.data['data'] as List<dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil video');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }
}
