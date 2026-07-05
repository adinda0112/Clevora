class UserModel {
  final String id;
  final String nama;
  final String email;
  final String role;
  final String? nip;
  final String? nisn;
  final String? kelas;
  final String? sekolah;
  final String? fotoWajahUrl;
  final String? fotoProfilBase64;
  final bool sudahDaftarWajah;
  final bool isVerified;
  final String? fcmToken;
  final String? mapel;
  final String? jenjang;
  final String? jurusan;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.nip,
    this.nisn,
    this.kelas,
    this.sekolah,
    this.fotoWajahUrl,
    this.fotoProfilBase64,
    this.sudahDaftarWajah = false,
    this.isVerified = false,
    this.fcmToken,
    this.mapel,
    this.jenjang,
    this.jurusan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      nip: json['nip']?.toString(),
      nisn: json['nisn']?.toString(),
      kelas: json['kelas']?.toString(),
      sekolah: json['sekolah']?.toString(),
      fotoWajahUrl: json['foto_wajah_url']?.toString() ?? json['fotoWajahUrl']?.toString(),
      fotoProfilBase64: json['foto_profil_base64']?.toString(),
      sudahDaftarWajah: json['sudah_daftar_wajah'] ?? json['sudahDaftarWajah'] ?? false,
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      fcmToken: json['fcm_token']?.toString() ?? json['fcmToken']?.toString(),
      mapel: json['mapel']?.toString(),
      jenjang: json['jenjang']?.toString(),
      jurusan: json['jurusan']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nama': nama,
      'email': email,
      'role': role,
      'nip': nip,
      'nisn': nisn,
      'kelas': kelas,
      'sekolah': sekolah,
      'foto_wajah_url': fotoWajahUrl,
      'foto_profil_base64': fotoProfilBase64,
      'sudah_daftar_wajah': sudahDaftarWajah,
      'is_verified': isVerified,
      'fcm_token': fcmToken,
      'mapel': mapel,
      'jenjang': jenjang,
      'jurusan': jurusan,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final dynamic data = json['data'];
    final dynamic userJson = data != null ? data['user'] : json['user'];
    final String? tokenStr = data != null ? data['token'] : json['token'];
    final bool successVal = json['success'] ?? (tokenStr != null);

    return AuthResponse(
      success: successVal,
      message: json['message'] ?? '',
      user: userJson != null ? UserModel.fromJson(userJson) : null,
      token: tokenStr,
    );
  }
}
