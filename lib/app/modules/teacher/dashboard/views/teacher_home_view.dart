import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'dart:convert';

import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/widgets/menu_card.dart';
import 'package:clevora/app/widgets/stat_card.dart';
import 'package:clevora/app/modules/teacher/dashboard/controllers/teacher_home_controller.dart';
import 'package:clevora/app/routes/app_routes.dart';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
                const Gap(16),
                Obx(() {
                  final base64String = controller.fotoProfilBase64.value;
                  if (base64String.isNotEmpty) {
                    return CircleAvatar(
                      radius: 28,
                      backgroundImage: MemoryImage(base64Decode(base64String)),
                    );
                  }
                  return CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      controller.initials,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 20
                      ),
                    ),
                  );
                }),
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
                            child: GestureDetector(
                              onTap: () {
                                if (stat['route'] != null) {
                                  Get.toNamed(stat['route'], arguments: stat['args']);
                                }
                              },
                              child: StatCard(
                                title: stat['title'],
                                value: stat['value'],
                                color: stat['color'],
                              ),
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
                            if (item['route'] != null) {
                              Get.toNamed(item['route']);
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
                    () => controller.activities.isEmpty 
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.history, size: 48, color: AppColors.grey300),
                            const Gap(12),
                            const Text(
                              'Belum ada aktivitas terbaru',
                              style: TextStyle(color: AppColors.grey500, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : Column(
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
                    'Jelajah Video',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Gap(12),
                  Obx(() {
                    if (controller.isVideosLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.videos.isEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/600x400/000000/FFFFFF/?text=Belum+ada+video'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.video_library, color: Colors.white, size: 60),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.videos.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          final video = controller.videos[index];
                          final videoId = video['Video ID'];
                          final title = video['Judul'] ?? 'Video';
                          final channel = video['Channel'] ?? '';
                          final desc = video['Deskripsi'] ?? '';
                          final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.VIDEO_PLAYER, arguments: {
                                'videoId': videoId,
                                'title': title,
                                'desc': desc,
                              });
                            },
                            child: Container(
                              width: 240,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      thumbnailUrl,
                                      height: 120,
                                      width: 240,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 120,
                                        width: 240,
                                        color: Colors.black87,
                                        child: const Icon(Icons.error, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.grey900,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          channel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
