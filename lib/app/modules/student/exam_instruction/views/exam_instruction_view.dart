import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/student/exam_instruction/controllers/exam_instruction_controller.dart';

class ExamInstructionView extends GetView<ExamInstructionController> {
  const ExamInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Instruksi Ujian', style: TextStyle(color: AppColors.darkPurple, fontSize: 16, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPurple),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final q = controller.quiz.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q?.judul ?? 'Memuat Detail Ujian...',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 18, color: AppColors.grey600),
                            const Gap(8),
                            Text('Waktu: ${q?.durasi ?? 30} Menit', style: const TextStyle(color: AppColors.grey600)),
                            const Gap(20),
                            const Icon(Icons.assignment_outlined, size: 18, color: AppColors.grey600),
                            const Gap(8),
                            Text('Soal: ${q?.soal.length ?? 0} Pilihan Ganda', style: const TextStyle(color: AppColors.grey600)),
                          ],
                        ),
                      ],
                    );
                  }),
                  const Gap(20),
                  const Divider(),
                  const Gap(10),
                  const Text('Peraturan Ujian (Anti Cheating):', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Gap(10),
                  _buildRuleItem(Icons.camera_front, 'Kamera harus selalu aktif selama ujian berlangsung.'),
                  _buildRuleItem(Icons.mobile_screen_share, 'Sistem mendeteksi jika Anda keluar dari aplikasi.'),
                  _buildRuleItem(Icons.face, 'Wajah harus selalu terlihat di layar.'),
                  _buildRuleItem(Icons.warning_amber_rounded, 'Maksimal pelanggaran 3 kali. Lebih dari itu ujian otomatis diakhiri.'),
                ],
              ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.isChecked.value,
                  onChanged: controller.toggleCheck,
                  activeColor: AppColors.primaryPurple,
                )),
                const Expanded(
                  child: Text('Saya mengerti dan menyetujui peraturan ujian.', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const Gap(10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isChecked.value ? controller.startExam : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Mulai Ujian Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryPurple),
          const Gap(12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.grey800))),
        ],
      ),
    );
  }
}
