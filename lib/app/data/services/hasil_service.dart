import 'package:get/get.dart';
import 'package:clevora/app/data/models/result_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class HasilService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<ResultModel>> getHasil({String? kelas, String? mapel}) async {
    try {
      String path = '/hasil';
      final params = <String, dynamic>{};
      if (kelas != null) params['kelas'] = kelas;
      if (mapel != null) params['mapel'] = mapel;

      final response = await _apiProvider.dio.get(path, queryParameters: params.isNotEmpty ? params : null);
      if (response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ResultModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
