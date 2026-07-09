class ValidationHelper {
  static String? validateNip(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'NIP wajib diisi';
    }
    final trimmed = val.trim();
    if (trimmed.length != 18) {
      return 'NIP harus terdiri dari 18 angka';
    }
    if (int.tryParse(trimmed) == null) {
      return 'NIP hanya boleh berisi angka';
    }
    return null;
  }

  static String? validateNisn(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'NISN wajib diisi';
    }
    final trimmed = val.trim();
    if (int.tryParse(trimmed) == null) {
      return 'NISN hanya boleh berisi angka';
    }
    return null;
  }

  static String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final trimmed = val.trim();
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Password wajib diisi';
    }
    final trimmed = val.trim();
    if (trimmed.length < 8) {
      return 'Password minimal harus 8 karakter';
    }
    return null;
  }
}
