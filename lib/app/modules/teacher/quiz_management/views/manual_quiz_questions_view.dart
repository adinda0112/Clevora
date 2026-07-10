import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/routes/app_routes.dart';

part '../widgets/question_card.dart';

class _QuestionDraft {
  String pertanyaan;
  List<String> pilihan;
  int kunciJawaban;
  String penjelasan;

  _QuestionDraft()
      : pertanyaan = '',
        pilihan = ['', '', '', ''],
        kunciJawaban = 0,
        penjelasan = '';
}

class ManualQuizQuestionsView extends StatefulWidget {
  static const List<String> labels = ['A', 'B', 'C', 'D'];

  const ManualQuizQuestionsView({super.key});

  @override
  State<ManualQuizQuestionsView> createState() =>
      _ManualQuizQuestionsViewState();
}

class _ManualQuizQuestionsViewState extends State<ManualQuizQuestionsView> {
  late final String quizId;
  late final String quizTitle;
  final List<_QuestionDraft> _questions = [];
  bool _isSaving = false;

  static const List<String> _kelasOptions = [
    'X IPA 1', 'X IPA 2', 'X IPS 1', 'X IPS 2',
    'XI IPA 1', 'XI IPA 2', 'XI IPS 1', 'XI IPS 2',
    'XII IPA 1', 'XII IPA 2', 'XII IPS 1', 'XII IPS 2',
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    quizId = args['quizId'] ?? '';
    quizTitle = args['quizTitle'] ?? 'Kuis Baru';
    // Start with one empty question
    _questions.add(_QuestionDraft());
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuestionDraft());
    });
    // Scroll to bottom after adding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // handled by scroll controller below
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) {
      Get.snackbar('Info', 'Minimal harus ada 1 soal.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() {
      _questions.removeAt(index);
    });
  }

  bool _validate() {
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.pertanyaan.trim().isEmpty) {
        Get.snackbar('Validasi Gagal', 'Pertanyaan soal ke-${i + 1} belum diisi.',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      for (int j = 0; j < 4; j++) {
        if (q.pilihan[j].trim().isEmpty) {
          Get.snackbar('Validasi Gagal',
              'Pilihan ${ManualQuizQuestionsView.labels[j]} pada soal ke-${i + 1} belum diisi.',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _save({String? shareClass}) async {
    if (!_validate()) return;

    setState(() => _isSaving = true);
    try {
      final quizService = Get.find<QuizService>();
      for (final q in _questions) {
        await quizService.addQuestion(
          quizId,
          pertanyaan: q.pertanyaan.trim(),
          pilihan: q.pilihan.map((p) => p.trim()).toList(),
          kunciJawaban: q.kunciJawaban,
          penjelasan:
              q.penjelasan.trim().isNotEmpty ? q.penjelasan.trim() : null,
        );
      }

      if (shareClass != null) {
        await quizService.shareQuiz(quizId, shareClass);
      }

      Get.snackbar(
        'Berhasil',
        shareClass != null
            ? 'Kuis berhasil disimpan dan dishare ke kelas $shareClass!'
            : 'Kuis berhasil disimpan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        margin: const EdgeInsets.all(16),
      );

      // Pop back to quiz management
      Get.until((route) =>
          Get.currentRoute == Routes.QUIZ_MANAGEMENT ||
          Get.currentRoute == Routes.TEACHER_MAIN);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan soal: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showShareSheet() {
    String selectedClass = _kelasOptions.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setLocal) {
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
                const Gap(8),
                const Text(
                  'Pilih kelas tujuan untuk membagikan kuis ini:',
                  style: TextStyle(fontSize: 14, color: AppColors.grey600),
                ),
                const Gap(16),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  items: _kelasOptions
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setLocal(() => selectedClass = val);
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
                      _save(shareClass: selectedClass);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Simpan & Share Sekarang',
                        style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          quizTitle,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () => _addQuestion(),
            icon: const Icon(Icons.add_circle_outline,
                color: Colors.white, size: 20),
            label: const Text('Tambah Soal',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.quiz_outlined,
                      size: 72, color: AppColors.grey400),
                  const Gap(16),
                  const Text('Belum ada soal',
                      style: TextStyle(
                          fontSize: 16, color: AppColors.grey600)),
                  const Gap(16),
                  ElevatedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Soal Pertama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _questions.length,
              itemBuilder: (ctx, index) => QuestionCard(
                index: index,
                q: _questions[index],
                onRemove: () => _removeQuestion(index),
                onQuestionChanged: (v) => setState(() => _questions[index].pertanyaan = v),
                onOptionChanged: (optionIndex, v) => setState(() => _questions[index].pilihan[optionIndex] = v),
                onAnswerChanged: (j) => setState(() => _questions[index].kunciJawaban = j),
                onExplanationChanged: (v) => setState(() => _questions[index].penjelasan = v),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.grey200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question count info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_questions.length} soal',
                    style: const TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add,
                      size: 18, color: AppColors.primaryPurple),
                  label: const Text('+ Tambah Soal',
                      style: TextStyle(color: AppColors.primaryPurple)),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                // SIMPAN
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _isSaving ? null : () => _save(shareClass: null),
                    icon: _isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.save,
                            size: 18, color: Colors.white),
                    label: const Text('SIMPAN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
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
                    onPressed: _isSaving ? null : _showShareSheet,
                    icon: const Icon(Icons.share,
                        size: 18, color: Colors.white),
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
        ),
      ),
    );
  }
}
