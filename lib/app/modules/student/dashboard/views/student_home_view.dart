import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/widgets/menu_card.dart';

import 'package:clevora/app/modules/student/dashboard/controllers/student_home_controller.dart';

import 'package:clevora/app/modules/student/student_main/controllers/student_main_controller.dart';

class StudentHomeView extends GetView<StudentHomeController> {
  const StudentHomeView({super.key});

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
                  'Halo 👋',
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
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                  const Gap(16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar('QR Absen', 'Fitur scan QR absen sedang dalam pengembangan');
                      },
                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryPurple),
                      label: const Text(
                        'Absen dengan QR',
                        style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
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
                  const Gap(10),
                  const Text(
                    'Menu siswa',
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
                            if (index == 0) {
                              Get.find<StudentMainController>().changePage(1); // Ke tab Learning
                            } else if (index == 1 || index == 2 || index == 3) {
                              Get.find<StudentMainController>().changePage(2); // Ke tab Kuis
                            } else {
                              Get.snackbar(
                                'Informasi',
                                'Menu ${item['title']} akan segera hadir!',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(10),
                              );
                            }
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
                  const Gap(24),
                  const Text(
                    'Jelajah',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Gap(12),
                  // Video Placeholder
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/600x400/000000/FFFFFF/?text=Video+Hasil+Bigdata'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
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
