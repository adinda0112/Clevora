import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:clevora/app/routes/api.dart';
import 'package:clevora/app/routes/app_routes.dart';

class ApiProvider {
  late final Dio dio;
  final GetStorage _storage = GetStorage();

  ApiProvider() {
    dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read<String>('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Global 401 Unauthorized / Token Expired handler
          if (e.response?.statusCode == 401) {
            _storage.remove('token');
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
