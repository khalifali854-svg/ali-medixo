# 📘 Ali Business Blueprint: B2C Strategy, Multi-Feature Ecosystem, Telemetry & Progress Tracking

Dokumen ini merangkum strategi bisnis B2C komprehensif untuk aplikasi **Ali**, mencakup seluruh ekosistem fitur (AAC, Visual Schedule, Choice Board, Belajar Menulis, Tebak Gambar/Speech Recognition, Dual-Canvas Art, dan Katalog Ensiklopedia), spesifikasi tiering & harga (Rp 99.000/bulan), batas tier gratis (10 kartu esensial), mekanisme autentikasi orang tua, alur onboarding ramah keluarga, serta **sistem evaluasi/pelacakan progres anak** yang objektif tanpa membuat anak tertekan.

---

## 1. Executive Summary & The Complete Ecosystem Vision

* **Nama Produk:** Ali (Pediatric Communication, Motor Learning & Behavioral Companion)
* **Target Utama:** Keluarga dengan anak *non-verbal*, *speech delay*, gangguan motorik halus (*fine motor delay*), dan spektrum autisme (*Autism Spectrum Disorder / ASD*).
* **Positioning:** **"All-in-One Behavioral, Communication & Learning Operating System at Home"**.
* **Keunikan Utama:**
  Aplikasi kompetitor global biasanya memecah fitur menjadi 4-5 aplikasi terpisah yang masing-masing berbayar ratusan dollar (Aplikasi AAC tersendiri, Tracing app tersendiri, Visual Schedule tersendiri). **Ali menyatukan seluruh kebutuhan terapi harian anak di bawah satu atap.**

---

## 2. Peta Lengkap Fitur Ali & Nilai Klinisnya

Ali memiliki **7 Portal Utama** di Home Hub:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            ALI HOME HUB ECOSYSTEM                           │
├──────────────────────────────┬──────────────────────────────┬───────────────┤
│ 1. Papan Bicara AAC          │ 2. Belajar Menulis           │ 3. Kanvas     │
│    (Komunikasi Suara & PECS) │    (Tracing Motorik Halus)   │    Menggambar │
├──────────────────────────────┼──────────────────────────────┼───────────────┤
│ 4. Tebak Gambar (AI STT)     │ 5. Jadwal Visual (Schedule)  │ 6. Choice     │
│    (Sebutkan Gambar / Speech)│    (First-Then & Rutinitas)  │    Board      │
├──────────────────────────────┴──────────────────────────────┴───────────────┤
│ 7. Katalog Kosa Kata Resmi (265+ Kosa Kata Foto Riil & Flashcard Audio)     │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Rincian Nilai Klinis Setiap Fitur:
1. **Papan Bicara AAC (Speech & Language Expression):**
   * Papan komunikasi bergambar riil dengan susunan kalimat (*I want... / Saya mau...*).
   * Suara asli keluarga (*Abi & Umma Voice*) atau AI anak ceria.
2. **Belajar Menulis & Tracing (Fine Motor & Pre-Writing):**
   * Latihan tracing titik-titik multi-level: Angka (1-9), Huruf Besar (A-Z), Huruf Kecil (a-z), dan Kata Pendek Kosa Kata AAC.
   * Fitur *Ali Menuliskan Kembali* (demonstrasi animasi stroke visual sebelum anak meniru).
3. **Dual-Canvas Menggambar (Art Therapy & Self-Expression):**
   * Kanvas gambar bebas distraksi, multi-touch, simpan karya seni anak ke cloud, dan **karya gambar anak bisa langsung dijadikan kartu AAC baru**.
4. **Tebak Gambar / Sebutkan Gambar (Speech Recognition & Articulation):**
   * Menguji bahasa reseptif dan ekspresif menggunakan Speech-to-Text (STT) real-time.
   * Anak melihat foto (misal: "Kucing") lalu mengucapkan suaranya ke mikrofon. AI mengevaluasi dan memberi pujian ramah tanpa hukuman (*zero punitive failure*).
