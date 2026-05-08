import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  late AuthRepository _authRepository;

  @override
  void onInit() {
    super.onInit();
    _authRepository = Get.find<AuthRepository>();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_authRepository.isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}
