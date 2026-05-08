import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_bottom_nav.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../module/views/module_view.dart';
import '../../quiz/views/quiz_view.dart';
import '../../result/views/result_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardView(),
      const ModuleView(),
      const QuizView(),
      const ResultView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
            NavItem(icon: Icons.home_filled, label: 'Beranda'),
            NavItem(icon: Icons.menu_book_outlined, label: 'Modul'),
            NavItem(icon: Icons.assignment_turned_in_outlined, label: 'Kuis'),
            NavItem(icon: Icons.bar_chart_outlined, label: 'Laporan'),
            NavItem(icon: Icons.person_outline, label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
