import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/modules/teacher/quiz_management/controllers/quiz_management_controller.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/create_quiz_view.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/quiz_detail_view.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/theme/app_theme.dart';

class QuizManagementView extends GetView<QuizManagementController> {
  const QuizManagementView({super.key});

  static const List<String> _kelasOptions = [
    'X IPA 1', 'X IPA 2', 'X IPS 1', 'X IPS 2',
    'XI IPA 1', 'XI IPA 2', 'XI IPS 1', 'XI IPS 2',
    'XII IPA 1', 'XII IPA 2', 'XII IPS 1', 'XII IPS 2',
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize controller manually if not bound
    if (!Get.isRegistered<QuizManagementController>()) {
      Get.put(QuizManagementController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kuis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final filters = ['Semua', 'Pretest', 'Posttest', 'Ujian'];

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchQuizzes(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (controller.filteredQuizzes.isEmpty && controller.activeFilter.value == 'Semua') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Belum ada kuis yang dibuat',
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 16)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showCreateOptions(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Buat Kuis Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 52, 137),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: filters.map((filter) {
                  final isActive = controller.activeFilter.value == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey[700],
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isActive,
                      selectedColor: const Color.fromARGB(255, 60, 52, 137),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isActive ? const Color.fromARGB(255, 60, 52, 137) : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          controller.activeFilter.value = filter;
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // List Kuis
            Expanded(
              child: controller.filteredQuizzes.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada kuis untuk filter ${controller.activeFilter.value}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: controller.fetchQuizzes,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredQuizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = controller.filteredQuizzes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Get.to(() => const QuizDetailView(),
                        arguments: quiz.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.judul,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            _infoChip(
                                Icons.class_outlined,
                                quiz.kelas ?? '-',
                                AppColors.lightPurple,
                                AppColors.primaryPurple),
                            const Gap(8),
                            _infoChip(
                                Icons.book_outlined,
                                quiz.mapel ?? '-',
                                AppColors.lightTeal,
                                AppColors.teal),
                            const Gap(8),
                            _infoChip(
                                Icons.timer_outlined,
                                '${quiz.durasi} menit',
                                AppColors.lightAmber,
                                const Color(0xFF633806)),
                          ],
                        ),
                        const Gap(12),
                        const Divider(height: 1),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildShareButton(context, quiz.id, quiz.judul),
                            const Gap(16),
                            TextButton.icon(
                              onPressed: () => Get.to(
                                  () => const QuizDetailView(),
                                  arguments: quiz.id),
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 16,
                                  color: AppColors.primaryPurple),
                              label: const Text('Lihat Detail',
                                  style: TextStyle(
                                      color: AppColors.primaryPurple,
                                      fontSize: 13)),
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_quiz_management',
        onPressed: () => _showCreateOptions(context),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('CREATE NOW',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _doShare(String quizId, String kelas, String quizTitle) async {
    try {
      await Get.find<QuizService>().shareQuiz(quizId, kelas);
      Get.snackbar(
        'Berhasil',
        'Kuis berhasil dishare ke kelas $kelas!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        margin: const EdgeInsets.all(16),
      );
      controller.fetchQuizzes();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal share kuis: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Widget _buildShareButton(BuildContext context, String quizId, String quizTitle) {
    return OutlinedButton.icon(
      onPressed: () => _showShareDialog(context, quizId, quizTitle),
      icon: const Icon(Icons.share, size: 16, color: AppColors.teal),
      label: const Text('Share',
          style: TextStyle(
              color: AppColors.teal,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.teal),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _infoChip(
      IconData icon, String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const Gap(4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, String quizId, String quizTitle) {
    String selectedClass = _kelasOptions.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setLocalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'Share Kuis ke Kelas',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurple),
                ),
                const Gap(6),
                Text(
                  quizTitle,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.grey600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(16),
                const Text('Pilih kelas tujuan:',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800)),
                const Gap(8),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  items: _kelasOptions
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
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
                      _doShare(quizId, selectedClass, quizTitle);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: Text('Share ke $selectedClass',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
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

  void _showCreateOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
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
              leading: const Icon(Icons.auto_awesome,
                  color: Color.fromARGB(255, 60, 52, 137)),
              title: const Text('Generate dengan AI'),
              subtitle: const Text(
                  'Buat kuis otomatis dari topik atau file PDF'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.GENERATE_FORM,
                    arguments: {'type': 'Quiz'});
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_note,
                  color: Color.fromARGB(255, 60, 52, 137)),
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
  }
}