5. **Jadwal Visual & Rutinitas (Sensory Meltdown Prevention):**
   * Format *First-Then* (Pertama - Lalu) dan Jadwal Rutinitas Harian (Pagi/Sekolah/Malam).
   * Mengurangi kecemasan transisi kegiatan secara drastis dengan indikator centang selesai.
6. **Choice Board (Self-Regulation & Decision Making):**
   * Mode 2 Pilihan (A vs B) dan Mode 4 Pilihan.
   * Mengajarkan anak membuat keputusan mandiri tanpa harus berteriak/menangis.
7. **Katalog Kosa Kata Resmi (Visual Vocabulary Encyclopedia):**
   * 265+ entri foto nyata terkurasi (Hewan, Buah & Makanan, Benda, Aksi, Kendaraan, Tubuh, Alam) dengan audio jernih dan bebas copyright.

---

## 3. Sistem Evaluasi & Pelacakan Progres Anak (Progress Tracking & Telemetry)

Bagi orang tua, alasan utama membayar langganan adalah **mengetahui apakah ada kemajuan nyata pada anak mereka**.

Untuk anak berkebutuhan khusus, evaluasi **tidak boleh berupa ujian formal yang menegangkan**. Ali menggunakan **Sistem Pelacakan Dua Arah**:

```
                       BAGAIMANA ORANG TUA MELIHAT PROGRESS?
                                        │
             ┌──────────────────────────┴──────────────────────────┐
             ▼                                                     ▼
1. Telemetri Pasif (Otomatis 100%)                  2. Game Kuis Interaktif (Aktif)
   (Background Analytics)                              (Tebak Gambar & Menulis)
   - Frekuensi komunikasi harian                       - Akurasi pengucapan kata (STT)
   - Kecepatan memilih di Choice Board                 - Kemampuan motorik tracing huruf
   - Kosa kata baru yang diucapkan                     - Sesi menebak gambar yang berhasil
```

### A. Metrik Telemetri Pasif (Otomatis Dicatat ke Supabase):
1. **Communication Volume:** Berapa kali anak menekan kartu AAC setiap minggu.
2. **Vocabulary Diversity:** Berapa banyak kartu unik yang digunakan anak (misal: dari 3 kartu dasar berkembang menjadi 15 kartu kebutuhan).
3. **Decision Latency (Kecepatan Memilih):** Waktu dari papan pilihan muncul hingga anak menekan kartu. Penurunan waktu dari 15 detik ke 3 detik menunjukkan koneksi kognitif yang semakin tajam.
4. **Routine Compliance:** Persentase tugas jadwal visual yang diselesaikan anak secara mandiri.

### B. Evaluasi Aktif Ramah Anak (Built-in via Game Tebak Gambar & Tracing):
1. **Artikulasi & Pengucapan (Tebak Gambar):**
   * Sistem mencatat kata apa saja yang berhasil diucapkan anak dengan jelas via Speech-to-Text.
   * Menampilkan daftar: *"Kata yang sudah dikuasai: Kucing, Susu, Bola, Apel"*.
2. **Perkembangan Motorik Halus (Belajar Menulis):**
   * Akurasi tracing garis stroke (apakah coretan anak semakin rapi mengikuti pola huruf).
3. **Laporan Mingguan untuk Orang Tua (Weekly Progress Summary):**
   * Dikirim via WhatsApp / Email / Dashboard Aplikasi:
   > *"Laporan Hebat Budi Minggu Ini:*
   > *🎉 Berhasil berkomunikasi 52 kali menggunakan kartu suara.*
   > *🗣️ Menyebutkan 8 kata baru dengan benar di sesi Tebak Gambar.*
   > *✏️ Menyelesaikan 5 latihan tracing huruf (A, B, C, D, E).*
   > *🌟 0 meltdown saat transisi jadwal mandi sore!"*

