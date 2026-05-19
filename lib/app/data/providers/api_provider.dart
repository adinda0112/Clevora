import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:clevora/app/routes/api.dart';

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
          // General error handler - can capture 401 and trigger logout if needed
          return handler.next(e);
        },
      ),
    );
  }
}
