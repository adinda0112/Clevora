import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';

import 'package:clevora/app/data/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  void _checkAutoLogin() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final authService = Get.find<AuthService>();
    if (authService.token.isNotEmpty) {
      await authService.autoLogin();
    }
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  void goToRegister() {
    Get.offAllNamed(Routes.REGISTER);
  }
}
