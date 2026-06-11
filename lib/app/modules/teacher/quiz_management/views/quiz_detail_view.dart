import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/quiz_management/controllers/quiz_detail_controller.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/add_question_view.dart';

class QuizDetailView extends GetView<QuizDetailController> {
  const QuizDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<QuizDetailController>()) {
      Get.put(QuizDetailController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Detail Kuis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
          );
        }

        final quiz = controller.quiz.value;
        if (quiz == null) {
          return const Center(child: Text('Data kuis tidak ditemukan'));
        }

        return Column(
          children: [
            // Quiz Info Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quiz.judul ?? 'Tanpa Judul', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(quiz.deskripsi ?? '-', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(Icons.class_, 'Kelas ${quiz.kelas}'),
                      _buildInfoChip(Icons.book, quiz.mapel ?? '-'),
                      _buildInfoChip(Icons.timer, '${quiz.durasi} Min'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Questions List
            Expanded(
              child: quiz.soal == null || quiz.soal!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.question_answer_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('Belum ada soal untuk kuis ini', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: quiz.soal!.length,
                      itemBuilder: (context, index) {
                        final q = quiz.soal![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            title: Text('Soal ${index + 1}: ${q.pertanyaan}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(q.pilihan.length, (i) {
                                      final isCorrect = i == q.kunciJawaban;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                                              color: isCorrect ? Colors.green : Colors.grey,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(q.pilihan[i], style: TextStyle(fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal))),
                                          ],
                                        ),
                                      );
                                    }),
                                    if (q.penjelasan != null && q.penjelasan!.isNotEmpty) ...[
                                      const Divider(),
                                      const Text('Penjelasan:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(q.penjelasan!),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (controller.quizId.value.isNotEmpty) {
            await Get.to(() => const AddQuestionView(), arguments: controller.quizId.value);
            controller.fetchQuizDetail(); // Refresh after adding
          }
        },
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Soal', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7F77DD)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7F77DD), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
