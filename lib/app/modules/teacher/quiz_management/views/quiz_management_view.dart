import 'package:flutter/material.dart';

import 'package:clevora/app/theme/app_theme.dart';

class QuizManagementView extends StatelessWidget {
  const QuizManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Management', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
      ),
      body: const Center(child: Text('Kelola Pretest, Posttest, Ujian (Teacher)')),
    );
  }
}
