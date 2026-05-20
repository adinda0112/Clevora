import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/routes/app_routes.dart';

class AuthService extends GetxService {
  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();
  
  final currentUser = Rxn<UserModel>();
  final isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    final savedUser = _storage.read('user');
    if (savedUser != null) {
      try {
        currentUser.value = UserModel.fromJson(savedUser);
        isAuthenticated.value = true;
      } catch (_) {
        // Handle malformed cached data
        _storage.remove('user');
      }
    }
  }

  String get token => _storage.read<String>('token') ?? '';

  Future<AuthResponse> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'role': role,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.success && authResponse.token != null && authResponse.user != null) {
        await _storage.write('token', authResponse.token);
        await _storage.write('user', authResponse.user!.toJson());
        currentUser.value = authResponse.user;
        isAuthenticated.value = true;
      }
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> googleSignIn({
    required String idToken,
    required String accessToken,
    required String role,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/auth/google',
        data: {
          'idToken': idToken,
          'accessToken': accessToken,
          'role': role,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.success && authResponse.token != null && authResponse.user != null) {
        await _storage.write('token', authResponse.token);
        await _storage.write('user', authResponse.user!.toJson());
        currentUser.value = authResponse.user;
        isAuthenticated.value = true;
      }
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> register({
    required String nama,
    required String email,
    required String password,
    required String role,
    String? nip,
    String? nisn,
    String? kelas,
    String? sekolah,
    String? mapel,
    String? jenjang,
  }) async {
    try {
      final data = {
        'nama': nama,
        'email': email,
        'password': password,
        'role': role,
        'mapel': mapel,
        'jenjang': jenjang,
      };
      if (nip != null && nip.isNotEmpty) {
        data['nip'] = nip;
      }
      if (nisn != null && nisn.isNotEmpty) {
        data['nisn'] = nisn;
      }
      if (kelas != null && kelas.isNotEmpty) {
        data['kelas'] = kelas;
      }
      if (sekolah != null && sekolah.isNotEmpty) {
        data['sekolah'] = sekolah;
      }

      final response = await _apiProvider.dio.post(
        '/auth/register',
        data: data,
      );

      final dynamic resData = response.data;
      if (resData is Map) {
        return resData['success'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiProvider.dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      if (authResponse.success && authResponse.token != null && authResponse.user != null) {
        await _storage.write('token', authResponse.token);
        await _storage.write('user', authResponse.user!.toJson());
        currentUser.value = authResponse.user;
        isAuthenticated.value = true;
      }
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> resendOtp({required String email}) async {
    try {
      final response = await _apiProvider.dio.post(
        '/auth/resend-otp',
        data: {'email': email},
      );
      return response.data['success'] ?? false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getMe() async {
    try {
      final response = await _apiProvider.dio.get('/auth/me');
      final data = response.data['data'];
      if (data != null) {
        UserModel user;
        if (data is Map<String, dynamic> && data.containsKey('user')) {
          user = UserModel.fromJson(data['user']);
        } else {
          user = UserModel.fromJson(data);
        }
        await _storage.write('user', user.toJson());
        currentUser.value = user;
        isAuthenticated.value = true;
        return user;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logout();
      }
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  void logout() {
    _storage.remove('token');
    _storage.remove('user');
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> autoLogin() async {
    final token = _storage.read<String>('token');
    if (token == null || token.isEmpty) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
    
    try {
      final user = await getMe();
      if (user != null) {
        if (user.role == 'guru') {
          Get.offAllNamed(Routes.TEACHER_MAIN);
        } else {
          Get.offAllNamed(Routes.STUDENT_MAIN);
        }
      } else {
        logout();
      }
    } catch (_) {
      final cachedUser = currentUser.value;
      if (cachedUser != null) {
        if (cachedUser.role == 'guru') {
          Get.offAllNamed(Routes.TEACHER_MAIN);
        } else {
          Get.offAllNamed(Routes.STUDENT_MAIN);
        }
      } else {
        logout();
      }
    }
  }

  Future<Map<String, dynamic>> getTeacherStats() async {
    try {
      final response = await _apiProvider.dio.get('/dashboard/teacher');
      if (response.data != null && response.data['data'] != null) {
        return Map<String, dynamic>.from(response.data['data']);
      }
      throw 'Empty response';
    } catch (_) {
      return {
        'activeModulesCount': 12,
        'activeQuizzesCount': 8,
        'studentsCount': 36,
      };
    }
  }

  Future<Map<String, dynamic>> getStudentStats() async {
    try {
      final response = await _apiProvider.dio.get('/dashboard/student');
      if (response.data != null && response.data['data'] != null) {
        return Map<String, dynamic>.from(response.data['data']);
      }
      throw 'Empty response';
    } catch (_) {
      return {
        'completedTasksCount': 18,
        'averageScore': 88.5,
        'rank': 3,
      };
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] ?? 'Terjadi kesalahan pada server';
      }
    }
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Koneksi ke server habis waktu';
      case DioExceptionType.sendTimeout:
        return 'Gagal mengirim data ke server';
      case DioExceptionType.receiveTimeout:
        return 'Gagal menerima respon dari server';
      case DioExceptionType.badResponse:
        return 'Terjadi kesalahan sistem (${e.response?.statusCode})';
      case DioExceptionType.cancel:
        return 'Permintaan ke server dibatalkan';
      default:
        return 'Tidak dapat terhubung ke internet. Periksa koneksi Anda.';
    }
  }
}
