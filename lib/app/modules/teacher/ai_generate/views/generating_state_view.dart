import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/generating_state_controller.dart';

class GeneratingStateView extends GetView<GeneratingStateController> {
  const GeneratingStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.primaryPurple,
                  strokeWidth: 4,
                ),
              ),
              const Gap(40),
              Obx(() => Text(
                'AI sedang membuat ${controller.generateType.value}...',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                textAlign: TextAlign.center,
              )),
              const Gap(12),
              Obx(() => Text(
                controller.statusText.value,
                style: const TextStyle(fontSize: 14, color: AppColors.grey600),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
