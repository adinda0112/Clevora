import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/shared/profile/controllers/security_log_controller.dart';
import 'package:intl/intl.dart';

class SecurityLogView extends GetView<SecurityLogController> {
  const SecurityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Log Keamanan & Audit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.logs.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada log keamanan tercatat.',
              style: TextStyle(color: AppColors.grey600, fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchLogs,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.logs.length,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final log = controller.logs[index];
              final isSuccess = log.status == 'SUCCESS';
              
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
                  border: Border.all(
                    color: isSuccess ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSuccess ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            log.action,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSuccess ? Colors.green[800] : Colors.red[800],
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm:ss').format(log.createdAt),
                          style: const TextStyle(fontSize: 12, color: AppColors.grey500),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.grey600),
                        const Gap(6),
                        Text(
                          'IP: ${log.ipAddress}',
                          style: const TextStyle(fontSize: 14, color: AppColors.grey800, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const Gap(6),
                    Row(
                      children: [
                        const Icon(Icons.http, size: 16, color: AppColors.grey600),
                        const Gap(6),
                        Expanded(
                          child: Text(
                            log.endpoint,
                            style: const TextStyle(fontSize: 13, color: AppColors.grey700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (log.userAgent != null) ...[
                      const Gap(6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.devices, size: 16, color: AppColors.grey600),
                          const Gap(6),
                          Expanded(
                            child: Text(
                              log.userAgent!,
                              style: const TextStyle(fontSize: 12, color: AppColors.grey500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
