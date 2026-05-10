import 'package:flutter/material.dart';

import 'package:clevora/app/theme/app_theme.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
      ),
      body: const Center(child: Text('Laporan Nilai Siswa (Teacher)')),
    );
  }
}
