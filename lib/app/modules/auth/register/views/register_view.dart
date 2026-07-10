import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/data/utils/validation_helper.dart';
import 'package:clevora/app/modules/auth/register/controllers/register_controller.dart';

part '../widgets/register_form_widgets.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controller.currentStep.value > 0) {
          controller.prevStep();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.currentStep.value > 0) {
                controller.prevStep();
              } else {
                Get.back();
              }
            },
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Daftar Akun',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Ikuti langkah berikut untuk membuat akun',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(32),

              // Step Indicator
              Obx(
                () => _StepIndicator(currentStep: controller.currentStep.value),
              ),
              const Gap(32),

              // Step Content
              Obx(() {
                if (controller.currentStep.value == 0) {
                  return _Step0RoleSelection(controller: controller);
                } else {
                  return _Step1DataForm(controller: controller);
                }
              }),
              const Gap(32),

              // Navigation Buttons
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.nextStep(),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    controller.currentStep.value == 0
                                        ? 'Lanjut'
                                        : 'Daftar',
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.offNamed(Routes.LOGIN),
                        child: Text(
                          'Sudah punya akun? Login',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
