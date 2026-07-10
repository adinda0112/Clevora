import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/data/repositories/auth_repository.dart';
import 'package:clevora/app/routes/app_routes.dart';

class AuthService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  final currentUser = Rxn<UserModel>();
  final isAuthenticated = false.obs;
  final rxToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final savedToken = await _secureStorage.read(key: 'token');
    if (savedToken != null && savedToken.isNotEmpty) {
      rxToken.value = savedToken;
    }

    final savedUserString = await _secureStorage.read(key: 'user');
    if (savedUserString != null) {
      try {
        final savedUser = jsonDecode(savedUserString);
        currentUser.value = UserModel.fromJson(savedUser);
        isAuthenticated.value = true;
      } catch (_) {
        // Handle malformed cached data
        await _secureStorage.delete(key: 'user');
      }
    }
  }

  String get token => rxToken.value;

  Future<void> _saveSession(AuthResponse authResponse) async {
    if (authResponse.token != null && authResponse.user != null) {
      await _secureStorage.write(key: 'token', value: authResponse.token);
      rxToken.value = authResponse.token!;
      await _secureStorage.write(key: 'user', value: jsonEncode(authResponse.user!.toJson()));
      currentUser.value = authResponse.user;
      isAuthenticated.value = true;
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _authRepository.login(email, password, role);
      final authResponse = AuthResponse.fromJson(response);
      await _saveSession(authResponse);
      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 && e.response?.data?['unverified'] == true) {
        final email = e.response?.data?['email'] ?? '';
        resendOtp(email: email);
        Get.toNamed(Routes.OTP, arguments: {'email': email});
      }
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
      final response = await _authRepository.googleSignIn(idToken, accessToken, role);
      final authResponse = AuthResponse.fromJson(response);
      await _saveSession(authResponse);
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
    String? jurusan,
  }) async {
    try {
      final data = {
        'nama': nama,
        'email': email,
        'password': password,
        'role': role,
        'mapel': mapel,
        'jurusan': jurusan,
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

      final response = await _authRepository.register(data);
      return response['success'] ?? false;
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
      final response = await _authRepository.verifyOtp(email, otp);
      final authResponse = AuthResponse.fromJson(response);
      await _saveSession(authResponse);
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

  Future<bool> forgotPassword({required String email}) async {
    try {
      final response = await _authRepository.forgotPassword(email);
      return response['success'] ?? false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _authRepository.resetPassword(email, otp, newPassword);
      return response['success'] ?? false;
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
        await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
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

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiProvider.dio.put(
        '/auth/update/$id',
        data: data,
      );
      
      if (response.data['success'] == true) {
        final updatedUser = UserModel.fromJson(response.data['data']);
        await _secureStorage.write(key: 'user', value: jsonEncode(updatedUser.toJson()));
        currentUser.value = updatedUser;
      } else {
        throw response.data['message'] ?? 'Gagal memperbarui profil';
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateCurrentUserState(UserModel updatedUser) async {
    await _secureStorage.write(key: 'user', value: jsonEncode(updatedUser.toJson()));
    currentUser.value = updatedUser;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'user');
    rxToken.value = '';
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  void _navigateBasedOnRole(UserModel user) {
    if (!user.isProfileComplete) {
      Get.offAllNamed(Routes.COMPLETE_PROFILE);
    } else {
      Get.offAllNamed(user.role == 'guru' ? Routes.TEACHER_MAIN : Routes.STUDENT_MAIN);
    }
  }

  Future<void> autoLogin() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null || token.isEmpty) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
    
    try {
      final user = await getMe();
      if (user != null) {
        _navigateBasedOnRole(user);
      } else {
        logout();
      }
    } catch (_) {
      final cachedUser = currentUser.value;
      if (cachedUser != null) {
        _navigateBasedOnRole(cachedUser);
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
