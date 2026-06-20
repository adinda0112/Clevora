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
        title: const Text('Hasil AI Generate',
            style: TextStyle(color: AppColors.darkPurple, fontSize: 16)),
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
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF085041)),
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
                  BoxShadow(
                      color: AppColors.grey200.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Obx(() => _buildMateriResult()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.grey200)),
        ),
        child: Obx(() {
          if (controller.hasSaved.value) {
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.finishProcess,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('SELESAI',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit toggle row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.toggleEdit,
                      icon: Icon(
                        controller.isEditing.value ? Icons.done : Icons.edit,
                        size: 18,
                      ),
                      label: Text(
                          controller.isEditing.value ? 'Selesai Edit' : 'EDIT'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: controller.isEditing.value
                            ? Colors.white
                            : AppColors.primaryPurple,
                        backgroundColor: controller.isEditing.value
                            ? AppColors.primaryPurple
                            : Colors.white,
                        side: const BorderSide(color: AppColors.primaryPurple),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              // SIMPAN + SIMPAN & SHARE
              Row(
                children: [
                  // SIMPAN
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => controller.saveOnly(),
                      icon: controller.isSaving.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save, size: 18, color: Colors.white),
                      label: const Text('SIMPAN',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const Gap(10),
                  // SIMPAN & SHARE
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.isSaving.value
                          ? null
                          : () => _showShareDialog(context),
                      icon: const Icon(Icons.share, size: 18, color: Colors.white),
                      label: const Text('SIMPAN & SHARE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.grey50,
              ),
              style: const TextStyle(
                  fontSize: 14, height: 1.6, color: AppColors.grey800),
            );
          }
          return SelectableRegion(
            focusNode: FocusNode(),
            selectionControls: materialTextSelectionControls,
            child: MarkdownBody(
              data: controller.resultText.value,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                    fontSize: 14, height: 1.6, color: AppColors.grey800),
                h1: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPurple),
                h2: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple),
                h3: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkPurple),
                listBullet: const TextStyle(
                    fontSize: 14, color: AppColors.grey800),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showShareDialog(BuildContext context) {
    String selectedClass = 'X IPA 1';
    final kelasOptions = [
      'X IPA 1', 'X IPA 2', 'X IPS 1', 'X IPS 2',
      'XI IPA 1', 'XI IPA 2', 'XI IPS 1', 'XI IPS 2',
      'XII IPA 1', 'XII IPA 2', 'XII IPS 1', 'XII IPS 2',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setLocalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const Text(
                  'Share ke Kelas',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple),
                ),
                const Gap(8),
                const Text(
                  'Pilih kelas tujuan untuk membagikan konten ini:',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.grey600),
                ),
                const Gap(16),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  items: kelasOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setLocalState(() => selectedClass = val);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grey50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      controller.saveAndShare(shareClass: selectedClass);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Simpan & Share Sekarang',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
