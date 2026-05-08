# 🤖 VS Code Agent Prompt — Auth Screens Flutter GetX
# Paste prompt ini ke GitHub Copilot Chat / Cursor AI / Claude Dev di VS Code

---

## PROMPT UTAMA (copy semua teks di bawah ini ke Agent):

---

Saya punya project Flutter bernama **Clevora** dengan struktur folder berikut:

```
lib/
├── app/
│   ├── data/
│   ├── modules/
│   │   └── home/
│   │       ├── bindings/
│   │       │   └── home_binding.dart
│   │       ├── controllers/
│   │       │   └── home_controller.dart
│   │       └── views/
│   │           └── home_view.dart
│   └── routes/
│       ├── app_pages.dart
│       └── app_routes.dart
└── main.dart
```

Tolong buatkan **Auth module lengkap** (Splash, Login, Register, OTP) mengikuti struktur yang SAMA persis seperti di atas.

---

### 📁 STRUKTUR YANG HARUS DIBUAT:

```
lib/
├── app/
│   ├── data/
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── providers/
│   │   │   └── api_provider.dart
│   │   └── repositories/
│   │       └── auth_repository.dart
│   │
│   ├── modules/
│   │   ├── home/                    ← sudah ada, jangan diubah
│   │   │
│   │   ├── splash/
│   │   │   ├── bindings/
│   │   │   │   └── splash_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── splash_controller.dart
│   │   │   └── views/
│   │   │       └── splash_view.dart
│   │   │
│   │   ├── login/
│   │   │   ├── bindings/
│   │   │   │   └── login_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart
│   │   │   └── views/
│   │   │       └── login_view.dart
│   │   │
│   │   ├── register/
│   │   │   ├── bindings/
│   │   │   │   └── register_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── register_controller.dart
│   │   │   └── views/
│   │   │       └── register_view.dart
│   │   │
│   │   └── otp/
│   │       ├── bindings/
│   │       │   └── otp_binding.dart
│   │       ├── controllers/
│   │       │   └── otp_controller.dart
│   │       └── views/
│   │           └── otp_view.dart
│   │
│   ├── routes/
│   │   ├── app_pages.dart           ← UPDATE file ini
│   │   └── app_routes.dart          ← UPDATE file ini
│   │
│   └── theme/
│       └── app_theme.dart           ← BUAT BARU
│
└── main.dart                        ← UPDATE file ini
```

---

### 🎨 DESIGN SYSTEM (wajib pakai ini):

```dart
// Warna utama
static const purple      = Color(0xFF534AB7);
static const purpleDark  = Color(0xFF26215C);
static const purpleLight = Color(0xFFEEEDFE);
static const teal        = Color(0xFF1D9E75);
static const tealLight   = Color(0xFFE1F5EE);
static const amber       = Color(0xFFEF9F27);
static const error       = Color(0xFFE24B4A);
static const grey50      = Color(0xFFF9FAFB);
static const grey200     = Color(0xFFE5E7EB);
static const grey400     = Color(0xFF9CA3AF);
static const grey600     = Color(0xFF4B5563);
static const grey900     = Color(0xFF111827);

// Font
fontFamily: 'Nunito'
```

---

### 📦 DEPENDENCIES (tambahkan ke pubspec.yaml):

```yaml
dependencies:
  get: ^4.6.6
  get_storage: ^2.1.1
  dio: ^5.4.0
  pinput: ^3.0.1
  flutter_animate: ^4.5.0
  gap: ^3.0.1
  email_validator: ^2.1.17
  flutter_secure_storage: ^9.0.0
  cached_network_image: ^3.3.1
```

---

### 📄 ISI TIAP FILE:

---

#### `app/routes/app_routes.dart`
```dart
abstract class Routes {
  static const SPLASH    = '/splash';
  static const LOGIN     = '/login';
  static const REGISTER  = '/register';
  static const OTP       = '/otp';
  static const HOME      = '/home';
}
```

---

#### `app/routes/app_pages.dart`
```dart
import 'package:get/get.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
```

---

#### `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ClevoraApp());
}

