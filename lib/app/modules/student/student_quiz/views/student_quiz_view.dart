import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/modules/student/student_quiz/controllers/student_quiz_controller.dart';
import 'package:clevora/app/routes/app_routes.dart';

class StudentQuizView extends GetView<StudentQuizController> {
  const StudentQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text(
          'Daftar Kuis & Ujian',
          style: TextStyle(color: AppColors.darkPurple, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final filters = ['Semua', 'Pretest', 'Posttest', 'Ujian'];

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryPurple),
          );
        }

        if (controller.filteredQuizzes.isEmpty && controller.activeFilter.value == 'Semua') {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in,
                      size: 64,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  const Gap(24),
                  const Text(
                    'Belum Ada Kuis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    'Saat ini belum ada kuis atau ujian yang aktif untuk kelas Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: filters.map((filter) {
                  final isActive = controller.activeFilter.value == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.grey700,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isActive,
                      selectedColor: AppColors.primaryPurple,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isActive ? AppColors.primaryPurple : AppColors.grey300,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          controller.activeFilter.value = filter;
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // List Kuis
            Expanded(
              child: controller.filteredQuizzes.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada kuis untuk filter ${controller.activeFilter.value}',
                      style: const TextStyle(color: AppColors.grey600),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: controller.fetchQuizzes,
                    color: AppColors.primaryPurple,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.filteredQuizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = controller.filteredQuizzes[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey200.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              quiz.mapel ?? 'Mata Pelajaran',
                              style: const TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Kelas ${quiz.kelas ?? 'Semua'}',
                            style: const TextStyle(
                              color: AppColors.grey600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: controller.isCompleted(quiz.id) ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          controller.isCompleted(quiz.id) ? 'SUDAH TERSELESAIKAN' : 'BELUM TERSELESAIKAN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: controller.isCompleted(quiz.id) ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Text(
                        quiz.judul,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPurple,
                        ),
                      ),
                      if (quiz.deskripsi != null && quiz.deskripsi!.isNotEmpty) ...[
                        const Gap(6),
                        Text(
                          quiz.deskripsi!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.grey600, fontSize: 13, height: 1.4),
                        ),
                      ],
                      const Gap(16),
                      const Divider(height: 1),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: AppColors.grey600, size: 16),
                              const Gap(6),
                              Text(
                                '${quiz.durasi} Menit',
                                style: const TextStyle(
                                  color: AppColors.grey700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(16),
                              const Icon(Icons.help_outline, color: AppColors.grey600, size: 16),
                              const Gap(6),
                              Text(
                                '${quiz.soal.length} Soal',
                                style: const TextStyle(
                                  color: AppColors.grey700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.isCompleted(quiz.id)) {
                                final data = controller.getResultData(quiz.id) ?? {
                                  'quizTitle': quiz.judul,
                                  'nilai': 0,
                                  'benar': 0,
                                  'salah': 0,
                                };
                                Get.toNamed(Routes.STUDENT_RESULT, arguments: data);
                              } else {
                                Get.toNamed(Routes.EXAM_INSTRUCTION, arguments: quiz);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isCompleted(quiz.id) ? Colors.red : Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  controller.isCompleted(quiz.id) ? 'Lihat Hasil' : 'Mulai',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(4),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  })
);
}
}
