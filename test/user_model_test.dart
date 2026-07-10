import 'package:flutter_test/flutter_test.dart';
import 'package:clevora/app/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('fromJson should parse correctly', () {
      final json = {
        '_id': 'user123',
        'nama': 'John Doe',
        'email': 'john@example.com',
        'role': 'guru',
        'nip': '199001012020121001',
        'sekolah': 'SMAN 1 Jakarta',
        'sudah_daftar_wajah': true,
        'is_verified': true,
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 'user123');
      expect(user.nama, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.role, 'guru');
      expect(user.nip, '199001012020121001');
      expect(user.sekolah, 'SMAN 1 Jakarta');
      expect(user.sudahDaftarWajah, true);
      expect(user.isVerified, true);
      expect(user.nisn, null);
    });

    test('toJson should convert correctly', () {
      final user = UserModel(
        id: 'user123',
        nama: 'John Doe',
        email: 'john@example.com',
        role: 'siswa',
        nisn: '0012345678',
        kelas: 'X IPA 1',
        sekolah: 'SMAN 1 Jakarta',
        sudahDaftarWajah: false,
        isVerified: false,
      );

      final json = user.toJson();

      expect(json['_id'], 'user123');
      expect(json['nama'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['role'], 'siswa');
      expect(json['nisn'], '0012345678');
      expect(json['kelas'], 'X IPA 1');
      expect(json['sekolah'], 'SMAN 1 Jakarta');
      expect(json['sudah_daftar_wajah'], false);
      expect(json['is_verified'], false);
      expect(json['nip'], null);
    });

    test('isProfileComplete should return true for valid guru', () {
      final user = UserModel(
        id: '1',
        nama: 'Guru',
        email: 'guru@test.com',
        role: 'guru',
        nip: '123456',
        sekolah: 'Sekolah',
      );
      expect(user.isProfileComplete, true);
    });

    test('isProfileComplete should return false for guru missing nip', () {
      final user = UserModel(
        id: '1',
        nama: 'Guru',
        email: 'guru@test.com',
        role: 'guru',
        sekolah: 'Sekolah',
      );
      expect(user.isProfileComplete, false);
    });

    test('isProfileComplete should return true for valid siswa', () {
      final user = UserModel(
        id: '2',
        nama: 'Siswa',
        email: 'siswa@test.com',
        role: 'siswa',
        nisn: '12345',
        kelas: 'X',
        sekolah: 'Sekolah',
      );
      expect(user.isProfileComplete, true);
    });

    test('isProfileComplete should return false for siswa missing kelas', () {
      final user = UserModel(
        id: '2',
        nama: 'Siswa',
        email: 'siswa@test.com',
        role: 'siswa',
        nisn: '12345',
        sekolah: 'Sekolah',
      );
      expect(user.isProfileComplete, false);
    });
  });

  group('AuthResponse Tests', () {
    test('fromJson should parse success correctly', () {
      final json = {
        'success': true,
        'message': 'Login successful',
        'data': {
          'user': {
            '_id': '123',
            'nama': 'Test User',
            'email': 'test@example.com',
            'role': 'guru'
          },
          'token': 'jwt_token_example'
        }
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, 'Login successful');
      expect(response.token, 'jwt_token_example');
      expect(response.user, isNotNull);
      expect(response.user?.nama, 'Test User');
    });

    test('fromJson should parse failure correctly', () {
      final json = {
        'success': false,
        'message': 'Invalid credentials'
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, false);
      expect(response.message, 'Invalid credentials');
      expect(response.token, null);
      expect(response.user, null);
    });
  });
}
