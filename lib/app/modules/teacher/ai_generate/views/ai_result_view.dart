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
        child: Obx(() {
          if (controller.hasSaved.value && controller.hasDownloaded.value) {
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.finishProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('SELESAI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            );
          }

          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.toggleEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: controller.isEditing.value ? Colors.white : AppColors.primaryPurple,
                    backgroundColor: controller.isEditing.value ? AppColors.primaryPurple : Colors.white,
                    side: const BorderSide(color: AppColors.primaryPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(controller.isEditing.value ? 'Selesai Edit' : 'EDIT'),
                ),
              ),
              const Gap(8),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isSaving.value || controller.hasSaved.value 
                      ? null 
                      : () {
                          if (controller.generateType.value == 'Materi') {
                            _showShareDialog(context);
                          } else {
                            controller.saveAndPublish();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(controller.hasSaved.value ? 'Tersimpan' : 'SIMPAN', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const Gap(8),
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.hasDownloaded.value ? null : controller.downloadPdf,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    side: const BorderSide(color: AppColors.teal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(controller.hasDownloaded.value ? 'Diunduh' : 'UNDUH'),
                ),
              ),
            ],
          );
        }),
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
        Obx(() {
          if (controller.isEditing.value) {
            return TextField(
              controller: controller.textEditController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.grey50,
              ),
              style: const TextStyle(fontSize: 14, height: 1.6, color: AppColors.grey800),
            );
          }
          return SelectableRegion(
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
          );
        }),
      ],
    );
  }

  void _showShareDialog(BuildContext context) {
    String selectedClass = 'XII IPA 2';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share Materi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih kelas untuk membagikan materi ini:'),
              const Gap(16),
              DropdownButtonFormField<String>(
                value: selectedClass,
                items: ['X IPA 1', 'XI IPS 2', 'XII IPA 2', 'XII IPS 1']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedClass = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.saveAndPublish(shareClass: selectedClass);
              },
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }
}
