class QuestionModel {
  final String id;
  final String kuisId;
  final String pertanyaan;
  final List<String> pilihan;
  final int kunciJawaban;
  final String? penjelasan;

  QuestionModel({
    required this.id,
    required this.kuisId,
    required this.pertanyaan,
    required this.pilihan,
    required this.kunciJawaban,
    this.penjelasan,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] ?? json['id'] ?? '',
      kuisId: json['kuis'] ?? '',
      pertanyaan: json['pertanyaan'] ?? '',
      pilihan: List<String>.from(json['pilihan'] ?? []),
      kunciJawaban: json['kunciJawaban'] ?? 0,
      penjelasan: json['penjelasan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'kuis': kuisId,
      'pertanyaan': pertanyaan,
      'pilihan': pilihan,
      'kunciJawaban': kunciJawaban,
      'penjelasan': penjelasan,
    };
  }
}
