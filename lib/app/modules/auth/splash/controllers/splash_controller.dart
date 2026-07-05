import 'package:get/get.dart';
import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}
