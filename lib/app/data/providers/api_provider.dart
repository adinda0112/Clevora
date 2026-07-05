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
          // Global 401 Unauthorized / Token Expired handler
          if (e.response?.statusCode == 401) {
            await _secureStorage.delete(key: 'token');
            _storage.remove('user');
            // Safely redirect to Login view only if not already on Login view
            if (getx.Get.currentRoute != Routes.LOGIN) {
              getx.Get.offAllNamed(Routes.LOGIN);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
