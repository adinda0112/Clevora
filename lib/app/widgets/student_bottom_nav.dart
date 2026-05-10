import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';

class StudentBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const StudentBottomNav({
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
        NavItem(icon: Icons.home_filled, label: 'Dashboard'),
        NavItem(icon: Icons.menu_book_outlined, label: 'Belajar'),
        NavItem(icon: Icons.assignment_turned_in_outlined, label: 'Quiz'),
        NavItem(icon: Icons.emoji_events_outlined, label: 'Hasil'),
        NavItem(icon: Icons.person_outline, label: 'Profile'),
      ],
    );
  }
}
