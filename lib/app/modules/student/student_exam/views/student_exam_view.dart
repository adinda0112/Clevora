import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/student/student_exam/controllers/student_exam_controller.dart';

class StudentExamView extends GetView<StudentExamController> {
  const StudentExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: AppColors.darkPurple),
                  const Gap(8),
                  Expanded(
                    child: Obx(() => Text(
                      controller.quiz.value?.judul ?? 'Ujian',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16, color: AppColors.primaryPurple),
                        const Gap(6),
                        Obx(() => Text(
                          controller.formattedTime,
                          style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Sub Header: Camera Placeholder & Progress
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Camera Placeholder
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.face, size: 40, color: AppColors.grey400),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  // Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          final total = controller.quiz.value?.soal.length ?? 0;
                          return Text(
                            'Soal ${controller.currentQuestionIndex.value + 1} dari $total',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          );
                        }),
                        const Gap(8),
                        Obx(() {
                          final total = controller.quiz.value?.soal.length ?? 1;
                          return LinearProgressIndicator(
                            value: (controller.currentQuestionIndex.value + 1) / total,
                            backgroundColor: AppColors.grey200,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          );
                        }),
                        const Gap(12),
                        Obx(() {
                          if (controller.warningCount.value > 0) {
                            return Text(
                              'Peringatan: ${controller.warningCount.value}/3',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        const Gap(4),
                        TextButton.icon(
                          onPressed: controller.simulateWarning,
                          icon: const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                          label: const Text('Simulate Warning', style: TextStyle(color: Colors.orange, fontSize: 12)),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Question Area
            Expanded(
              child: Obx(() {
                final quizObj = controller.quiz.value;
                if (quizObj == null || quizObj.soal.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada soal untuk ditampilkan.'),
                  );
                }
                final currentQ = quizObj.soal[controller.currentQuestionIndex.value];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQ.pertanyaan,
                        style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.darkPurple),
                      ),
                      const Gap(24),
                      ...List.generate(currentQ.pilihan.length, (index) {
                        return Obx(() {
                          final isSelected = controller.selectedAnswers[controller.currentQuestionIndex.value] == index;
                          return GestureDetector(
                            onTap: () => controller.selectOption(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.lightPurple : Colors.white,
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryPurple : AppColors.grey300,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryPurple : AppColors.grey400,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primaryPurple,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Text(
                                      currentQ.pilihan[index],
                                      style: TextStyle(
                                        color: isSelected ? AppColors.darkPurple : AppColors.grey800,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }),
                    ],
                  ),
                );
              }),
            ),

            // Bottom Navigation (Prev/Next/Submit)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => OutlinedButton(
                    onPressed: controller.currentQuestionIndex.value > 0 ? controller.previousQuestion : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPurple,
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Sebelumnya'),
                  )),
                  Obx(() {
                    final total = controller.quiz.value?.soal.length ?? 0;
                    if (controller.currentQuestionIndex.value < total - 1) {
                      return ElevatedButton(
                        onPressed: controller.nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Selanjutnya', style: TextStyle(color: Colors.white)),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: controller.confirmSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Submit Ujian', style: TextStyle(color: Colors.white)),
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
