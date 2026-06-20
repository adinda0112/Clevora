import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/modules/teacher/history/controllers/teacher_history_controller.dart';

class TeacherHistoryView extends GetView<TeacherHistoryController> {
  const TeacherHistoryView({super.key});

  String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text('Riwayat ${controller.type}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.modules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[400]),
                const Gap(16),
                Text(
                  'Belum ada ${controller.type} yang dibuat.',
                  style: const TextStyle(color: AppColors.grey600, fontSize: 16),
                ),
                const Gap(16),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(Routes.GENERATE_FORM, arguments: {'type': controller.type}),
                  icon: const Icon(Icons.add),
                  label: Text('Buat ${controller.type} Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 52, 137),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchModules,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.modules.length,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final item = controller.modules[index];
              final dateStr = item.createdAt != null
                  ? '${item.createdAt!.day} ${_monthName(item.createdAt!.month)} ${item.createdAt!.year}'
                  : '';
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description, color: AppColors.primaryPurple),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.judul,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          if (dateStr.isNotEmpty)
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.grey600,
                              ),
                            ),
                          if (item.kelas != null || item.mapel != null) ...[
                            const Gap(4),
                            Text(
                              '${item.kelas ?? ''}${item.kelas != null && item.mapel != null ? ' · ' : ''}${item.mapel ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B6D11),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.GENERATE_FORM, arguments: {'type': controller.type});
        },
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('CREATE NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
