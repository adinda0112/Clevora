import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_theme.dart';
import '../controllers/generate_controller.dart';

class GenerateView extends GetView<GenerateController> {
  const GenerateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Generate Soal AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: AppColors.grey200),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.lightPurple, AppColors.lightTeal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.auto_awesome, color: AppColors.primaryPurple, size: 18),
                            Gap(8),
                            Text(
                              'Buat soal otomatis dengan AI',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkPurple,
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        const Text(
                          'Topik / materi',
                          style: TextStyle(fontSize: 11, color: AppColors.grey600),
                        ),
                        const Gap(4),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'cth: HTML dasar, CSS styling...',
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Gap(12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tipe soal',
                                    style: TextStyle(fontSize: 11, color: AppColors.grey600),
                                  ),
                                  const Gap(4),
                                  Obx(
                                    () => DropdownButtonFormField<String>(
                                      value: controller.selectedQuestionType.value,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      style: const TextStyle(fontSize: 12, color: AppColors.grey900),
                                      items: controller.questionType.map((type) {
                                        return DropdownMenuItem(value: type, child: Text(type));
                                      }).toList(),
                                      onChanged: controller.chooseQuestionType,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jumlah soal',
                                    style: TextStyle(fontSize: 11, color: AppColors.grey600),
                                  ),
                                  const Gap(4),
                                  Obx(
                                    () => DropdownButtonFormField<String>(
                                      value: controller.selectedCount.value,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      style: const TextStyle(fontSize: 12, color: AppColors.grey900),
                                      items: controller.questionCounts.map((count) {
                                        return DropdownMenuItem(value: count, child: Text(count));
                                      }).toList(),
                                      onChanged: controller.chooseCount,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: controller.generateQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.auto_awesome, size: 16),
                              Gap(8),
                              Text('Generate soal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Generated List
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.generatedQuestions.length,
                      itemBuilder: (context, index) {
                        final soal = controller.generatedQuestions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Soal ${soal['num']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                soal['question'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey900,
                                ),
                              ),
                              const Gap(12),
                              ...List.generate(soal['options'].length, (idx) {
                                final opt = soal['options'][idx];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: opt['correct'] ? AppColors.lightTeal : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: opt['correct'] ? AppColors.teal : AppColors.grey200,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${opt['letter']}.',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.grey900,
                                        ),
                                      ),
                                      const Gap(8),
                                      Expanded(
                                        child: Text(
                                          opt['text'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: opt['correct'] ? const Color(0xFF085041) : AppColors.grey900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
