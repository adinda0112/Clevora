import 'package:flutter_test/flutter_test.dart';
import 'package:clevora/app/data/utils/validation_helper.dart';

void main() {
  group('ValidationHelper - NIP Validation', () {
    test('should return error if NIP is empty', () {
      expect(ValidationHelper.validateNip(''), 'NIP wajib diisi');
      expect(ValidationHelper.validateNip(null), 'NIP wajib diisi');
    });

    test('should return error if NIP is not 18 characters', () {
      expect(ValidationHelper.validateNip('12345678901234567'), 'NIP harus terdiri dari 18 angka');
      expect(ValidationHelper.validateNip('1234567890123456789'), 'NIP harus terdiri dari 18 angka');
    });

    test('should return error if NIP contains non-digits', () {
      expect(ValidationHelper.validateNip('12345678901234567a'), 'NIP hanya boleh berisi angka');
    });

    test('should return null (valid) for a correct 18 digit NIP', () {
      expect(ValidationHelper.validateNip('199801012022031001'), isNull);
    });
  });

  group('ValidationHelper - Email Validation', () {
    test('should return error if email is empty', () {
      expect(ValidationHelper.validateEmail(''), 'Email wajib diisi');
      expect(ValidationHelper.validateEmail(null), 'Email wajib diisi');
    });

    test('should return error for invalid email formats', () {
      expect(ValidationHelper.validateEmail('invalidemail'), 'Format email tidak valid');
      expect(ValidationHelper.validateEmail('invalidemail@'), 'Format email tidak valid');
      expect(ValidationHelper.validateEmail('invalidemail@domain'), 'Format email tidak valid');
    });

    test('should return null (valid) for correct email format', () {
      expect(ValidationHelper.validateEmail('teacher@clevora.com'), isNull);
      expect(ValidationHelper.validateEmail('student.test@school.sch.id'), isNull);
    });
  });

  group('ValidationHelper - NISN Validation', () {
    test('should return error if NISN is empty', () {
      expect(ValidationHelper.validateNisn(''), 'NISN wajib diisi');
      expect(ValidationHelper.validateNisn(null), 'NISN wajib diisi');
    });

    test('should return error if NISN contains non-digits', () {
      expect(ValidationHelper.validateNisn('12345a7890'), 'NISN hanya boleh berisi angka');
    });

    test('should return null (valid) for a valid numeric NISN', () {
      expect(ValidationHelper.validateNisn('0012345678'), isNull);
    });
  });

  group('ValidationHelper - Password Validation', () {
    test('should return error if password is empty', () {
      expect(ValidationHelper.validatePassword(''), 'Password wajib diisi');
      expect(ValidationHelper.validatePassword(null), 'Password wajib diisi');
    });

    test('should return error if password is less than 8 characters', () {
      expect(ValidationHelper.validatePassword('1234567'), 'Password minimal harus 8 karakter');
    });

    test('should return null (valid) if password is 8 characters or more', () {
      expect(ValidationHelper.validatePassword('12345678'), isNull);
      expect(ValidationHelper.validatePassword('mySecurePassword123!'), isNull);
    });
  });
}
