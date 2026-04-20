# ALIF BERKAH SHOWROOM | C5 - SISTEM INFORMASI '24

# 🚗 Showroom Mobil App

Aplikasi manajemen showroom mobil berbasis mobile yang dibangun dengan **Flutter** dan **Supabase**. Aplikasi ini memungkinkan calon pembeli untuk melihat katalog mobil secara publik, seller untuk mengajukan mobil yang ingin dijual, dan admin untuk mengelola seluruh operasional showroom — mulai dari inventori mobil, pengajuan seller, transaksi penjualan, hingga laporan keuangan.

Proyek ini dibuat sebagai **Tugas Akhir Mata Kuliah Pemrograman Aplikasi Bergerak**.

---

## 🛠️ Teknologi yang Digunakan

| Teknologi | Keterangan |
|---|---|
| **Flutter** | Framework utama pengembangan aplikasi mobile |
| **Supabase** | Backend as a Service — database, auth, dan storage |
| **GetX** | State management, navigasi, dan dependency injection |
| **PostgreSQL** | Database relasional melalui Supabase |
| **Row Level Security** | Keamanan data berbasis role di level database |

---

## 👥 Role Pengguna

Aplikasi memiliki tiga role pengguna dengan hak akses yang berbeda:

| Role | Akses | Cara Masuk |
|---|---|---|
| **Guest** | Melihat katalog mobil, info kredit, kontak showroom | Tidak perlu login |
| **Seller** | Mengajukan mobil untuk dijual, melihat riwayat pengajuan | Register dari aplikasi |
| **Admin** | Mengelola seluruh fitur aplikasi | Akun dibuat manual di Supabase |

---

## ✨ Fitur Aplikasi

### 🌐 Guest (Tanpa Login)

- **Katalog Mobil** — Melihat daftar mobil tersedia dengan foto, merek, harga, dan spesifikasi lengkap
- **Detail Mobil** — Melihat informasi lengkap setiap unit termasuk tahun, transmisi, bahan bakar, jarak tempuh, warna, dan status STNK
- **Pencarian & Filter** — Mencari mobil berdasarkan merek atau tipe/model, serta memfilter berdasarkan rentang tahun dan harga
- **Info Pengajuan Kredit** — Menampilkan informasi kredit dalam halaman gambar yang bisa di-zoom dan di-scroll
- **Tombol WhatsApp** — Menghubungi showroom langsung dengan template pesan otomatis
- **Tombol Google Maps** — Membuka lokasi showroom di Google Maps
- **Login & Register** — Akses halaman masuk (admin & seller) dan pendaftaran (seller)

### 🧑‍💼 Seller (Setelah Login)

- **Dashboard Seller** — Ringkasan pengajuan: total, per status, dan pengajuan terbaru
- **Ajukan Mobil** — Form lengkap untuk mengajukan unit mobil ke showroom dengan upload foto
- **Riwayat Pengajuan** — Melihat semua pengajuan dengan filter status dan statistik ringkasan
- **Detail Pengajuan** — Informasi lengkap pengajuan beserta catatan dan keputusan dari admin
- **Profil Seller** — Melihat dan mengedit data diri termasuk foto profil
- **Tombol WhatsApp** — Menghubungi admin showroom dengan template pesan khusus seller
- **Logout** — Keluar dari akun dan kembali ke halaman guest

### 🔧 Admin (Setelah Login)

- **Dashboard Admin** — Ringkasan data showroom: total mobil, mobil tersedia/terjual, total transaksi, total profit, dan daftar transaksi terbaru
- **Kelola Mobil** — CRUD lengkap unit mobil showroom dengan upload foto dan filter status
- **Kelola Pengajuan Seller** — Melihat semua pengajuan, memperbarui status (menunggu / diproses / diterima / ditolak), dan memberikan catatan admin
- **Transaksi Penjualan** — Mencatat transaksi dengan pilih mobil tersedia, input data pembeli, rincian harga, hitung profit otomatis, dan upload nota
- **Laporan Penjualan** — Laporan visual dengan bar chart merek terlaris, line chart tren profit, filter tahun & bulan, tabel detail bulanan, dan export ke Excel
- **Logout** — Keluar dari akun dan kembali ke halaman guest

