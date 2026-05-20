import 'package:clevora/app/data/models/user_model.dart';
import 'package:clevora/app/data/models/question_model.dart';

class QuizModel {
  final String id;
  final String judul;
  final String? deskripsi;
  final UserModel? guru;
  final String? mapel;
  final String? kelas;
  final int durasi;
  final List<QuestionModel> soal;
  final DateTime? createdAt;

  QuizModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    this.guru,
    this.mapel,
    this.kelas,
    required this.durasi,
    required this.soal,
    this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['_id'] ?? json['id'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      guru: json['guru'] != null 
          ? (json['guru'] is String ? UserModel(id: json['guru'], nama: '', email: '', role: '') : UserModel.fromJson(json['guru'])) 
          : null,
      mapel: json['mapel'],
      kelas: json['kelas'],
      durasi: json['durasi'] ?? 30,
      soal: json['soal'] != null
          ? List<QuestionModel>.from(json['soal'].map((x) => QuestionModel.fromJson(x)))
          : [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'guru': guru?.toJson(),
      'mapel': mapel,
      'kelas': kelas,
      'durasi': durasi,
      'soal': List<dynamic>.from(soal.map((x) => x.toJson())),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
