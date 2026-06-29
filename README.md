# 🕌 Al-Quran Indonesia

Aplikasi mobile Al-Qur'an dan Asisten Ibadah berbasis Flutter yang dirancang dengan antarmuka modern, intuitif, dan responsif. Aplikasi ini tidak hanya menyediakan teks Al-Qur'an dan terjemahannya, tetapi juga dilengkapi dengan fitur Tafsir, Audio Murottal (streaming), Pencarian Global, Bookmark, Jadwal Sholat regional dengan Notifikasi Adzan otomatis, serta Kompas Kiblat interaktif berbasis sensor perangkat.

---

## 🚀 Fitur Utama

Aplikasi ini dirancang dengan perhatian mendalam terhadap pengalaman pengguna (UX) dengan fitur-fitur premium berikut:

### 1. 📖 Pembacaan Al-Qur'an (Surat & Juz)
*   **Daftar Surat Lengkap:** Menyajikan 114 surat dengan detail nomor surat, nama Arab, transliterasi Latin, tempat turunnya surat (Makkiyah/Madaniyah), jumlah ayat, dan makna arti nama surat.
*   **Pengelompokan per Juz:** Memudahkan navigasi pembacaan berdasarkan Juz 1 hingga Juz 30.
*   **Pencarian Surat Cepat:** Menyediakan fitur pencarian cepat berdasarkan nama surat, nomor surat, maupun arti surat dengan metode pencarian toleransi substring (*flexible substring match*).

### 2. 🔊 Audio Murottal (Streaming)
*   **Pemutaran Per Surat & Per Ayat:** Pengguna dapat mendengarkan pembacaan murottal untuk satu surat penuh secara kontinu atau per ayat secara spesifik.
*   **Persistent Floating Player:** Pemutar audio terintegrasi secara global dan tetap melayang (*floating*) di bagian bawah layar meskipun pengguna berpindah halaman, memudahkan kontrol pemutaran (Play/Pause, Seek, Close).
*   **Sinkronisasi State:** Pemutaran audio per ayat akan menandai ayat yang sedang aktif diputar secara visual di dalam daftar.

### 3. 📖 Tafsir Al-Qur'an Lengkap
*   Menyediakan akses langsung ke penjelasan Tafsir untuk setiap surat dan ayat (bersumber dari Kementerian Agama RI melalui API).
*   Desain pembacaan tafsir yang nyaman dengan tata letak tipografi yang teratur.

### 4. 🔍 Pencarian Terjemahan Pintar (Global Search)
*   Memungkinkan pencarian kata kunci terjemahan (seperti "sabar", "shalat", "surga") di seluruh ayat Al-Qur'an.
*   Menampilkan hasil pencarian beserta teks Arab, Latin, terjemahan, nama surat, dan nomor ayat terkait secara instan dengan integrasi API global.

### 5. 📌 Bookmark & Terakhir Dibaca (Last Read)
*   **Penanda Terakhir Dibaca (Last Read Banner):** Menyimpan progres membaca terakhir secara otomatis (nomor surat, nama surat, dan ayat) yang langsung ditampilkan sebagai banner interaktif di halaman utama untuk melanjutkan pembacaan dalam satu kali ketuk.
*   **Penyimpanan Bookmark Ayat:** Menyimpan ayat-ayat favorit ke dalam daftar bookmark lokal dengan fitur hapus konfirmasi yang aman.

### 6. 🕌 Jadwal Sholat Regional Otomatis
*   **Pilihan Provinsi & Kabupaten/Kota:** Mengambil jadwal sholat secara *real-time* berdasarkan daerah yang dipilih dari daftar lengkap provinsi dan kabupaten/kota di Indonesia.
*   **Waktu Sholat Akurat:** Menampilkan waktu Imsak, Subuh, Terbit, Dhuha, Dzuhur, Ashar, Maghrib, dan Isya.
*   **Jadwal Sholat Harian:** Tampilan kartu jadwal sholat yang adaptif sesuai dengan waktu aktif saat ini.

### 7. 🔔 Notifikasi Adzan & Pengingat Waktu Sholat
*   **Kustomisasi Suara Adzan:** Pengguna dapat memilih suara pengingat, termasuk **Adzan Mekah (Masjidil Haram)**, **Adzan Madinah (Masjid Nabawi)**, **Adzan Pendek**, atau **Suara Bawaan Sistem HP (Default)**.
*   **Penjadwalan Offline Mandiri:** Menggunakan sistem *timezone* dan penjadwalan lokal untuk membunyikan alarm tepat waktu tanpa memerlukan koneksi internet aktif saat waktu sholat tiba.
*   **Kontrol Notifikasi Individu:** Opsi untuk mengaktifkan atau menonaktifkan alarm per waktu sholat secara mandiri (misal: hanya mengaktifkan adzan Subuh dan Maghrib).

