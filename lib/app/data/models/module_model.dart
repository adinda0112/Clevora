import 'package:clevora/app/data/models/user_model.dart';

class ModuleModel {
  final String id;
  final String judul;
  final String? deskripsi;
  final String konten;
  final UserModel? guru;
  final String? mapel;
  final String? jenjang;
  final String? kelas;
  final String? jenis;
  final DateTime? createdAt;

  ModuleModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    required this.konten,
    this.guru,
    this.mapel,
    this.jenjang,
    this.kelas,
    this.jenis,
    this.createdAt,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'] ?? json['id'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      konten: json['konten'] ?? '',
      guru: json['guru'] != null 
          ? (json['guru'] is String ? UserModel(id: json['guru'], nama: '', email: '', role: '') : UserModel.fromJson(json['guru'])) 
          : null,
      mapel: json['mapel'],
      jenjang: json['jenjang'],
      kelas: json['kelas'],
      jenis: json['jenis'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'konten': konten,
      'guru': guru?.toJson(),
      'mapel': mapel,
      'jenjang': jenjang,
      'kelas': kelas,
      'jenis': jenis,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
