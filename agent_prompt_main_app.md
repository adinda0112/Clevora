```txt
# 🤖 VS Code Agent Prompt — Main App Flutter GetX
# Paste prompt ini ke Antigravity / Copilot / Cursor AI

Saya sudah memiliki auth module Flutter GetX:
- Splash
- Login
- Register
- OTP

Jangan ubah auth module yang sudah ada.

Sekarang lanjutkan membuat MAIN APPLICATION UI untuk aplikasi Flutter bernama Clevora.

==================================================
PENTING
==================================================

- Gunakan Flutter native
- Gunakan GetX architecture
- Jangan gunakan HTML
- Jangan convert HTML ke Flutter
- Fokus UI ONLY
- Tidak perlu backend/API/Firebase
- Yang penting semua page bisa RUN tanpa error
- Gunakan reusable widgets
- Mobile first
- UI modern AI Education App

==================================================
GETX STRUCTURE
==================================================

Gunakan struktur berikut:

lib/
└── app/
    ├── modules/
    │
    │   ├── dashboard/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   ├── module/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   ├── quiz/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   ├── generate/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   ├── exam/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   ├── result/
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   │
    │   └── profile/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    │
    ├── widgets/
    │   ├── stat_card.dart
    │   ├── menu_card.dart
    │   ├── quiz_card.dart
    │   ├── custom_chip.dart
    │   ├── custom_bottom_nav.dart
    │   └── primary_button.dart
    │
    ├── routes/
    │   ├── app_pages.dart
    │   └── app_routes.dart
    │
    └── theme/
        └── app_theme.dart

==================================================
DESIGN SYSTEM
==================================================

Gunakan warna berikut:

primaryPurple = Color(0xFF7F77DD)
darkPurple = Color(0xFF3C3489)
lightPurple = Color(0xFFEEEDFE)

teal = Color(0xFF1D9E75)
lightTeal = Color(0xFFE1F5EE)

amber = Color(0xFFEF9F27)
lightAmber = Color(0xFFFAEEDA)

coral = Color(0xFFD85A30)
lightCoral = Color(0xFFFAECE7)

grey50 = Color(0xFFF9FAFB)
grey200 = Color(0xFFE5E7EB)
grey400 = Color(0xFF9CA3AF)
grey600 = Color(0xFF4B5563)
grey900 = Color(0xFF111827)

Gunakan:
- Border radius 12-16
- Soft shadow
- Gradient purple
- White clean card
- Nunito font
- Modern mobile app style

==================================================
DEPENDENCIES
==================================================

Gunakan:
- get
- gap
- flutter_animate

Jangan gunakan package lain.

==================================================
GETX RULES
==================================================

WAJIB:
- Semua view extends GetView<Controller>
- Semua controller extends GetxController
- Semua state menggunakan .obs
- Gunakan Obx()
- Semua route didaftarkan
- Gunakan reusable widgets
- Pisahkan widget besar menjadi widget kecil

==================================================
SCREEN YANG HARUS DIBUAT
==================================================

1. DASHBOARD SCREEN
- Header gradient
- Greeting user
- Search bar
- 3 statistic cards
- Grid menu utama
- Aktivitas terbaru
- Bottom navigation

2. MODULE SCREEN
- Modul ajar list
- Progress indicator
- Filter chips
- Floating action button
- Banner Generate ATP AI

3. QUIZ SCREEN
- Quiz category tabs
- Quiz cards
- Status badge
- Action buttons

4. GENERATE AI SCREEN
- Form generate soal AI
- Dropdown
- Generate button
- Generated question card
- Correct answer highlight

5. EXAM SCREEN
- Quiz timer
- Progress bar
- Question card
- Multiple choice answer
- Navigation button

6. RESULT SCREEN
- Big score card
- Statistic result
- Progress score bars
- Export PDF button
- Infographic button

7. PROFILE SCREEN
- User avatar
- Teacher information
- Settings menu
- Logout button

==================================================
OUTPUT
==================================================

Generate:
1. Semua bindings
2. Semua controllers
3. Semua views
4. Semua reusable widgets
5. Update app_routes.dart
6. Update app_pages.dart

PENTING:
- Jangan jelaskan teori
- Jangan pseudo code
- Langsung generate full code
- Semua import benar
- Tidak boleh duplicate class
- Tidak boleh error
- UI modern premium
- Semua page bisa dinavigasi
```
