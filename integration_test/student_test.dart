import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clevora/main.dart' as app;
import 'package:clevora/app/widgets/student_bottom_nav.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> delay([int seconds = 1]) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  group('End-to-End Test (Student Flow)', () {
    testWidgets('Registrasi Siswa & Uji Anti-Cheat (Kamera)', (tester) async {
      // 1. Membersihkan memori lokal
      await GetStorage.init();
      final box = GetStorage();
      await box.erase();
      const secureStorage = FlutterSecureStorage();
      await secureStorage.deleteAll();

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Klik "Mulai sekarang" di Splash Screen
      final mulaiSekarangBtn = find.widgetWithText(ElevatedButton, 'Mulai sekarang');
      expect(mulaiSekarangBtn, findsOneWidget);
      await delay(2);
      await tester.tap(mulaiSekarangBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 3. Pilih Role: Siswa
      expect(find.text('Siswa'), findsWidgets);
      await delay(1);
      await tester.tap(find.text('Siswa').first);
      await tester.pumpAndSettle();

      final lanjutBtn = find.widgetWithText(ElevatedButton, 'Lanjut');
      await delay(1);
      await tester.tap(lanjutBtn);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 4. Mengisi Form Pendaftaran Siswa
      final textFields = find.byType(TextFormField);
      await delay(1);
      await tester.enterText(textFields.at(0), 'Siswa Anti Nyontek'); // Nama
      await delay(1); 
      final uniqueEmail = 'siswa_${DateTime.now().millisecondsSinceEpoch}@test.com';
      await tester.enterText(textFields.at(1), uniqueEmail); // Email
      await delay(1);
      await tester.enterText(textFields.at(2), 'SMA Testing E2E'); // Sekolah
      await delay(1);
      await tester.enterText(textFields.at(3), '0012345678'); // NISN
      
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      
      await tester.enterText(textFields.at(4), 'password123'); // Pass
      await delay(1);
      await tester.enterText(textFields.at(5), 'password123'); // Confirm Pass

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      
      final daftarBtn = find.widgetWithText(ElevatedButton, 'Daftar');
      await tester.ensureVisible(daftarBtn);
      await delay(1);
      await tester.tap(daftarBtn);
      
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 5. Layar OTP
      expect(find.text('Cek Email Kamu'), findsWidgets);
      await delay(1);
      final editableText = find.byType(EditableText);
      await tester.enterText(editableText.first, '123456');
      await tester.pumpAndSettle();

      final verifyBtn = find.widgetWithText(ElevatedButton, 'Verifikasi & Aktivasi Akun');
      await delay(1);
      await tester.tap(verifyBtn);
      
      await tester.pumpAndSettle(const Duration(seconds: 6));

      // 6. Dashboard Siswa
      await delay(2);

      final bottomNav = find.byType(StudentBottomNav);
      
      // Tap Quiz (Index 2)
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.assignment_turned_in_outlined)));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await delay(2);

      // Cari tombol Mulai di list quiz (Kita asumsikan quiz dari guru tadi ada di sini)
      final mulaiKuisBtn = find.widgetWithText(ElevatedButton, 'Mulai');
      if (mulaiKuisBtn.evaluate().isNotEmpty) {
        await tester.tap(mulaiKuisBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else {
        // Jika tidak ada kuis, batalkan tes
        fail('Tidak ada kuis aktif ditemukan untuk diuji.');
      }
      
      await delay(2);

      // 7. Instruksi Ujian
      expect(find.text('Instruksi Ujian'), findsOneWidget);
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      await delay(1);

      final mulaiUjianBtn = find.widgetWithText(ElevatedButton, 'Mulai Ujian Sekarang');
      await tester.tap(mulaiUjianBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 8. Di dalam Ujian (Menguji Anti-Cheat)
      // Kita tunggu peringatan muncul dari Computer Vision (Backend)
      // Karena emulator, frame bernilai "wajah_tidak_ada".
      // Python akan mengembalikan pelanggaran tiap 4 detik.
      
      bool isKicked = false;
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(seconds: 4)); // interval kamera backend
        await delay(1);
        
        // Periksa apakah ujian sudah disubmit paksa & kembali ke hasil
        if (find.text('Kembali ke Beranda').evaluate().isNotEmpty || find.text('Total Soal').evaluate().isNotEmpty) {
           isKicked = true;
           break;
        }
      }

      expect(isKicked, true, reason: 'Siswa harus di-kick dari ujian karena tidak mendeteksi wajah di kamera!');
      await delay(3);
      
      // Pengujian Selesai!
    });
  });
}
