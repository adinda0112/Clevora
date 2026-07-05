import 'package:get/get.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/data/models/user_model.dart';

class ProfilService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<UserModel> updateProfil({String? nama, String? email, String? fotoProfilBase64}) async {
    try {
      final Map<String, dynamic> data = {};
      if (nama != null) data['nama'] = nama;
      if (email != null) data['email'] = email;
      if (fotoProfilBase64 != null) data['fotoProfilBase64'] = fotoProfilBase64;

      final response = await _apiProvider.dio.put('/profil', data: data);
      if (response.data != null && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception(response.data?['message'] ?? 'Gagal memperbarui profil');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(String passwordLama, String passwordBaru) async {
    try {
      final response = await _apiProvider.dio.put('/profil/password', data: {
        'passwordLama': passwordLama,
        'passwordBaru': passwordBaru,
      });
      if (response.data == null || response.data['success'] != true) {
        throw Exception(response.data?['message'] ?? 'Gagal mengubah password');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutAll() async {
    try {
      final response = await _apiProvider.dio.post('/profil/logout-all');
      if (response.data == null || response.data['success'] != true) {
        throw Exception(response.data?['message'] ?? 'Gagal melakukan logout semua perangkat');
      }
    } catch (e) {
      rethrow;
    }
  }
}
