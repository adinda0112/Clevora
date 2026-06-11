import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/student/student_result/controllers/student_result_controller.dart';

class StudentResultView extends GetView<StudentResultController> {
  const StudentResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Hasil Ujian', style: TextStyle(color: AppColors.darkPurple, fontSize: 16, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(color: AppColors.grey200.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emoji_events, size: 48, color: AppColors.primaryPurple),
                  ),
                  const Gap(24),
                  Obx(() => Text(
                    controller.quizTitle.value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grey600),
                  )),
                  const Gap(8),
                  const Text('Nilai Akhir', style: TextStyle(fontSize: 14, color: AppColors.grey500)),
                  const Gap(4),
                  Obx(() {
                    final val = controller.score.value;
                    final displayVal = val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
                    return Text(
                      displayVal,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                    );
                  }),
                  const Gap(24),
                  const Divider(),
                  const Gap(24),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Benar', controller.correctAnswers.value.toString(), Colors.green),
                      _buildStatItem('Salah', controller.wrongAnswers.value.toString(), Colors.red),
                      _buildStatItem('Total', controller.totalQuestions.value.toString(), AppColors.darkPurple),
                    ],
                  )),
                ],
              ),
            ),
            const Gap(32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.backToDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kembali ke Dashboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const Gap(4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey600)),
      ],
    );
  }
}
