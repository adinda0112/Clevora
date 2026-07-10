import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clevora/app/widgets/teacher_bottom_nav.dart';
import 'package:clevora/app/modules/teacher/teacher_main/controllers/teacher_main_controller.dart';
import 'package:clevora/app/modules/teacher/dashboard/views/teacher_home_view.dart';
import 'package:clevora/app/modules/teacher/ai_generate/views/module_ai_view.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/quiz_management_view.dart';
import 'package:clevora/app/modules/teacher/report/views/report_view.dart';
import 'package:clevora/app/modules/shared/profile/views/profile_view.dart';

class TeacherMainView extends GetView<TeacherMainController> {
  const TeacherMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const TeacherHomeView(),
      const ModuleAiView(),
      const QuizManagementView(),
      const ReportView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),

      bottomNavigationBar: Obx(
        () => TeacherBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