---

## 🧩 Widget yang Digunakan

### Widget Bawaan Flutter

| Widget | Penggunaan |
|---|---|
| `Scaffold` | Kerangka dasar setiap halaman |
| `AppBar` | Header halaman dengan judul dan aksi |
| `SliverAppBar` | App bar yang bisa expand dan collapse (dashboard, detail mobil) |
| `CustomScrollView` | Scroll area dengan sliver untuk layout kompleks |
| `ListView.builder` | Daftar item yang di-render secara lazy (katalog, riwayat, transaksi) |
| `GridView.count` | Layout grid untuk stat card dan shortcut menu di dashboard |
| `IndexedStack` | Mempertahankan state tab saat pindah di bottom navigation |
| `BottomNavigationBar` | Navigasi tab untuk role admin dan seller |
| `Card` | Kontainer item dengan elevasi (card mobil, card pengajuan, card transaksi) |
| `InkWell` | Area tap dengan efek ripple di dalam card |
| `Form` + `GlobalKey<FormState>` | Manajemen form dan validasi di seluruh halaman input |
| `TextFormField` | Input teks dengan validator terintegrasi |
| `DropdownButtonFormField` | Dropdown untuk pilihan enum (transmisi, bahan bakar, status, dll.) |
| `ElevatedButton` | Tombol aksi utama (simpan, kirim, login) |
| `TextButton` | Tombol sekunder (batal, lihat semua, reset filter) |
| `OutlinedButton` | Tombol outlined (reset filter, logout) |
| `FloatingActionButton.extended` | Tombol tambah data di halaman daftar |
| `AlertDialog` | Dialog konfirmasi untuk aksi penting (simpan, hapus, logout) |
| `BottomSheet` | Sheet pilihan sumber foto (kamera atau galeri) |
| `SnackBar` | Notifikasi sukses atau gagal setelah aksi |
| `CircularProgressIndicator` | Indikator loading bulat |
| `LinearProgressIndicator` | Progress bar kapasitas stok di dashboard admin |
| `RefreshIndicator` | Pull-to-refresh di halaman daftar |
| `SingleChildScrollView` | Scroll untuk halaman form panjang |
| `Stack` | Overlay elemen (tombol hapus foto di atas preview, overlay di banner kredit) |
| `AnimatedContainer` | Animasi perubahan ukuran/warna chip filter status |
| `ClipRRect` | Memotong gambar dengan border radius |
| `InteractiveViewer` | Zoom dan pan untuk gambar kredit info |
| `FlexibleSpaceBar` | Konten fleksibel di dalam SliverAppBar |
| `Badge` | Indikator jumlah pengajuan menunggu di tab navigasi |
| `DatePicker` (showDatePicker) | Pemilih tanggal transaksi |
| `Wrap` | Layout chip yang membungkus otomatis (pilih status pengajuan) |

### Widget dari Package Eksternal

| Widget / Class | Package | Penggunaan |
|---|---|---|
| `CachedNetworkImage` | `cached_network_image` | Menampilkan foto mobil dan profil dari URL dengan cache |
| `BarChart` | `fl_chart` | Grafik batang merek mobil terlaris di laporan |
| `LineChart` | `fl_chart` | Grafik garis tren profit bulanan di laporan |
| `ImagePicker` | `image_picker` | Mengambil foto dari kamera atau galeri |
| `FilePicker` | `file_picker` | Memilih file nota transaksi (PDF/gambar) |
| `Excel` | `excel` | Membuat file laporan `.xlsx` untuk export |
| `SharePlus` | `share_plus` | Berbagi file Excel laporan ke aplikasi lain |
| `Obx` | `get` | Widget reaktif GetX yang rebuild saat state berubah |
| `GetMaterialApp` | `get` | Root aplikasi dengan routing dan theme GetX |

### Widget Kustom yang Dibuat

