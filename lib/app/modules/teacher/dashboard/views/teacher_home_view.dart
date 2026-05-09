import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/widgets/menu_card.dart';
import 'package:clevora/app/widgets/stat_card.dart';
import 'package:clevora/app/modules/teacher/dashboard/controllers/teacher_home_controller.dart';

class TeacherHomeView extends GetView<TeacherHomeController> {
  const TeacherHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: Column(
        children: [
          // Header Purple
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.darkPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat pagi 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(2),
                Obx(
                  () => Text(
                    controller.userRole.value,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70, size: 18),
                      const Gap(8),
                      Text(
                        'Cari modul, materi, kuis...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  const Gap(10),
                  Obx(
                    () => Row(
                      children: controller.stats.map((stat) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: StatCard(
                              title: stat['title'],
                              value: stat['value'],
                              color: stat['color'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(24),
                  const Text(
                    'Menu utama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Gap(12),
                  Obx(
                    () => GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.menuItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.menuItems[index];
                        return MenuCard(
                          icon: item['icon'],
                          title: item['title'],
                          subtitle: item['subtitle'],
                          backgroundColor: item['bg'],
                          textColor: item['text'],
                          onTap: () {
                            Get.snackbar('Informasi', 'Menu ${item['title']} ditekan',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(10));
                          },
                        );
                      },
                    ),
                  ),

                  const Gap(24),
                  const Text(
                    'Aktivitas terbaru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Gap(12),
                  Obx(
                    () => Column(
                      children: controller.activities.map((activity) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.grey200, width: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: activity['bg'],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(activity['icon'], color: activity['color'], size: 20),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.grey900,
                                      ),
                                    ),
                                    const Gap(2),
                                    Text(
                                      activity['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: activity['statusBg'],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  activity['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: activity['statusColor'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
