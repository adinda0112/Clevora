import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_chip.dart';
import '../controllers/module_controller.dart';

class ModuleView extends GetView<ModuleController> {
  const ModuleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Modul Ajar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
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

                  const Gap(20),

                  // AI Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
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
                              'Generate ATP otomatis',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkPurple,
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        const Text(
                          'Buat Alur Tujuan Pembelajaran dengan AI dalam hitungan detik',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        const Gap(12),
                        ElevatedButton(
                          onPressed: () => Get.toNamed(Routes.GENERATE),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'Generate sekarang ↗',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // Module List
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.modules.length,
                      itemBuilder: (context, index) {
                        final module = controller.modules[index];
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          module['title'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.grey900,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          module['subtitle'],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: module['statusBg'],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      module['status'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: module['statusColor'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: module['progress'],
                                  backgroundColor: AppColors.grey50,
                                  color: module['progressColor'],
                                  minHeight: 6,
                                ),
                              ),
                              const Gap(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    module['pertemuan'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  const Text(
                                    'Lihat detail →',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
