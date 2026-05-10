import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color headerColor;
  final Color iconColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final String time;
  final String students;
  final String completed;
  final String actionLabel;
  final VoidCallback? onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.headerColor,
    required this.iconColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.time,
    required this.students,
    required this.completed,
    required this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200, width: 0.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            color: headerColor,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    _infoItem(Icons.access_time, time),
                    const Gap(12),
                    _infoItem(Icons.people_outline, students),
                    const Gap(12),
                    _infoItem(Icons.check_circle_outline, completed),
                  ],
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(color: AppColors.grey200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Edit soal',
                          style: TextStyle(fontSize: 11, color: AppColors.grey900),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          actionLabel,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey400),
        const Gap(4),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.grey600),
        ),
      ],
    );
  }
}
