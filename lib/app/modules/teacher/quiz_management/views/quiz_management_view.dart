import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/modules/teacher/quiz_management/controllers/quiz_management_controller.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/create_quiz_view.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/quiz_detail_view.dart';
import 'package:clevora/app/routes/app_routes.dart';

class QuizManagementView extends GetView<QuizManagementController> {
  const QuizManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller manually if not bound
    if (!Get.isRegistered<QuizManagementController>()) {
      Get.put(QuizManagementController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Management',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchQuizzes(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (controller.quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada kuis yang dibuat',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchQuizzes,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = controller.quizzes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    quiz.judul ?? 'Kuis Tanpa Judul',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kelas: ${quiz.kelas ?? '-'} | Mapel: ${quiz.mapel ?? '-'}'),
                        const SizedBox(height: 4),
                        Text('Durasi: ${quiz.durasi ?? 0} menit'),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Color.fromARGB(255, 60, 52, 137)),
                  onTap: () {
                    Get.to(() => const QuizDetailView(), arguments: quiz.id);
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pilih Metode Pembuatan Kuis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 60, 52, 137),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.auto_awesome, color: Color.fromARGB(255, 60, 52, 137)),
                    title: const Text('Generate dengan AI'),
                    subtitle: const Text('Buat kuis otomatis dari topik atau file PDF'),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.GENERATE_FORM, arguments: {'type': 'Quiz'});
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit_note, color: Color.fromARGB(255, 60, 52, 137)),
                    title: const Text('Buat Manual'),
                    subtitle: const Text('Susun pertanyaan dan jawaban sendiri'),
                    onTap: () async {
                      Get.back();
                      await Get.to(() => const CreateQuizView());
                      controller.fetchQuizzes();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('CREATE NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
