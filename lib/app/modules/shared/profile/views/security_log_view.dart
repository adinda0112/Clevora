import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/modules/shared/profile/controllers/security_log_controller.dart';
import 'package:intl/intl.dart';

class SecurityLogView extends GetView<SecurityLogController> {
  const SecurityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Keamanan & Audit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchLogs(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (controller.logs.isEmpty) {
          return const Center(
            child: Text('Belum ada log keamanan yang tercatat.', style: TextStyle(color: Colors.grey, fontSize: 16)),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchLogs(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.logs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = controller.logs[index];
              return _buildLogCard(log);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLogCard(dynamic log) {
    final status = log['status'] ?? 'UNKNOWN';
    final action = log['action'] ?? 'Unknown Action';
    final ipAddress = log['ipAddress'] ?? 'Unknown IP';
    final userAgent = log['userAgent'] ?? '-';
    
    // Format timestamp
    String formattedTime = '-';
    if (log['createdAt'] != null) {
      try {
        final date = DateTime.parse(log['createdAt']).toLocal();
        formattedTime = DateFormat('dd MMM yyyy, HH:mm').format(date);
      } catch (e) {
        // ignore
      }
    }

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info_outline;
    
    if (status == 'SUCCESS') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'FAILED') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (status == 'WARNING') {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  action,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, formattedTime),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.router, 'IP: $ipAddress'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.devices, userAgent),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ),
      ],
    );
  }
}
