class UserModel {
  final String id;
  final String nama;
  final String email;
  final String role;
  final String? nip;
  final String? mapel;
  final String? jenjang;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.nip,
    this.mapel,
    this.jenjang,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      nip: json['nip'],
      mapel: json['mapel'],
      jenjang: json['jenjang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nama': nama,
      'email': email,
      'role': role,
      'nip': nip,
      'mapel': mapel,
      'jenjang': jenjang,
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
    final data = json['data'];
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: data != null && data['user'] != null 
          ? UserModel.fromJson(data['user']) 
          : null,
      token: data != null ? data['token'] : null,
    );
  }
}