### C. Jembatan B2B Masa Depan: "Cetak Laporan untuk Terapis / Dokter"
* Orang tua dapat mengekspor **Laporan Perkembangan Bulanan (PDF 1 Lembar)** yang memuat data statistik objektif ini untuk dibawa ke sesi konsultasi dokter tumbuh kembang atau terapis wicara.

---

## 4. Business Model & Pricing Strategy (Strict B2C Focus)

Untuk menjamin ketersediaan server, storage media Cloudflare R2, dan neural speech engine, **tidak ada opsi Lifetime Access**. Model murni berbasis **Freemium Subscription**.

| Fitur / Modul | **Free Tier (Pondasi)** | **Ali Pro Tier (Rp 99.000 / Bulan)** |
| :--- | :--- | :--- |
| **Harga** | **Rp 0** (Selamanya) | **Rp 99.000 / bulan** (atau Rp 990.000 / tahun hemat 2 bulan) |
| **Papan Bicara AAC** | **Maksimal 10 Kartu Esensial** (Katalog Baku: Makan, Minum, Toilet, Sakit, Stop, Mau, Selesai, Senang, Istirahat, Peluk) | **Unlimited Kartu** (Akses 100+ kosa kata tambahan) |
| **Foto Kustom Pribadi** | Tidak tersedia (hanya kartu bawaan) | **Unlimited Upload Foto Asli** dari Kamera/Galeri HP (Botol anak, kamar, keluarga) |
| **Belajar Menulis** | Level 1 (Angka 1-9) | **Semua Level Terbuka** (Angka, Huruf Besar A-Z, Huruf Kecil a-z, Kata AAC) + Buat Kata Latihan Sendiri |
| **Tebak Gambar (Speech)** | Terbatas 1 Kategori (Maks. 5 tebakan/hari) | **Unlimited Sesi & Semua Kategori** (Hewan, Buah, Kendaraan, Tubuh, dll.) + Rekap Akurasi Suara |
| **Kanvas Menggambar** | Kanvas standar (1 slot penyimpanan lokal) | **Unlimited Cloud Storage Kanvas** + Simpan Langsung Jadi Kartu AAC |
| **Choice Board** | Terbatas Mode 2 Pilihan (A vs B) | **Mode 2 Pilihan & 4 Pilihan** + Akses Preset Situasi Khusus (Mall, Dokter, Restoran) |
| **Jadwal Visual** | 1 Rutinitas Harian (Maks. 4 langkah) | **Unlimited Rutinitas & Jadwal Mingguan** + Alarm Pengingat Suara |
| **Laporan Progres** | Ringkasan sederhana harian | **Full Weekly Progress Dashboard & Export PDF untuk Terapis** |
| **Multi-Device Sync** | 1 Perangkat | **Family Cloud Sync** (Tablet Anak ↔ HP Ibu ↔ HP Ayah ↔ Pengasuh) |

> [!IMPORTANT]
> **Prinsip Bebas Iklan:** Seluruh tier (baik Free maupun Pro) dijamin **100% Bebas Iklan**. Anak berkebutuhan khusus rentan mengalami kemunduran fokus dan sensory overload jika terpapar iklan digital.

---

## 5. Strategi Autentikasi (Authentication Engine)

Pengguna aplikasi terbagi menjadi dua entitas dalam satu perangkat:
1. **Orang Tua / Caregiver:** Mengelola akun, mengatur kartu, melihat laporan progres, dan membayar langganan.
2. **Anak:** Berinteraksi dengan game, menekan tombol bicara, menggambar, dan tracing.

### Metode Autentikasi:
* **Sign in with Google (Prioritas Utama Android/Web):** Cepat, satu ketukan, tanpa menghafal password.
* **Sign in with Apple (Prioritas iPad/iOS):** Wajib untuk ekosistem Apple yang sangat populer di kalangan terapi anak.
* **Passwordless Email Magic Link:** Tautan verifikasi instan via email.

