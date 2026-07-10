import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/modules/teacher/attendance/controllers/attendance_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

part '../widgets/attendance_widgets.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Absen Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (controller.showStudentList.value) {
              controller.showStudentList.value = false;
            } else {
              Get.back();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed('/attendance-history'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.showStudentList.value) {
          return AttendanceStudentList(controller: controller);
        }
        return AttendanceSelectionForm(controller: controller);
      }),
    );
  }
}
