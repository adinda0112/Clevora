import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clevora/app/widgets/student_bottom_nav.dart';
import 'package:clevora/app/modules/student/student_main/controllers/student_main_controller.dart';
import 'package:clevora/app/modules/student/dashboard/views/student_home_view.dart';
import 'package:clevora/app/modules/student/learning/views/learning_view.dart';
import 'package:clevora/app/modules/student/student_quiz/views/student_quiz_view.dart';
import 'package:clevora/app/modules/shared/profile/views/profile_view.dart';

class StudentMainView extends GetView<StudentMainController> {
  const StudentMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const StudentHomeView(),
      const LearningView(),
      const StudentQuizView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => StudentBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
