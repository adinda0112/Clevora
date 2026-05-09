import 'package:flutter/material.dart';

import 'package:clevora/app/theme/app_theme.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan', style: TextStyle(color: AppColors.darkPurple))),
      body: const Center(child: Text('Laporan Nilai Siswa (Teacher)')),
    );
  }
}