class ClevoraApp extends StatelessWidget {
  const ClevoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clevora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
```

---

#### `app/theme/app_theme.dart`
Buat file ini dengan ThemeData lengkap menggunakan warna di atas.
ElevatedButton default: background purple, radius 12, height 50, font Nunito SemiBold.
InputDecoration default: border radius 10, focused border purple 1.5px.

---

#### `app/data/models/user_model.dart`
```dart
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
    required this.id, required this.nama, required this.email,
    required this.role, this.nip, this.mapel, this.jenjang,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? '', nama: json['nama'] ?? '',
    email: json['email'] ?? '', role: json['role'] ?? 'guru',
    nip: json['nip'], mapel: json['mapel'], jenjang: json['jenjang'],
    token: json['token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id, 'nama': nama, 'email': email, 'role': role,
    'nip': nip, 'mapel': mapel, 'jenjang': jenjang, 'token': token,
  };
}
```

---

#### `app/data/providers/api_provider.dart`
Buat dengan Dio. baseUrl = 'https://api.clevora.id/api'.
Tambahkan interceptor: attach Bearer token dari GetStorage('token') ke setiap request.
Jika response 401, hapus storage dan Get.offAllNamed('/login').
Method yang dibutuhkan:
- login(email, password, role) → POST /auth/login
- register(Map data) → POST /auth/register  
- verifyOtp(email, otp) → POST /auth/verify-otp
- resendOtp(email) → POST /auth/resend-otp

---

#### `app/data/repositories/auth_repository.dart`
Wrap ApiProvider. Method: login(), register(), verifyOtp(), resendOtp(), logout().
Simpan token & user ke GetStorage setelah login/verifyOtp berhasil.
Expose: bool isLoggedIn, UserModel? currentUser.

---

### 🖥️ UI TIAP SCREEN:

#### SPLASH VIEW
- Background gradient gelap: Color(0xFF1B1753) → Color(0xFF3C3489)
- Logo icon school_rounded dalam container rounded, putih transparan
- Teks "Clevora" bold putih 28px
- Subtitle "Platform Pembelajaran Cerdas" 
- Badge "✦ Powered by AI" 
- Stats row: 3 chip (12rb+ Guru, 50rb+ Soal, 99% Kepuasan)
- Bottom white card dengan rounded top 24px berisi:
  - Tagline, deskripsi singkat
  - 4 feature chips (AI Generate, Kurikulum Merdeka, Infografis, Export PDF)
  - Tombol "Mulai sekarang" (purple solid)
  - Tombol "Saya sudah punya akun" (purple outline)
- Animasi: logo scale elasticOut 600ms, teks fadeIn+slideY, card slideY dari bawah

#### LOGIN VIEW  
- Header purple gradient (sama dengan splash) berisi: back button, icon login, judul, subtitle
- Body putih dengan Form:
  - Role selector: 2 kartu (Guru & Siswa) dengan icon, bisa dipilih salah satu
  - TextField Email dengan icon mail, validator
  - TextField Password dengan icon lock, toggle visibility, validator
  - Row: checkbox "Ingat saya" + link "Lupa kata sandi?"
  - Tombol "Masuk" (PrimaryButton dengan loading state)
  - Divider "atau masuk dengan"
  - 2 social button: Google & Microsoft (outline)
  - Link "Belum punya akun? Daftar sekarang"
- Gunakan Obx() untuk reactive state

#### REGISTER VIEW
- Header sama dengan login (back button, icon person_add, judul, subtitle step)  
- Step indicator 3 langkah (animasi dot + line berubah warna)
- Step 0 (Pilih Peran): 2 BigRoleCard (Guru & Siswa) dengan fitur list, icon, animasi selected
- Step 1 (Data Diri): Form dengan nama, email, NIP(opsional), dropdown mapel & jenjang, password + strength bar (4 segmen), konfirmasi password
- AnimatedSwitcher antar step dengan slideX + fadeIn
- Tombol navigasi: "Kembali" outline + "Lanjut/Daftar" primary

#### OTP VIEW
- Header: icon mail hijau, judul "Cek email kamu", tampilkan email tujuan
- Step indicator semua done kecuali step 3 active
- Info box purple light berisi instruksi
- Pinput 6 digit:
  - defaultPinTheme: grey border, background grey50
  - focusedPinTheme: purple border 2px, background purpleLight
  - submittedPinTheme: purple border, background purpleLight
- Countdown timer MM:SS (merah jika < 60 detik)
- Link "Kirim ulang" (aktif setelah countdown habis)
- Tombol "Verifikasi & Aktivasi Akun"
- Tips box abu-abu
- Success state: animasi check circle hijau + loading spinner → navigate ke HOME

---

### ⚡ CONTROLLER LOGIC:

#### SplashController
- onInit: delay 2 detik, cek isLoggedIn → navigate HOME atau biarkan di splash
- Method: goToLogin(), goToRegister()

#### LoginController  
- State: selectedRole.obs, obscurePass.obs, isLoading.obs, rememberMe.obs
- login(): validate form → call repo → navigate HOME / show snackbar error
- Validators: validateEmail(), validatePassword()

#### RegisterController
- State: currentStep.obs (0 atau 1), selectedRole.obs, selectedMapel.obs, selectedJenjang.obs, obscurePass.obs, obscureConfirm.obs, isLoading.obs, passwordStrength.obs (0-4)
- checkPasswordStrength(pass): cek panjang >=8, huruf besar, angka, simbol
- nextStep(): validasi form step aktif → jika step 1 call _register() → navigate OTP
- prevStep(): kurangi currentStep
- _register(): call repo.register() → Get.toNamed('/otp', arguments: {'email': ...})

#### OtpController
- State: otpCode.obs, isLoading.obs, isSuccess.obs, countdown.obs (300), canResend.obs
- onInit: ambil email dari Get.arguments, mulai countdown Timer 1 detik
- verify(): jika otpCode.length != 6 → snackbar, else call repo.verifyOtp() → isSuccess = true → delay 2s → HOME
- resendOtp(): jika canResend → call repo.resendOtp() → reset countdown
- countdownFormatted: getter string MM:SS

---

### ✅ ATURAN PENTING:
1. Semua file ikuti struktur: `modules/[nama]/bindings/`, `controllers/`, `views/`
2. Gunakan `GetView<ControllerType>` untuk semua View
3. Semua state pakai `.obs` dan dibungkus `Obx()`
4. Snackbar error: background merah, snackPosition BOTTOM, borderRadius 12, margin 16
5. Snackbar sukses: background teal
6. Semua animasi pakai `flutter_animate` package
7. Import path relatif (jangan pakai absolute path)
8. Jangan ubah file `home/` yang sudah ada

---

Buatkan semua file sesuai struktur dan spesifikasi di atas. Mulai dari:
1. pubspec.yaml (tambah dependencies)
2. app_routes.dart
3. app_pages.dart  
4. app_theme.dart
5. user_model.dart
6. api_provider.dart
7. auth_repository.dart
8. Semua splash files (binding, controller, view)
9. Semua login files
10. Semua register files
11. Semua otp files
12. Update main.dart
