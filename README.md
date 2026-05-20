# Clevora: AI-Powered Proctored Educational Platform

Clevora adalah platform pendidikan digital pintar yang dirancang khusus untuk memfasilitasi guru dalam menyusun perangkat pembelajaran (Modul, Materi, ATP, dan Kuis) secara otomatis berbasis kecerdasan buatan (Generative AI) serta mengujinya kepada siswa secara aman dengan sistem pengawasan ujian digital (*intelligent proctoring system*).

---

## 📁 Struktur Folder Project

Aplikasi Clevora terbagi secara terpisah menjadi **Frontend (Flutter)** dan **Backend (Express)**.

### 1. Frontend Directory Layout (`c:\clevora`)
```
lib/
├── app/
│   ├── data/
│   │   ├── models/           # Mapping JSON Response dari API ke Objek Dart
│   │   │   ├── module_model.dart
│   │   │   ├── question_model.dart
│   │   │   ├── quiz_model.dart
│   │   │   └── user_model.dart
│   │   ├── providers/        # Konfigurasi Http Client (Dio) & Base URL
│   │   │   └── api_provider.dart
│   │   └── services/         # Penghubung langsung Flutter ke endpoint REST API
│   │       ├── auth_service.dart
│   │       ├── module_service.dart
│   │       └── quiz_service.dart
│   ├── modules/              # Modul fitur berbasis GetX (View - Controller - Binding)
│   │   ├── auth/             # Modul Login & Register
│   │   ├── student/          # Fitur Siswa (Daftar Kuis, Ujian Proctoring, Hasil)
│   │   │   ├── student_exam/
│   │   │   │   ├── controllers/student_exam_controller.dart # Logika Sensor Peringatan
│   │   │   │   └── views/student_exam_view.dart             # UI Proctoring & Ujian
│   │   │   ├── student_quiz/
│   │   │   └── student_result/
│   │   └── teacher/          # Fitur Guru (Dashboard, AI Generate, Quiz Management)
│   │       ├── ai_generate/
│   │       │   ├── controllers/ai_result_controller.dart    # Parser Kuis Markdown AI
│   │       │   └── views/ai_result_view.dart                # Visualisasi Render Markdown
│   │       ├── dashboard/
│   │       └── quiz_management/
│   ├── routes/               # Manajemen Routing & Navigasi Halaman
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── theme/                # Palet Warna Utama (HSL Purple, Dark, Grey50)
│       └── app_theme.dart
└── main.dart                 # Entry point aplikasi Flutter & Inisialisasi Service Global
```

### 2. Backend Directory Layout (`c:\clevora-backend`)
```
src/
├── config/                   # Konfigurasi Koneksi Database (MongoDB Mongoose)
│   └── db.js
├── controllers/              # Logika Utama Handler Permintaan API
│   ├── aiController.js       # Komunikasi dengan Gemini API & Generator Prompts
│   ├── authController.js     # Otentikasi, JWT Sign-In, & Registrasi
│   ├── quizController.js     # CRUD Kuis & Auto-Grading (Penilaian Otomatis)
│   └── modulController.js
├── middleware/               # Keamanan (Auth Token Verification & Access Control)
│   ├── authMiddleware.js     # Verifikator signature JWT token
│   └── roleMiddleware.js     # Pembatas Hak Akses (Guru/Siswa)
├── models/                   # Definisi Skema Mongoose (MongoDB Collections)
│   ├── User.js
│   ├── Module.js
│   ├── Quiz.js
│   ├── Question.js
│   └── Result.js
├── routes/                   # Definisi Struktur Endpoint RESTful API
│   ├── auth.routes.js
│   ├── ai.routes.js
│   ├── kuis.routes.js
│   └── modul.routes.js
├── app.js                    # Inisialisasi Express, CORS, & Middleware Global
└── server.js                 # Entry point Server API Backend (Port 5000)
```

---


## 🚀 Cara Menjalankan Project

### 1. Menjalankan Backend API
1. Buka terminal di direktori backend:
   ```bash
   cd c:\clevora-backend
   ```
2. Pastikan file `.env` telah dikonfigurasi dengan benar:
   ```env
   PORT=5000
   MONGO_URI=mongodb+srv://... (Koneksi MongoDB Atlas Cloud)
   JWT_SECRET=... (Secret key token)
   GEMINI_API_KEY=... (API Key dari Google AI Studio)
   ```
3. Instal dependensi dan jalankan server dalam mode development:
   ```bash
   npm install
   npm run dev
   ```
4. Backend akan berjalan di: `http://localhost:5000`.

### 2. Menjalankan Frontend Flutter
1. Buka terminal baru di direktori frontend:
   ```bash
   cd c:\clevora
   ```
2. Pastikan emulator Android atau perangkat fisik telah terhubung.
3. Jalankan perintah instalasi paket dan jalankan aplikasi:
   ```bash
   flutter pub get
   flutter run
   ```
