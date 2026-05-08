import 'dart:async';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final otpCode = ''.obs;
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final countdown = 300.obs;
  final canResend = false.obs;

  late Timer _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    canResend.value = false;
    countdown.value = 300;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        _countdownTimer.cancel();
      }
    });
  }

  String get countdownFormatted {
    final minutes = countdown.value ~/ 60;
    final seconds = countdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verify() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    isSuccess.value = true;
    await Future.delayed(const Duration(seconds: 1));
    Get.offAllNamed(Routes.HOME);
  }

  void resendOtp() {
    if (canResend.value) {
      _startCountdown();
    }
  }

  @override
  void onClose() {
    _countdownTimer.cancel();
    super.onClose();
  }
}
