import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final selectedRole = 'guru'.obs;
  final obscurePass = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  
  final formKey = GlobalKey<FormState>();
  
  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // clientId untuk Android menggunakan OAuth Client ID Android
    clientId: '1010800204753-vvtcn31b97tcuh11dvdmgug6s5nsrog5.apps.googleusercontent.com',
    // serverClientId menggunakan OAuth Client ID Web (untuk backend)
    serverClientId: '1010800204753-glai8s9np44650vitoddu81c2r0uvqve.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // State untuk status Google Login
  final isGoogleLoading = false.obs;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;

      final result = await _authService.login(
        email: email,
        password: password,
        role: selectedRole.value,
      );

      if (!result.success) {
        throw Exception(result.message);
      }

      Get.snackbar(
        "Berhasil",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Redirect ke halaman sesuai role yang dikembalikan backend
      final userRole = _authService.currentUser.value?.role ?? selectedRole.value;
      if (userRole == 'guru') {
        Get.offAllNamed(Routes.TEACHER_MAIN);
      } else {
        Get.offAllNamed(Routes.STUDENT_MAIN);
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      Get.snackbar(
        "Login Gagal",
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isGoogleLoading.value = true;

      // SignIn dengan Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancel
        Get.snackbar(
          "Info",
          "Login Google dibatalkan",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Dapatkan ID Token dan Access Token
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception("Gagal mendapatkan token dari Google");
      }

      // Panggil endpoint Google Sign-In dari backend
      final result = await _authService.googleSignIn(
        idToken: idToken,
        accessToken: accessToken,
        role: selectedRole.value,
      );

      if (!result.success) {
        throw Exception(result.message);
      }

      Get.snackbar(
        "Berhasil",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Redirect ke halaman sesuai role
      final user = _authService.currentUser.value;
      final userRole = user?.role ?? selectedRole.value;

      bool isIncomplete = false;
      if (user != null) {
        if (userRole == 'guru') {
          isIncomplete = (user.nip == null || user.nip!.isEmpty);
        } else {
          isIncomplete = (user.nisn == null || user.nisn!.isEmpty || user.kelas == null || user.kelas!.isEmpty);
        }
      }

      if (isIncomplete) {
        Get.offAllNamed(Routes.COMPLETE_PROFILE);
      } else {
        if (userRole == 'guru') {
          Get.offAllNamed(Routes.TEACHER_MAIN);
        } else {
          Get.offAllNamed(Routes.STUDENT_MAIN);
        }
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      Get.snackbar(
        "Login Google Gagal",
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }
}