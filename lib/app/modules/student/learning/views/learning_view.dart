import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';

class LearningView extends StatelessWidget {
  const LearningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Belajar', style: TextStyle(color: AppColors.darkPurple))),
      body: const Center(child: Text('Belajar Materi & Modul (Student)')),
    );
  }
}
