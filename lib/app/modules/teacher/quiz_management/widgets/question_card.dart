part of '../views/manual_quiz_questions_view.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final _QuestionDraft q;
  final VoidCallback onRemove;
  final ValueChanged<String> onQuestionChanged;
  final void Function(int, String) onOptionChanged;
  final ValueChanged<int> onAnswerChanged;
  final ValueChanged<String> onExplanationChanged;

  const QuestionCard({
    super.key,
    required this.index,
    required this.q,
    required this.onRemove,
    required this.onQuestionChanged,
    required this.onOptionChanged,
    required this.onAnswerChanged,
    required this.onExplanationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.darkPurple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  'Soal ${index + 1}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.white70, size: 20),
                  onPressed: onRemove,
                  tooltip: 'Hapus soal',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pertanyaan
                const Text('Pertanyaan',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const Gap(8),
                TextFormField(
                  initialValue: q.pertanyaan,
                  maxLines: 3,
                  onChanged: onQuestionChanged,
                  decoration: _inputDec(hint: 'Tulis pertanyaan soal ${index + 1}...'),
                ),
                const Gap(20),

                // Pilihan jawaban
                const Text('Pilihan Jawaban',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const Gap(12),
                ...List.generate(4, (j) => _buildOptionField(j)),
                const Gap(16),

                // Kunci jawaban
                const Text('Kunci Jawaban',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const Gap(10),
                Row(
                  children: List.generate(4, (j) {
                    final isSelected = q.kunciJawaban == j;
                    return GestureDetector(
                      onTap: () => onAnswerChanged(j),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 12),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurple : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : AppColors.grey300,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3))
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            ManualQuizQuestionsView.labels[j],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isSelected ? Colors.white : AppColors.grey500),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const Gap(20),

                // Penjelasan opsional
                const Text('Penjelasan (Opsional)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const Gap(8),
                TextFormField(
                  initialValue: q.penjelasan,
                  maxLines: 2,
                  onChanged: onExplanationChanged,
                  decoration: _inputDec(hint: 'Tambahkan pembahasan jawaban...'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionField(int optionIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                ManualQuizQuestionsView.labels[optionIndex],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple),
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: TextFormField(
              initialValue: q.pilihan[optionIndex],
              onChanged: (v) => onOptionChanged(optionIndex, v),
              decoration: _inputDec(hint: 'Opsi ${ManualQuizQuestionsView.labels[optionIndex]}'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
      ),
    );
  }
}
