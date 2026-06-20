import 'package:get/get.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class AttendanceService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> getAttendance({
    required String kelas,
    int? bulan,
    int? tahun,
  }) async {
    final queryParams = <String, dynamic>{'kelas': kelas};
    if (bulan != null) queryParams['bulan'] = bulan;
    if (tahun != null) queryParams['tahun'] = tahun;

    final response = await _apiProvider.dio.get('/absensi', queryParameters: queryParams);
    if (response.data?['success'] == true) {
      return response.data['data'] ?? {};
    }
    throw response.data?['message'] ?? 'Gagal mengambil data absensi';
  }

  Future<bool> recordAttendance({
    required List<Map<String, dynamic>> records,
    required String tanggal,
    required String kelas,
    String? mapel,
  }) async {
    final response = await _apiProvider.dio.post('/absensi', data: {
      'records': records,
      'tanggal': tanggal,
      'kelas': kelas,
      'mapel': mapel,
    });
    return response.data?['success'] ?? false;
  }
}
