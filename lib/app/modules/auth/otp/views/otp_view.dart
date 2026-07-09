import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/auth/otp/controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isSuccess.value) {
          return _SuccessWidget(controller: controller);
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.lightTeal,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mail_outline,
                            color: AppColors.teal,
                            size: 32,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Text(
                        'Cek Email Kamu',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Gap(8),
                      Text(
                        'Kami telah mengirim kode verifikasi ke',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Gap(4),
                      Text(
                        controller.countdownFormatted,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const Gap(32),

                // Info Box
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Masukkan 6 digit kode yang kami kirim untuk memverifikasi email Anda',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryPurple,
                          ),
                    ),
                  ),
                ),
                const Gap(32),

                // OTP Input
                Center(child: _buildPinput(context)),
                const Gap(24),

                // Countdown Timer
                Center(
                  child: Obx(() => Text(
                    'Waktu tersisa: ${controller.countdownFormatted}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: controller.countdown.value < 60
                              ? AppColors.red
                              : AppColors.grey600,
                          fontWeight: FontWeight.w600,
                        ),
                  )),
                ),
                const Gap(16),

                // Resend Link
                Center(
                  child: Obx(() => controller.canResend.value
                      ? GestureDetector(
                          onTap: () => controller.resendOtp(),
                          child: Text(
                            'Kirim ulang kode',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        )
                      : Text(
                          'Tunggu untuk mengirim ulang',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.grey400,
                              ),
                        )),
                ),
                const Gap(32),

                // Verify Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.verify(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Verifikasi & Aktivasi Akun'),
                      ),
                    )),
                const Gap(24),

                // Tips Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Belum menerima email?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey900,
                            ),
                      ),
                      const Gap(8),
                      Text(
                        'Cek folder spam atau masuk daftar tunggu untuk memastikan email sudah terdaftar',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
    );
  }

  Widget _buildPinput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.lightPurple,
        border: Border.all(color: AppColors.primaryPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.lightPurple,
        border: Border.all(color: AppColors.primaryPurple),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      onChanged: (value) => controller.otpCode.value = value,
      onCompleted: (pin) => controller.otpCode.value = pin,
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  final dynamic controller;

  const _SuccessWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle,
                color: AppColors.teal,
                size: 60,
              ),
            ),
          ),
          const Gap(24),
          Text(
            'Verifikasi Berhasil!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.teal,
                ),
          ),
          const Gap(12),
          Text(
            'Akun Anda telah diaktifkan\nSelamat datang di Clevora',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(32),
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}
