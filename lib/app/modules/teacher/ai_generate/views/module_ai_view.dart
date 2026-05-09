import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';

class ModuleAiView extends StatelessWidget {
  const ModuleAiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Clevora AI', style: TextStyle(color: AppColors.darkPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.darkPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Asisten AI Guru', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Buat perangkat ajar dan soal dalam hitungan detik.', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Tipe Generate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkPurple)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildAiCard('Generate ATP', Icons.account_tree_outlined, AppColors.lightPurple, AppColors.primaryPurple, 'ATP'),
                _buildAiCard('Generate Modul', Icons.menu_book_outlined, AppColors.lightTeal, AppColors.teal, 'Modul'),
                _buildAiCard('Generate Materi', Icons.article_outlined, AppColors.lightAmber, AppColors.amber, 'Materi'),
                _buildAiCard('Generate Quiz', Icons.quiz_outlined, AppColors.lightCoral, Colors.redAccent, 'Quiz'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiCard(String title, IconData icon, Color bg, Color iconColor, String type) {
    return GestureDetector(
      onTap: () => Get.toNamed('/generate-form', arguments: {'type': type}),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(color: AppColors.grey200.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkPurple)),
          ],
        ),
      ),
    );
  }
}
