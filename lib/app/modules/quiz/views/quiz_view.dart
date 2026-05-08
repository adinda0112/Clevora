import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/quiz_card.dart';
import '../../../widgets/custom_chip.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kelola Kuis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          const Gap(8),
        ],
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
                  // Tabs
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.filters.map((filter) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CustomChip(
                              label: filter,
                              selected: controller.selectedFilter.value == filter,
                              onTap: () => controller.chooseFilter(filter),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const Gap(24),

                  // Quiz List
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = controller.quizzes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: QuizCard(
                            title: quiz['title'],
                            subtitle: quiz['subtitle'],
                            category: quiz['category'],
                            icon: quiz['icon'],
                            headerColor: quiz['headerColor'],
                            iconColor: quiz['iconColor'],
                            badgeColor: quiz['badgeColor'],
                            badgeTextColor: quiz['badgeTextColor'],
                            time: quiz['time'],
                            students: quiz['students'],
                            completed: quiz['completed'],
                            actionLabel: quiz['action'],
                            onTap: () => Get.toNamed(Routes.EXAM),
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