| Widget | Lokasi | Fungsi |
|---|---|---|
| `DashboardStatCard` | `admin/dashboard/widgets/` | Card statistik angka di dashboard admin |
| `ShortcutMenuItem` | `admin/dashboard/widgets/` | Item menu shortcut dengan badge notifikasi |
| `LaporanSummaryCard` | `admin/laporan/widgets/` | Card ringkasan angka di halaman laporan |
| `BarChartMerek` | `admin/laporan/widgets/` | Widget chart batang merek terlaris |
| `LineChartProfit` | `admin/laporan/widgets/` | Widget chart garis tren profit |
| `MobilAdminCard` | `admin/mobil/widgets/` | Card mobil di halaman kelola mobil admin |
| `PengajuanAdminTile` | `admin/pengajuan/widgets/` | Tile pengajuan di daftar kelola pengajuan |
| `TransaksiTile` | `admin/transaksi/widgets/` | Tile transaksi di daftar transaksi penjualan |
| `PengajuanSellerTile` | `seller/pengajuan/widgets/` | Tile pengajuan di riwayat pengajuan seller |
| `AuthHeader` | `auth/views/widgets/` | Header visual halaman login dan register |
| `PasswordField` | `auth/views/widgets/` | TextField password dengan toggle show/hide |
| `StatusBadge` | `shared/widgets/` | Badge berwarna untuk status mobil dan pengajuan |
| `ConfirmDialog` | `shared/widgets/` | Dialog konfirmasi reusable dengan dua tombol |

---

## 🗄️ Struktur Database (Supabase)

| Tabel / View | Keterangan |
|---|---|
| `profil_pengguna` | Data profil user (admin & seller) |
| `mobil` | Inventori unit mobil showroom |
| `pengajuan_mobil` | Pengajuan penjualan dari seller |
| `transaksi_penjualan` | Catatan transaksi penjualan |
| `v_ringkasan_dashboard_admin` | View agregat untuk dashboard admin |
| `v_laporan_penjualan_bulanan` | View laporan penjualan per bulan |

### Storage Bucket

| Bucket | Isi | Akses |
|---|---|---|
| `foto-mobil` | Foto unit mobil showroom dan foto pengajuan seller | Public |
| `nota-transaksi` | File nota / bukti transaksi penjualan | Private |
| `foto-profil` | Foto profil seller | Private |

---

## 📦 Daftar Package

```yaml
dependencies:
  supabase_flutter: ^2.x.x      # Backend Supabase
  flutter_dotenv: ^5.x.x        # Environment variable
  get: ^4.x.x                   # State management & navigasi
  cached_network_image: ^3.x.x  # Cache gambar dari URL
  fl_chart: ^0.x.x              # Chart laporan
  image_picker: ^1.x.x          # Ambil foto dari device
  file_picker: ^8.x.x           # Pilih file nota
  url_launcher: ^6.x.x          # Buka WhatsApp & Google Maps
  intl: ^0.x.x                  # Format tanggal & mata uang
  excel: ^4.x.x                 # Export laporan ke .xlsx
  path_provider: ^2.x.x         # Path direktori temporary
  share_plus: ^10.x.x           # Share file Excel
  flutter_svg: ^2.x.x           # Asset SVG
  lottie: ^3.x.x                # Animasi Lottie
  connectivity_plus: ^6.x.x     # Cek koneksi internet
  carousel_slider: ^5.x.x       # Carousel / slider

dev_dependencies:
  flutter_launcher_icons: ^0.x.x  # Icon aplikasi
  flutter_lints: ^5.x.x           # Linting
```

---

## 📁 Struktur Folder
<img width="392" height="565" alt="image" src="https://github.com/user-attachments/assets/98607989-ed87-47df-ad8e-12981535ba35" />

---

## 🔒 Keamanan

- Semua API key dan konfigurasi sensitif disimpan di file `.env` menggunakan package `flutter_dotenv`
- Tidak ada hardcode secret key di source code
- Supabase Row Level Security (RLS) aktif di semua tabel
- Seller hanya bisa mengakses data miliknya sendiri
- Admin memiliki akses penuh melalui helper function `is_admin()`
- Guest hanya bisa membaca data mobil dengan status `tersedia`
- Upload file dibatasi berdasarkan role melalui Storage policy

---

Proyek ini dibuat untuk keperluan akademik — Tugas Akhir Praktikum Pemrograman Aplikasi Bergerak.

---

## 👨‍💻 Pembuat

**Kelompok C5**  
Sistem Informasi C'24 — Universitas Mulawarman
