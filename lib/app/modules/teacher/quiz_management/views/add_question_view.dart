import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/quiz_management/controllers/add_question_controller.dart';

class AddQuestionView extends GetView<AddQuestionController> {
  const AddQuestionView({super.key});

  static const _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AddQuestionController>()) {
      Get.put(AddQuestionController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tambah Soal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Question
              _sectionLabel('Pertanyaan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.pertanyaanController,
                maxLines: 4,
                decoration: _inputDecor(hintText: 'Tulis pertanyaan di sini...'),
                validator: (v) => v == null || v.isEmpty ? 'Pertanyaan wajib diisi' : null,
              ),

              const SizedBox(height: 24),

              // Section: Options
              _sectionLabel('Pilihan Jawaban'),
              const SizedBox(height: 12),

              // Generate 4 option fields
              ...List.generate(4, (i) => _buildOptionField(i)),

              const SizedBox(height: 24),

              // Section: Correct Answer Picker
              _sectionLabel('Kunci Jawaban (Jawaban yang Benar)'),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: List.generate(4, (i) {
                      final isSelected = controller.kunciJawaban.value == i;
                      return GestureDetector(
                        onTap: () => controller.kunciJawaban.value = i,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF7F77DD) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF7F77DD) : Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: const Color(0xFF7F77DD).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              _optionLabels[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isSelected ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  )),

              const SizedBox(height: 24),

              // Section: Explanation (optional)
              _sectionLabel('Penjelasan (Opsional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.penjelasanController,
                maxLines: 3,
                decoration: _inputDecor(hintText: 'Tambahkan pembahasan untuk soal ini...'),
              ),

              const SizedBox(height: 36),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F77DD),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: controller.isLoading.value ? null : controller.submitQuestion,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              'Simpan Soal',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    )),
              ),

              const SizedBox(height: 16),

              // Back button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7F77DD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Kembali ke Detail Kuis',
                    style: TextStyle(color: Color(0xFF7F77DD), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _optionLabels[index],
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7F77DD)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller.pilihanControllers[index],
              decoration: _inputDecor(hintText: 'Opsi ${_optionLabels[index]}'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15));
  }

  InputDecoration _inputDecor({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7F77DD), width: 1.5),
      ),
    );
  }
}
