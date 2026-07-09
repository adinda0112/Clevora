import 'package:dio/dio.dart';
import 'package:clevora/app/data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider apiProvider;

  AuthRepository(this.apiProvider);

  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    final response = await apiProvider.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
      'role': role
    });
    return response.data;
  }

  Future<Map<String, dynamic>> googleSignIn(String idToken, String accessToken, String role) async {
    final response = await apiProvider.dio.post('/auth/google', data: {
      'idToken': idToken,
      'accessToken': accessToken,
      'role': role,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await apiProvider.dio.post('/auth/register', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await apiProvider.dio.post('/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await apiProvider.dio.post('/auth/forgot-password', data: {
      'email': email,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword) async {
    final response = await apiProvider.dio.post('/auth/reset-password', data: {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });
    return response.data;
  }
}
