import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/ai_result_controller.dart';

class AiResultView extends GetView<AiResultController> {
  const AiResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Hasil AI Generate', style: TextStyle(color: AppColors.darkPurple, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPurple),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightTeal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.teal),
                  const Gap(12),
                  Expanded(
                    child: Obx(() => Text(
                      '${controller.generateType.value} berhasil dibuat!',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF085041)),
                    )),
                  ),
                ],
              ),
            ),
            const Gap(24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(color: AppColors.grey200.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Obx(() {
                if (controller.generateType.value == 'Quiz') {
                  return _buildQuizResult();
                } else {
                  return _buildMateriResult();
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.grey200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPurple,
                  side: const BorderSide(color: AppColors.primaryPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Edit / Export'),
              ),
            ),
            const Gap(16),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.saveAndPublish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Simpan & Publish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quiz: ${controller.topik.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
        const Gap(16),
        _buildQuizItem(1, 'Apa definisi paling tepat untuk topik ini?', ['Pilihan A (Benar)', 'Pilihan B', 'Pilihan C', 'Pilihan D'], 0),
        const Divider(height: 30),
        _buildQuizItem(2, 'Manakah yang bukan termasuk karakteristik utama?', ['Karakteristik 1', 'Karakteristik 2', 'Karakteristik 3 (Benar)', 'Karakteristik 4'], 2),
      ],
    );
  }

  Widget _buildQuizItem(int number, String question, List<String> options, int correctAnswerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$number. $question', style: const TextStyle(fontWeight: FontWeight.w600)),
        const Gap(8),
        ...List.generate(options.length, (index) {
          final isCorrect = index == correctAnswerIndex;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(isCorrect ? Icons.check_circle : Icons.radio_button_unchecked, 
                     color: isCorrect ? Colors.green : AppColors.grey400, size: 18),
                const Gap(8),
                Text(options[index], style: TextStyle(color: isCorrect ? Colors.green[800] : AppColors.grey700)),
              ],
            ),
          );
        }),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(4)),
          child: const Text('Difficulty: Sedang', style: TextStyle(fontSize: 11, color: AppColors.grey600)),
        ),
      ],
    );
  }

  Widget _buildMateriResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(controller.topik.value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
        const Gap(8),
        const Text('Tujuan Pembelajaran:', style: TextStyle(fontWeight: FontWeight.w600)),
        const Gap(4),
        const Text('1. Siswa mampu memahami konsep dasar.\n2. Siswa mampu menerapkan prinsip dalam studi kasus.\n3. Siswa dapat menganalisis masalah terkait.', style: TextStyle(color: AppColors.grey800, height: 1.5)),
        const Gap(16),
        const Text('Ringkasan Materi:', style: TextStyle(fontWeight: FontWeight.w600)),
        const Gap(4),
        const Text('Topik ini mencakup penjelasan mendalam mengenai prinsip kerja, kelebihan, dan implementasi nyata di lapangan. Modul ini disusun berdasarkan kurikulum terbaru dengan pendekatan student-centered learning yang interaktif.', style: TextStyle(color: AppColors.grey800, height: 1.5)),
      ],
    );
  }
}
