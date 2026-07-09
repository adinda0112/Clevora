import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/repositories/auth_repository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/widgets/camera_dialog.dart';

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

  final AuthRepository authRepo = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;

      final authResponse = await _authService.login(
        email: email, 
        password: password, 
        role: selectedRole.value
      );
      
      if (!authResponse.success) {
        throw Exception(authResponse.message.isNotEmpty ? authResponse.message : 'Login failed');
      }

      Get.snackbar(
        "Berhasil",
        authResponse.message.isNotEmpty ? authResponse.message : 'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Redirect ke halaman sesuai role yang dikembalikan backend
      final user = _authService.currentUser.value;
      final userRole = user?.role ?? selectedRole.value;
      
      if (userRole == 'guru') {
        Get.offAllNamed(Routes.TEACHER_MAIN);
      } else {
        if (user != null && !user.sudahDaftarWajah) {
          isLoading.value = false; // Set false before showing dialog so UI updates
          await Get.dialog<bool>(
            const CameraDialog(
              title: 'Daftarkan Wajah',
              isRegistration: true,
            ),
            barrierDismissible: false,
          );
          await _authService.getMe();
        }
        Get.offAllNamed(Routes.STUDENT_MAIN);
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      debugPrint("LOGIN ERROR: $msg");
      try {
        Get.snackbar(
          "Login Gagal",
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      } catch (_) {}
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isGoogleLoading.value = true;

      // Sign out dulu agar dialog pilih akun selalu muncul
      await _googleSignIn.signOut();
      // SignIn dengan Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancel
        Get.snackbar(
          "Info",
          "Login Google dibatalkan",
          snackPosition: SnackPosition.BOTTOM,
        );
        isGoogleLoading.value = false;
        return;
      }

      // Dapatkan ID Token dan Access Token
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception("Gagal mendapatkan token dari Google");
      }

      final authResponse = await _authService.googleSignIn(
        idToken: idToken,
        accessToken: accessToken,
        role: selectedRole.value,
      );

      if (!authResponse.success || authResponse.user == null) {
        throw Exception(authResponse.message.isNotEmpty ? authResponse.message : 'Google sign in failed');
      }

      final user = authResponse.user!;

      Get.snackbar(
        "Berhasil",
        authResponse.message.isNotEmpty ? authResponse.message : 'Login Google berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Redirect ke halaman sesuai role
      final userRole = user.role.isNotEmpty ? user.role : selectedRole.value;

      if (!user.isProfileComplete) {
        Get.offAllNamed(Routes.COMPLETE_PROFILE);
      } else {
        if (userRole == 'guru') {
          Get.offAllNamed(Routes.TEACHER_MAIN);
        } else {
          // Prompt face registration for Google siswa if not yet registered
          if (!user.sudahDaftarWajah) {
            isGoogleLoading.value = false; // Set false before dialog
            await Get.dialog<bool>(
              const CameraDialog(
                title: 'Daftarkan Wajah',
                isRegistration: true,
              ),
              barrierDismissible: false,
            );
            await _authService.getMe();
          }
          Get.offAllNamed(Routes.STUDENT_MAIN);
        }
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
      debugPrint("GOOGLE LOGIN ERROR: $msg");
      try {
        Get.snackbar(
          "Login Google Gagal",
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      } catch (_) {}
      isGoogleLoading.value = false;
    }
  }
}