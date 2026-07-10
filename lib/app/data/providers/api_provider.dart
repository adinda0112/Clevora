import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clevora/app/routes/api.dart';
import 'package:clevora/app/routes/app_routes.dart';

class ApiProvider {
  late final Dio dio;
  final GetStorage _storage = GetStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiProvider() {
    dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.type == DioExceptionType.connectionTimeout || 
              e.type == DioExceptionType.receiveTimeout || 
              e.type == DioExceptionType.connectionError) {
            getx.Get.snackbar(
              'Koneksi Gagal',
              'Periksa koneksi internet Anda.',
              snackPosition: getx.SnackPosition.BOTTOM,
            );
          } else if (e.response?.statusCode == 401) {
            await _secureStorage.delete(key: 'token');
            _storage.remove('user');
            if (getx.Get.currentRoute != Routes.LOGIN) {
              getx.Get.offAllNamed(Routes.LOGIN);
            }
          } else if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
            getx.Get.snackbar(
              'Server Error',
              'Terjadi kesalahan pada server. Coba beberapa saat lagi.',
              snackPosition: getx.SnackPosition.BOTTOM,
            );
          }
          return handler.next(e);
        },
      ),
    );
  }
}
