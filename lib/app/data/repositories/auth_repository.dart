import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  final ApiProvider apiProvider;
  final _storage = GetStorage();

  AuthRepository({required this.apiProvider});

  bool get isLoggedIn => _storage.hasData('token') && _storage.hasData('user');

  UserModel? get currentUser {
    final userData = _storage.read('user');

    if (userData != null) {
      return UserModel.fromJson(userData as Map<String, dynamic>);
    }

    return null;
  }

  Future<({bool success, String? message, UserModel? user})> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await apiProvider.login(
      email: email,
      password: password,
      role: role,
    );

    if (result['success']) {
      final user = UserModel.fromJson(result['data']['user']);
      final token = result['data']['token'];

      _storage.write('user', user.toJson());
      _storage.write('token', token);

      return (success: true, message: null, user: user);
    } else {
      return (
        success: false,
        message: result['message']?.toString(),
        user: null,
      );
    }
  }

  Future<({bool success, String? message})> register(
    Map<String, dynamic> data,
  ) async {
    final result = await apiProvider.register(data);

    if (result['success']) {
      return (success: true, message: null);
    } else {
      return (success: false, message: result['message']?.toString());
    }
  }

  Future<({bool success, String? message, UserModel? user})> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await apiProvider.verifyOtp(email: email, otp: otp);

    if (result['success']) {
      final user = UserModel.fromJson(result['data']['user']);
      final token = result['data']['token'];

      _storage.write('user', user.toJson());
      _storage.write('token', token);

      return (success: true, message: null, user: user);
    } else {
      return (
        success: false,
        message: result['message']?.toString(),
        user: null,
      );
    }
  }

  Future<({bool success, String? message})> resendOtp({
    required String email,
  }) async {
    final result = await apiProvider.resendOtp(email: email);

    if (result['success']) {
      return (success: true, message: null);
    } else {
      return (success: false, message: result['message']?.toString());
    }
  }

  Future<void> logout() async {
    await _storage.erase();
  }
}
