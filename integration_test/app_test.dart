import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clevora/main.dart' as app;
import 'package:clevora/app/widgets/custom_bottom_nav.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Fungsi helper untuk delay (slow-motion)
  Future<void> delay([int seconds = 1]) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  group('End-to-End Test (Full Flow)', () {
    testWidgets('Registrasi Guru & Eksplorasi Penuh', (tester) async {
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

      // 3. Pilih Role: Guru
      expect(find.text('Guru'), findsWidgets);
      await delay(1);
      await tester.tap(find.text('Guru').first);
      await tester.pumpAndSettle();

      final lanjutBtn = find.widgetWithText(ElevatedButton, 'Lanjut');
      await delay(1);
      await tester.tap(lanjutBtn);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 4. Mengisi Form Pendaftaran Guru
      final textFields = find.byType(TextFormField);
      await delay(1);
      await tester.enterText(textFields.at(0), 'Guru E2E Test');
      await delay(1); 
      final uniqueEmail = 'guru_${DateTime.now().millisecondsSinceEpoch}@test.com';
      await tester.enterText(textFields.at(1), uniqueEmail);
      await delay(1);
      await tester.enterText(textFields.at(2), 'SMA Testing E2E');
      await delay(1);
      await tester.enterText(textFields.at(3), '123456789012345678');
      
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      
      final mapelChip = find.widgetWithText(FilterChip, 'Matematika');
      await delay(1);
      await tester.tap(mapelChip);
      await tester.pumpAndSettle();

      await tester.enterText(textFields.at(4), 'password123');
      await delay(1);
      await tester.enterText(textFields.at(5), 'password123');

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

      // 6. Dashboard Guru
      expect(find.text('Generate Cepat'), findsOneWidget);
      await delay(2);

      final bottomNav = find.byType(CustomBottomNav);
      
      // Tap Modul AI (Index 1)
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.smart_toy_outlined)));
      await tester.pumpAndSettle();
      await delay(2);

      // Mulai buat Kuis AI
      final genQuiz = find.text('Generate Quiz');
      await tester.tap(genQuiz);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await delay(1);

      // Isi form Kuis
      final txtTopik = find.byType(TextField); // Topik
      await tester.enterText(txtTopik.first, 'Sistem Tata Surya');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await delay(1);

      // Scroll ke bawah
      await tester.drag(find.byType(SingleChildScrollView).last, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Klik Generate
      final genBtn = find.widgetWithText(ElevatedButton, 'Generate dengan AI');
      await delay(1);
      await tester.tap(genBtn);
      
      // Tunggu AI memproses (lama)
      await tester.pumpAndSettle(const Duration(seconds: 25));
      await delay(2);

      // Di halaman preview, cari tombol Simpan (SIMPAN)
      final simpanBtn = find.widgetWithText(ElevatedButton, 'SIMPAN');
      if (simpanBtn.evaluate().isNotEmpty) {
         await tester.tap(simpanBtn);
         await tester.pumpAndSettle(const Duration(seconds: 5));
         await delay(1);
      }

      // Selesai
      final selesaiBtn = find.widgetWithText(ElevatedButton, 'SELESAI');
      if (selesaiBtn.evaluate().isNotEmpty) {
         await tester.tap(selesaiBtn);
         await tester.pumpAndSettle(const Duration(seconds: 2));
      }
      
      await delay(1);
      // Kembali ke bottom nav Quiz
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.quiz_outlined)));
      await tester.pumpAndSettle();
      await delay(2);
      
      // Cek report
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.bar_chart_outlined)));
      await tester.pumpAndSettle();
      await delay(2);

      // Ke Profil untuk Logout
      await tester.tap(find.descendant(of: bottomNav, matching: find.byIcon(Icons.person_outline)));
      await tester.pumpAndSettle();
      await delay(2);

      // Scroll ke tombol Keluar
      await tester.drag(find.byType(SingleChildScrollView).last, const Offset(0, -500));
      await tester.pumpAndSettle();

      final keluarBtn = find.widgetWithText(ElevatedButton, 'Logout');
      await delay(1);
      await tester.tap(keluarBtn);
      await tester.pumpAndSettle();
      await delay(1);

      // Konfirmasi Logout
      final yaBtn = find.widgetWithText(ElevatedButton, 'Ya, Keluar');
      await tester.tap(yaBtn);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verifikasi kembali ke layar login (Splash atau Login)
      expect(find.text('Mulai sekarang'), findsWidgets);
      await delay(2);
      
      // Pengujian Selesai!
    });
  });
}
