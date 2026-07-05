import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/ai_generate/controllers/generate_form_controller.dart';


class GenerateFormView extends GetView<GenerateFormController> {
  const GenerateFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkPurple),
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(
          () => Text(
            'Generate ${controller.generateType.value}',
            style: const TextStyle(color: AppColors.darkPurple, fontSize: 16),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPurple),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Mata Pelajaran'),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.mataPelajaran.value.isEmpty ? null : controller.mataPelajaran.value,
                decoration: _inputDecoration().copyWith(hintText: 'Pilih Mata Pelajaran'),
                items: controller.mapelOptions.map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) {
                  if (val != null) controller.mataPelajaran.value = val;
                },
              ),
            ),
            const Gap(16),

            _buildLabel('Kelas'),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.kelas.value,
                decoration: _inputDecoration(),
                items: ['X', 'XI', 'XII'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) {
                  if (val != null) controller.kelas.value = val;
                },
              ),
            ),
            const Gap(16),

            _buildLabel('Topik / Materi Pokok'),
            _buildTextField(
              hint: 'Contoh: Algoritma Pemrograman',
              maxLines: 3,
              onChanged: (v) => controller.topik.value = v,
            ),
            const Gap(16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Upload Template (Opsional)'),
                Obx(() {
                  if (controller.selectedFileName.value.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.lightTeal,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.teal),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: AppColors.teal),
                          const Gap(12),
                          Expanded(
                            child: Text(
                              controller.selectedFileName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: controller.removeFile,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: TextButton.icon(
                      onPressed: controller.pickFile,
                      icon: const Icon(Icons.upload_file, color: AppColors.primaryPurple),
                      label: const Text(
                        'Pilih File PDF Referensi',
                        style: TextStyle(color: AppColors.grey600),
                      ),
                    ),
                  );
                }),
                const Gap(16),
              ],
            ),

            Obx(() {
              if (controller.generateType.value == 'Quiz') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Tipe Kuis'),
                    DropdownButtonFormField<String>(
                      value: controller.quizType.value,
                      decoration: _inputDecoration(),
                      items: ['Pretest', 'Posttest', 'Ujian'].map((String val) {
                        return DropdownMenuItem(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) controller.quizType.value = val;
                      },
                    ),
                    const Gap(16),

                    _buildLabel('Jumlah Soal'),
                    DropdownButtonFormField<String>(
                      value: controller.jumlahSoal.value,
                      decoration: _inputDecoration(),
                      items: ['5', '10', '20', '25'].map((String val) {
                        return DropdownMenuItem(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) controller.jumlahSoal.value = val;
                      },
                    ),
                    const Gap(16),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.grey200)),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: controller.startGenerate,
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: const Text(
              'Generate dengan AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.darkPurple,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: _inputDecoration().copyWith(hintText: hint),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryPurple),
      ),
    );
  }
}
