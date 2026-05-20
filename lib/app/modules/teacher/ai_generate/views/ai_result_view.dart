import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/ai_result_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
              child: Obx(() => _buildMateriResult()),
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
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPurple,
                  side: const BorderSide(color: AppColors.primaryPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Batal'),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSaving.value ? null : controller.saveAndPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Simpan & Publish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description, color: AppColors.primaryPurple, size: 20),
            const Gap(8),
            Expanded(
              child: Text(
                '${controller.generateType.value}: ${controller.topik.value}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPurple,
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        const Divider(),
        const Gap(16),
        SelectableRegion(
          focusNode: FocusNode(),
          selectionControls: materialTextSelectionControls,
          child: MarkdownBody(
            data: controller.resultText.value,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.grey800),
              h1: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
              h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkPurple),
              listBullet: const TextStyle(fontSize: 14, color: AppColors.grey800),
            ),
          ),
        ),
      ],
    );
  }
}
