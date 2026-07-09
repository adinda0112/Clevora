# Clevora: AI-Powered Proctored Educational Platform

Clevora adalah platform pendidikan digital pintar yang dirancang khusus untuk memfasilitasi guru dalam menyusun perangkat pembelajaran (Modul, Materi, ATP, dan Kuis) secara otomatis berbasis kecerdasan buatan (Generative AI) serta mengujinya kepada siswa secara aman dengan sistem pengawasan ujian digital (*intelligent proctoring system*).

---

## 🌟 Fitur Utama

- **Otentikasi Aman**: Login & Register Multi-role (Guru / Siswa) + integrasi Google Sign-In.
- **Generative AI (Guru)**: Pembuatan materi ajar, modul, dan kuis secara otomatis menggunakan integrasi Gemini AI Studio.
- **Manajemen Kuis (Guru)**: Buat, edit, dan bagikan kuis ke kelas yang spesifik, serta pantau laporan nilai siswa.
- **Sistem Proctoring (Siswa)**: Ujian diawasi secara real-time via kamera untuk mendeteksi kecurangan.
- **Pendeteksi Wajah (Face Service)**: Pendaftaran wajah saat registrasi pertama kali dan verifikasi wajah saat pre-test/post-test.
- **Absensi Pintar**: Generate kode QR dan pindai untuk kehadiran berbasis lokasi (Geotagging + Socket.io realtime update).
- **Dashboard & Analisis**: Ringkasan data performa siswa, kehadiran, dan laporan lengkap.

---

## 🛠 Tech Stack

**Frontend:**
- **Framework:** Flutter (^3.11.4)
- **State Management & Routing:** GetX (^4.6.6)
- **Networking:** Dio (^5.4.0)
- **Storage:** GetStorage & Flutter Secure Storage
- **UI/UX:** Google Fonts, Flutter Animate

**Backend (API Repo Terpisah):**
- **Framework:** Express.js (Node.js)
- **Database:** MongoDB (Mongoose)
- **AI Integration:** Google Gemini API
- **Realtime:** Socket.io

---

## 📁 Struktur Folder Project (Frontend)

Proyek ini dibangun menggunakan **GetX Pattern** untuk memisahkan UI, Logic, dan Data Layer dengan bersih.

```
lib/
├── app/
│   ├── data/
│   │   ├── models/           # Mapping JSON Response dari API ke Objek Dart (UserModel, QuizModel, dll)
│   │   ├── providers/        # Konfigurasi Http Client (Dio interceptors & Base URL)
│   │   ├── repositories/     # Abstraksi endpoint spesifik (misal: AuthRepository)
│   │   ├── services/         # Global Services (AuthService, ModuleService, dll)
│   │   └── utils/            # Helper function (ValidationHelper)
│   ├── modules/              # Fitur aplikasi (GetX: View, Controller, Binding)
│   │   ├── auth/             # Modul Login, Register, Lengkapi Profil, Lupa Password
│   │   ├── shared/           # Modul untuk semua role (Profil, Video Player, Security Log)
│   │   ├── student/          # Modul Siswa (Belajar, Kuis, QR Scanner, Proctoring Ujian)
│   │   └── teacher/          # Modul Guru (Dashboard, AI Generate, Quiz Management, Absensi)
│   ├── routes/               # Manajemen Routing & Navigasi Halaman
│   │   ├── api.dart          # Base URL konfigurasi
│   │   ├── app_pages.dart    # Daftar GetPage
│   │   └── app_routes.dart   # Konstanta nama route
│   ├── theme/                # Palet Warna & Konfigurasi Google Fonts
│   └── widgets/              # Reusable UI Components (Button, Dialog, Bottom Nav)
└── main.dart                 # Entry point & Inisialisasi Dependensi Global
```

---

## 🚀 Cara Menjalankan Project

1. Buka terminal di direktori frontend:
   ```bash
   cd c:\clevora
   ```
2. Instal dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi (pastikan emulator / perangkat fisik terhubung):
   ```bash
   flutter run
   ```
