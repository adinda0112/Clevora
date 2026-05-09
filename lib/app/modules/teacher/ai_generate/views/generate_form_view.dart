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
        title: Obx(() => Text('Generate ${controller.generateType.value}', style: const TextStyle(color: AppColors.darkPurple, fontSize: 16))),
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
            _buildTextField(hint: 'Contoh: Informatika', onChanged: (v) => controller.mataPelajaran.value = v),
            const Gap(16),
            
            _buildLabel('Kelas'),
            _buildTextField(hint: 'Contoh: X RPL', onChanged: (v) => controller.kelas.value = v),
            const Gap(16),
            
            _buildLabel('Topik / Materi Pokok'),
            _buildTextField(hint: 'Contoh: Algoritma Pemrograman', maxLines: 3, onChanged: (v) => controller.topik.value = v),
            const Gap(16),
            
            _buildLabel('Tingkat Kesulitan'),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.tingkatKesulitan.value,
              decoration: _inputDecoration(),
              items: ['Mudah', 'Sedang', 'Sulit', 'HOTS'].map((String val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                if (val != null) controller.tingkatKesulitan.value = val;
              },
            )),
            const Gap(16),

            Obx(() {
              if (controller.generateType.value == 'Quiz') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            label: const Text('Generate dengan AI', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkPurple)),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1, required Function(String) onChanged}) {
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