### 8. 🧭 Kompas Kiblat Presisi (Qiblah Compass)
*   **Real-time Sensor Integration:** Menggunakan sensor kompas perangkat (`flutter_compass`) dan lokasi koordinat GPS pengguna (`geolocator`).
*   **Kalkulasi Bearing Dinamis:** Menghitung sudut arah kiblat secara matematis berdasarkan koordinat koordinat astronomi Ka'bah di Mekah (21.4225241° N, 39.8261818° E).
*   **Indikator Jarak:** Menghitung jarak garis lurus dari lokasi pengguna ke Ka'bah dalam satuan Kilometer (Km).
*   **Panduan Visual & Haptic:** Antarmuka kompas premium yang bergaya *glassmorphism* dengan animasi pendaran cahaya (*glow effect*) dan umpan balik getar ketika jarum kompas tepat mengarah ke kiblat.

### 9. ⚙️ Pengaturan & Kustomisasi
*   **Dukungan Mode Gelap (Dark Mode):** Tampilan adaptif otomatis dan manual dengan palet warna hijau gelap islami premium (*deep emerald green*).
*   **Ukuran Font Dinamis:** Penggeser (*slider*) ukuran teks Arab dan ukuran teks terjemahan yang dapat diubah sesuai tingkat kenyamanan mata pembaca.

---

## 🛠️ Tech Stack & Dependensi

Proyek ini dibangun menggunakan teknologi terbaru di ekosistem Flutter:

