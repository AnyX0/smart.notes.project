# Flutter Note – Dokumentasi Proyek

Aplikasi pencatatan sederhana berbasis Flutter yang terintegrasi dengan Firebase Authentication dan Cloud Firestore. Pengguna dapat membuat akun, masuk, menambahkan catatan, mengubah tampilan daftar (grid/list), mengedit atau menghapus catatan, serta mengubah mode tema (terang/gelap) melalui GetX sebagai state management.

## Fitur Utama
- Autentikasi email & password (Firebase Auth) dengan sesi reaktif melalui GetX.
- CRUD catatan tersinkronisasi real-time ke Cloud Firestore (per pengguna).
- Toggle tampilan list/grid untuk catatan dan pemilihan warna acak per kartu.
- Editor catatan dengan validasi konten kosong, serta dialog peringatan saat konten tidak berubah.
- Manajemen akun (tampilkan nama/email, logout) dan pengaturan mode tema (system/light/dark).

## Teknologi yang Digunakan
- Flutter SDK (Dart) untuk aplikasi lintas platform.
- GetX untuk state management, dependency injection, dan navigasi.
- Firebase Core untuk inisialisasi proyek Firebase.
- Firebase Auth untuk autentikasi email/password.
- Cloud Firestore untuk penyimpanan catatan per pengguna (koleksi `users/{uid}/notes`).
- Google Sign-In (sudah ada dependensi, belum diintegrasikan pada UI saat ini).
- flutter_staggered_grid_view untuk layout grid/list catatan dinamis.
- intl untuk formatting tanggal/waktu.
- uuid untuk pembuatan ID unik catatan.

## Arsitektur Singkat
- **Entry point**: [lib/main.dart](lib/main.dart) mem-bootstrapping Firebase, mendaftarkan controller GetX, dan menyiapkan tema.
- **Routing awal**: [lib/utils/root.dart](lib/utils/root.dart) memilih antara layar login atau beranda berdasarkan status `firebaseUser`.
- **State management**: GetX Controller
  - [lib/controllers/authController.dart](lib/controllers/authController.dart) untuk autentikasi dan preferensi tampilan (axisCount).
  - [lib/controllers/userController.dart](lib/controllers/userController.dart) menyimpan profil pengguna aktif.
  - [lib/controllers/noteController.dart](lib/controllers/noteController.dart) mengelola stream catatan per UID.
- **Layanan data**: [lib/services/database.dart](lib/services/database.dart) membungkus operasi Firestore (user profile dan koleksi `notes`).
- **Model**: [lib/models/user.dart](lib/models/user.dart) dan [lib/models/noteModel.dart](lib/models/noteModel.dart) sebagai representasi data Firestore.
- **UI**: layar autentikasi, home, detail catatan, pengaturan, serta komponen kecil (custom icon button, list tile, text field).

## Struktur Direktori (utama)
- lib/
  - controllers/ — GetX controller (auth, user, note)
  - models/ — Model data user & note
  - screens/
	 - auth/ — Login & Sign Up
	 - home/ — Home, add note, note list, show note
	 - settings/ — Setting, account, dark mode
	 - widgets/ — Komponen kecil (icon button)
  - services/ — Firestore wrapper
  - utils/ — Root router & tema

## Dependensi Penting
- get: navigasi + state management.
- firebase_core, firebase_auth: inisialisasi Firebase & autentikasi email/password.
- cloud_firestore: penyimpanan catatan per pengguna.
- google_sign_in: sudah terdaftar, belum digunakan pada UI saat ini.
- flutter_staggered_grid_view: layout grid/list dinamis untuk kartu catatan.
- intl: format tanggal pada tampilan catatan.
- uuid: pembangkit ID unik untuk dokumen catatan.

## Alur Fungsional Utama
- **Autentikasi**: Form login/sign-up dengan validasi dasar. Setelah sukses, data user diambil/ditulis ke koleksi `users` lalu disimpan di `UserController`.
- **Home & daftar catatan**: `NoteList` menampilkan Firestore stream dengan StaggeredGrid. Tombol toggle list/grid mengubah `axisCount` di `AuthController`.
- **Tambah catatan**: `AddNotePage` memvalidasi konten kosong, menyimpan ke Firestore dengan timestamp.
- **Lihat/Ubah/Hapus**: `ShowNote` memuat catatan terpilih, menampilkan tanggal/waktu, dapat update atau delete dengan dialog konfirmasi.
- **Pengaturan**: Mode tema (system/light/dark) via `Get.changeThemeMode`, layar akun menampilkan nama/email dan logout.

## Prasyarat
- Flutter SDK 3.x (minimal Dart SDK sesuai `pubspec`: >=2.17.0 <4.0.0)
- Android Studio / Xcode / VS Code + Flutter extension
- Akun Firebase dengan proyek yang sudah dikonfigurasi (iOS & Android)
- Java 17 (untuk Gradle modern), Android SDK & emulator/perangkat fisik

## Langkah Instalasi & Menjalankan
1) **Clone project**
	```bash
	git clone <repo-url>
	cd notes_project
	```
2) **Pasang dependensi**
	```bash
	flutter pub get
	```
3) **Konfigurasi Firebase**
	- Buat proyek di Firebase Console.
	- Aktifkan Authentication → Email/Password.
	- Aktifkan Cloud Firestore (mode production atau test sesuai kebutuhan).
	- Unduh `google-services.json` (Android) dan tempatkan di `android/app/` (sudah ada contoh di repo, ganti dengan milik Anda bila perlu).
	- Unduh `GoogleService-Info.plist` (iOS) dan tempatkan di `ios/Runner/` (sudah ada contoh, ganti bila perlu).
	- Sesuaikan `applicationId`/`bundleId` di `android/app/build.gradle.kts` dan `ios/Runner` jika berbeda dengan konfigurasi Firebase Anda.
4) **Jalankan aplikasi (dev)**
	```bash
	flutter run
	```
	Pilih device (emulator/perangkat fisik).
5) **Build release (opsional)**
	- Android: `flutter build apk --release`
	- iOS: `flutter build ios --release` (dari macOS dengan Xcode & provisioning siap).

## Konfigurasi Tambahan
- **Tema**: ubah skema warna di [lib/utils/theme.dart](lib/utils/theme.dart).
- **Struktur data Firestore**: ditangani di [lib/services/database.dart](lib/services/database.dart). Koleksi `users/{uid}/notes/{noteId}` menyimpan `title`, `body`, dan `creationDate`.
- **Routing awal**: logika pemilihan layar login/home ada di [lib/utils/root.dart](lib/utils/root.dart).
- **Validasi form**: lihat [lib/screens/auth/login.dart](lib/screens/auth/login.dart) dan [lib/screens/auth/signup.dart](lib/screens/auth/signup.dart).

## Pengujian
- Jalankan tes widget/unit (jika ditambahkan):
  ```bash
  flutter test
  ```

## Pemecahan Masalah Umum
- **Layar kosong setelah login**: pastikan `getUser` di Firestore mengembalikan dokumen untuk UID baru (fungsi sudah membuat dokumen baru jika tidak ada, lihat [lib/controllers/authController.dart](lib/controllers/authController.dart)).
- **Catatan tidak muncul**: pastikan user terautentik dan Firestore rules mengizinkan akses ke `users/{uid}/notes/*` untuk UID yang sama.
- **Build Android gagal**: periksa versi Java 17+, jalankan `flutter doctor`, dan pastikan `google-services.json` valid.

## Lisensi
Belum ditentukan. Tambahkan lisensi sesuai kebutuhan proyek.