### Keamanan: "Parental Gate"
* Akses ke menu **Pengaturan**, **Tagihan/Langganan**, **Tambah/Edit Kartu Kosa Kata**, dan **Laporan Evaluasi** diproteksi dengan tantangan kognitif dewasa (perhitungan matematika acak atau PIN 4 digit) agar anak tidak sengaja mengubah data penting.

---

## 6. Alur Onboarding (Parent & Child Onboarding Flow)

Tujuan onboarding: **Mencapai "Aha! Moment" dalam waktu < 90 detik tanpa formulir rumit.**

```
[Screen 1: Welcome & Emotional Hook]
              │
              ▼
[Screen 2: One-Tap Auth (Google / Apple)]
              │
              ▼
[Screen 3: Profil Cepat Anak (Nama Panggilan & Rentang Usia)]
              │
              ▼
[Screen 4: Baseline Check (3 Pertanyaan Singkat Perkembangan)]
              │
              ▼
[Screen 5: Interactive First Success (Coba Sentuh Kartu Bersuara)]
              │
              ▼
[Screen 6: Home Hub Terbuka (Siap Digunakan dengan 10 Kartu & Modul Dasar)]
```

### Rincian Tahapan:
1. **Welcome Screen:** Visual 3D bersahabat. Headline: *"Dampingi Anak Bicara, Menulis, dan Memilih dengan Percaya Diri."*
2. **One-Tap Auth:** Login via Google atau Apple.
3. **Profil Anak:** Nama panggilan (misal: "Budi") digunakan AI untuk menyapa dan menyebut kalimat audio: *"Budi mau Minum!"*.
4. **Baseline Check (1 Menit):** 3 pertanyaan singkat mengenai status bicara anak saat ini (Non-verbal / Meniru suara / Sudah beberapa kata) untuk menjadi titik tolak pengukuran progres.
5. **Interactive First Win:** Anak/orang tua diajak menyentuh satu kartu uji coba -> Audio jernih berbunyi disertai animasi konfeti.
6. **Dashboard Aktif:** Masuk ke Home Hub dengan modul lengkap yang disesuaikan.

---

## 7. Paywall Triggers & Strategi Konversi Pro (Rp 99.000/bln)

Paywall muncul secara elegan saat orang tua menyentuh batasan alami produk:
1. **Trigger Kuota Kartu (Kartu ke-11):** Saat orang tua mencoba menambah kosa kata di luar 10 kartu gratis.
2. **Trigger Foto Kamera Asli:** Saat menekan tombol ambil foto botol/kamar sendiri.
3. **Trigger Level Menulis Lanjutan:** Saat anak selesai angka 1-9 dan ingin lanjut ke Huruf A-Z.
4. **Trigger Unlimited Tebak Gambar:** Saat jatah harian tebak gambar selesai.
5. **Trigger Ekspor Laporan Terapis:** Saat orang tua ingin mencetak ringkasan kemajuan anak ke PDF.

---

## 8. Proyeksi Keuangan & Traksi Tahun ke-1

* **Model Bisnis:** Pure B2C Subscription @ Rp 99.000 / bulan.
* **Gross Margin:** > 80% (Infrastruktur server Supabase & Cloudflare R2 sangat efisien).

| Metrik | Bulan ke-3 | Bulan ke-6 | Bulan ke-12 |
| :--- | :--- | :--- | :--- |
| **Total Pengguna Aktif Gratis** | 3.000 | 10.000 | 25.000 |
| **Pelanggan Berbayar Pro (Konversi 5-6%)** | 150 | 500 | 1.300 |
| **MRR (Monthly Recurring Revenue)** | Rp 14.850.000 | Rp 49.500.000 | **Rp 128.700.000** |
| **ARR (Annualized Run Rate)** | Rp 178 Juta | Rp 594 Juta | **~Rp 1,54 Miliar** |

---

Dokumen ini menjadi acuan tunggal dalam pengembangan fitur, desain database telemetri, UX onboarding, serta monetisasi ekosistem lengkap aplikasi Ali.