| Teknologi / Library | Versi | Kegunaan |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.6.1` | SDK Utama untuk pengembangan aplikasi multiplatform |
| **Dart SDK** | `^3.6.1` | Bahasa pemrograman utama |
| **http** | `^1.6.0` | Mengambil data Al-Qur'an, Tafsir, dan Jadwal Sholat dari API online |
| **audioplayers** | `^6.6.0` | Pemutar audio murottal latar belakang & streaming URL |
| **shared_preferences** | `^2.5.3` | Penyimpanan lokal persisten untuk pengaturan tema, bookmark, ukuran font, dan riwayat bacaan |
| **flutter_local_notifications** | `^17.2.4` | Sistem pemicu alarm adzan dan pemberitahuan waktu sholat |
| **timezone** | `^0.9.4` | Menangani konversi dan kalkulasi waktu berbasis zona waktu lokal untuk notifikasi adzan |
| **geolocator** | `^11.0.2` | Mendapatkan koordinat GPS terkini untuk perhitungan arah kiblat dan jarak ke Ka'bah |
| **flutter_compass** | `^0.8.0` | Membaca sensor magnetometer arah kompas perangkat |
| **permission_handler** | `^11.4.0` | Manajemen permohonan izin sistem (Lokasi, Notifikasi, dll.) secara dinamis |
| **google_fonts** | `^6.3.0` | Penyedia font sistem premium (menggunakan font *Poppins*) |

---

## 📂 Struktur Proyek

Aplikasi ini menggunakan pola arsitektur **Model-View-Controller (MVC)** yang bersih untuk memisahkan logika bisnis, model data, dan antarmuka pengguna:

```text
lib/
├── controllers/
│   ├── audio_controller.dart                  # Mengelola pemutar murottal & streaming audio
│   ├── bookmark_controller.dart               # Mengelola penyimpanan bookmark & riwayat terakhir dibaca
│   ├── notification_settings_controller.dart  # Mengelola pengaturan suara & aktifasi alarm adzan
│   ├── prayer_times_controller.dart           # Mengelola seleksi wilayah & penarikan jadwal sholat
│   ├── settings_controller.dart               # Mengelola kustomisasi tema & ukuran font
│   ├── surah_controller.dart                  # Mengelola daftar surat & fitur pencarian lokal
│   ├── surah_detail_controller.dart           # Mengelola pengambilan detail surat & ayat
│   └── tafsir_controller.dart                 # Mengelola pengambilan data tafsir
├── models/
│   └── surah.dart                             # Definisi model data Surah, Ayat, Detail, dan Tafsir
├── screens/
│   ├── splash_screen.dart                     # Halaman pembuka aplikasi (animasi logo)
│   ├── home_screen.dart                       # Halaman utama dengan navigasi tab & floating player
│   ├── detail_screen.dart                     # Halaman pembacaan ayat Al-Qur'an
│   ├── tafsir_screen.dart                     # Halaman pembacaan tafsir per surat/ayat
│   ├── search_screen.dart                     # Halaman pencarian terjemahan global
│   └── settings_screen.dart                   # Halaman konfigurasi tema, suara, dan teks
├── services/
│   ├── notification_service.dart              # Logika penjadwalan & inisialisasi alarm adzan lokal
│   ├── prayer_times_service.dart              # API Client untuk fetching wilayah & jadwal sholat
│   ├── quran_api_service.dart                 # API Client untuk membaca surat, detail, dan tafsir
│   └── search_service.dart                    # API Client untuk pencarian terjemahan global
├── widgets/
│   ├── ayah_card.dart                         # Tampilan kartu per ayat (teks Arab, Latin, terjemah, audio)
│   ├── bookmark_tab.dart                      # Panel daftar bookmark ayat tersimpan
│   ├── islamic_star_ornament.dart             # Hiasan bintang dekorasi nomor surat & ayat
│   ├── juz_tab.dart                           # Panel daftar ayat dikelompokkan berdasarkan Juz
│   ├── last_read_banner.dart                  # Banner navigasi riwayat bacaan terakhir
│   ├── persistent_audio_player.dart           # Bar pemutar audio murottal yang persisten di bawah layar
│   ├── qiblah_compass_tab.dart                # Panel kompas kiblat interaktif dengan visualisasi pendaran
│   ├── shimmer_loading.dart                   # Efek memuat data (skeleton loading animation)
│   ├── sholat_tab.dart                        # Panel jadwal sholat & selector lokasi kabupaten/kota
│   ├── surah_card.dart                        # Kartu item daftar surat di beranda
│   ├── surah_header_card.dart                 # Header informatif di halaman detail surat
│   ├── surat_tab.dart                         # Panel daftar surat 1 - 114
│   └── tafsir_card.dart                       # Kartu item konten tafsir per ayat
└── main.dart                                  # Titik masuk utama aplikasi (Initialization & Theme setup)
```

---

## 🌐 Integrasi API

Aplikasi ini menggunakan dua sumber API publik eksternal yang andal untuk menyajikan data secara dinamis:

1.  **API Utama (equran.id v2):**
    *   Endpoint: `https://equran.id/api/v2`
    *   Fungsi: Mengambil daftar surat, detail ayat beserta audio streaming murottal penuh, detail tafsir Kemenag, serta daftar wilayah provinsi/kabupaten/kota untuk jadwal sholat harian.
2.  **API Pencarian (Al-Quran Cloud):**
    *   Endpoint: `https://api.alquran.cloud/v1`
    *   Fungsi: Digunakan khusus pada fitur pencarian global untuk mencocokkan kata kunci terjemahan bahasa Indonesia (`id.indonesian`) di seluruh ayat Al-Qur'an.

---

## ⚙️ Cara Menjalankan Proyek Secara Lokal

### Prasyarat
*   Sudah menginstal **Flutter SDK** (versi Dart minimal `3.6.1`).
*   Sudah menginstal **Android Studio** (untuk simulator Android) atau **Xcode** (untuk simulator iOS).
*   Perangkat fisik atau emulator terhubung.

### Langkah-langkah
1.  **Clone repositori ini:**
    ```bash
    git clone https://github.com/username/quran_app.git
    cd quran_app
    ```
2.  **Ambil semua dependensi package:**
    ```bash
    flutter pub get
    ```
3.  **Jalankan aplikasi:**
    *   Melalui VS Code / Android Studio: Tekan tombol **F5** atau klik tombol **Run**.
    *   Melalui Command Line (Terminal):
        ```bash
        flutter run
        ```

---

## 📝 Lisensi
Proyek ini dibuat untuk keperluan pembelajaran dan penggunaan pribadi. Anda bebas mengembangkan kembali atau menyesuaikan fitur di dalamnya sesuai kebutuhan Anda.

*Aplikasi ini dikembangkan dengan dedikasi penuh untuk menghadirkan pembacaan Al-Qur'an dan kemudahan beribadah yang khusyuk langsung dalam genggaman Anda.*
