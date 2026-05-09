import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class StudentQuizView extends StatelessWidget {
  const StudentQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz & Ujian', style: TextStyle(color: AppColors.darkPurple))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment, size: 64, color: AppColors.primaryPurple),
            const Gap(20),
            const Text('UAS - Basis Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
            const Gap(8),
            const Text('Tersedia untuk dikerjakan', style: TextStyle(color: AppColors.grey600)),
            const Gap(30),
            ElevatedButton(
              onPressed: () => Get.toNamed('/exam-instruction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Mulai Ujian (Simulasi)', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
