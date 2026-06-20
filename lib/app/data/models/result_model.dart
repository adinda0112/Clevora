class ResultModel {
  final String id;
  final dynamic siswa;
  final dynamic kuis;
  final int nilai;
  final int benar;
  final int salah;
  final int durasiPengerjaan;
  final bool berakhirPaksa;
  final String? createdAt;

  ResultModel({
    required this.id,
    this.siswa,
    this.kuis,
    required this.nilai,
    required this.benar,
    required this.salah,
    this.durasiPengerjaan = 0,
    this.berakhirPaksa = false,
    this.createdAt,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      id: json['_id'] ?? json['id'] ?? '',
      siswa: json['siswa'],
      kuis: json['kuis'],
      nilai: json['nilai'] ?? 0,
      benar: json['benar'] ?? 0,
      salah: json['salah'] ?? 0,
      durasiPengerjaan: json['durasiPengerjaan'] ?? 0,
      berakhirPaksa: json['berakhir_paksa'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  String get siswaNama {
    if (siswa is Map) {
      return siswa['nama'] ?? '-';
    }
    return '-';
  }

  String get siswaKelas {
    if (siswa is Map) {
      return siswa['kelas'] ?? '-';
    }
    return '-';
  }

  String get kuisJudul {
    if (kuis is Map) {
      return kuis['judul'] ?? '-';
    }
    return '-';
  }

  String get kuisMapel {
    if (kuis is Map) {
      return kuis['mapel'] ?? '-';
    }
    return '-';
  }
}
