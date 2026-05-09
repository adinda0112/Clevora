import 'package:flutter/material.dart';

import 'package:clevora/app/theme/app_theme.dart';

class QuizManagementView extends StatelessWidget {
  const QuizManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Management', style: TextStyle(color: AppColors.darkPurple))),
      body: const Center(child: Text('Kelola Pretest, Posttest, Ujian (Teacher)')),
    );
  }
}
