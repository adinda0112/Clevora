class UserModel {
  final String id;
  final String nama;
  final String email;
  final String role; // 'guru' | 'siswa'
  final String? nip;
  final String? mapel;
  final String? jenjang;
  final String token;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.nip,
    this.mapel,
    this.jenjang,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? '',
    nama: json['nama'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'guru',
    nip: json['nip'],
    mapel: json['mapel'],
    jenjang: json['jenjang'],
    token: json['token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'nama': nama,
    'email': email,
    'role': role,
    'nip': nip,
    'mapel': mapel,
    'jenjang': jenjang,
    'token': token,
  };
}
