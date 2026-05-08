import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../controllers/result_controller.dart';
import '../../home/controllers/home_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: Column(
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
            decoration: const BoxDecoration(
              color: AppColors.darkPurple,
            ),
            child: Column(
              children: [
                const Text(
                  'Hasil Ujian',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(24),
                Obx(
                  () => Text(
                    controller.percentage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                const Gap(4),
                const Text(
                  'Nilai Akhir',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => Text(
                      controller.grade.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
                  // Breakdown
                  Obx(
                    () => Column(
                      children: controller.stats.map((stat) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.grey200, width: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    stat['isCorrect'] == true
                                        ? Icons.check_circle_outline
                                        : stat['isCorrect'] == false
                                            ? Icons.highlight_off
                                            : Icons.analytics_outlined,
                                    size: 16,
                                    color: AppColors.grey400,
                                  ),
                                  const Gap(8),
                                  Text(
                                    stat['label'],
                                    style: const TextStyle(fontSize: 13, color: AppColors.grey600),
                                  ),
                                ],
                              ),
                              Text(
                                stat['isCorrect'] != null ? '${stat['value']} / ${stat['total']}' : '${stat['value']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: stat['isCorrect'] == true
                                      ? AppColors.teal
                                      : stat['isCorrect'] == false
                                          ? AppColors.red
                                          : AppColors.grey900,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(32),

                  // Chart section
                  const Text(
                    'Statistik Kemampuan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.grey900),
                  ),
                  const Gap(16),
                  Obx(
                    () => Column(
                      children: controller.chartData.map((data) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  data['label'],
                                  style: const TextStyle(fontSize: 11, color: AppColors.grey600),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: data['value'],
                                      child: Container(
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: data['color'],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.only(left: 8),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${(data['value'] * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Gap(40),

                  // Actions
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Lihat pembahasan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const Gap(12),
                  OutlinedButton(
                    onPressed: () => Get.find<HomeController>().changePage(0),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.grey200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(color: AppColors.grey900, fontWeight: FontWeight.w600),
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
