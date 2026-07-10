import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class TeacherBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TeacherBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomNav(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        NavItem(icon: Icons.home_filled, label: 'Beranda'),
        NavItem(icon: Icons.smart_toy_outlined, label: 'Modul AI'),
        NavItem(icon: Icons.quiz_outlined, label: 'Kuis'),
        NavItem(icon: Icons.bar_chart_outlined, label: 'Laporan'),
        NavItem(icon: Icons.person_outline, label: 'Profil'),
      ],
    );
  }
}
