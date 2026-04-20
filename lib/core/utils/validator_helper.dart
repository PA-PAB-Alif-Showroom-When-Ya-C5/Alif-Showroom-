import 'package:showroom_mobil/core/constants/app_constants.dart';
class ValidatorHelper {
  ValidatorHelper._();

// ── Auth ──
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }
    return null;
  }
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < AppConstants.minPanjangPassword) {
      return 'Password minimal ${AppConstants.minPanjangPassword} karakter';
    }
    return null;
  }
  static String? konfirmasiPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

// ── Profil ──
  static String? namaLengkap(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (value.trim().length > 50) {
      return 'Nama terlalu panjang (maks. 50 karakter)';
    }
    final namaRegex = RegExp(r"^[a-zA-Z\s'.\-]+$");
    if (!namaRegex.hasMatch(value.trim())) {
      return 'Nama hanya boleh mengandung huruf dan spasi';
    }
    return null;
  }
  static String? nomorWhatsapp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < AppConstants.minNomorWaDigit ||
        digits.length > AppConstants.maxNomorWaDigit) {
      return 'Nomor WhatsApp harus ${AppConstants.minNomorWaDigit}–${AppConstants.maxNomorWaDigit} digit';
    }
    if (!digits.startsWith('08') && !digits.startsWith('628')) {
      return 'Nomor WhatsApp harus diawali 08 atau 628';
    }
    return null;
  }
  static String? alamatLengkap(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat wajib diisi';
    }
    if (value.trim().length < 10) {
      return 'Alamat terlalu singkat (min. 10 karakter)';
    }
    return null;
  }

// ── Mobil ──
  static String? merekMobil(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Merek wajib diisi';
    }
    if (value.trim().length < AppConstants.minPanjangNamaMobil) {
      return 'Merek minimal ${AppConstants.minPanjangNamaMobil} karakter';
    }
    return null;
  }
  static String? tipeModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tipe/model wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Tipe/model minimal 3 karakter';
    }
    return null;
  }
  static String? tahunMobil(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tahun wajib diisi';
    }
    final tahun = int.tryParse(value.trim());
    if (tahun == null) {
      return 'Tahun harus berupa angka';
    }
    if (tahun < AppConstants.minTahunMobil ||
        tahun > AppConstants.maxTahunMobilForm) {
      return 'Tahun harus antara ${AppConstants.minTahunMobil} – '
          '${AppConstants.maxTahunMobilForm}';
    }
    return null;
  }
  static String? hargaMobil(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka   = double.tryParse(cleaned);
    if (angka == null) {
      return 'Harga harus berupa angka';
    }
    if (angka < AppConstants.minHargaMobil) {
      return 'Harga minimal Rp ${_formatAngka(AppConstants.minHargaMobil)}';
    }
    if (angka > AppConstants.maxHargaMobil) {
      return 'Harga maksimal Rp ${_formatAngka(AppConstants.maxHargaMobil)}';
    }
    return null;
  }
  static String? hargaPengajuan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka = double.tryParse(cleaned);
    if (angka == null) {
      return 'Harga harus berupa angka';
    }
    if (angka < AppConstants.minHargaPengajuan) {
      return 'Harga minimal Rp ${_formatAngka(AppConstants.minHargaPengajuan)}';
    }
    return null;
  }
  static String? jarakTempuh(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jarak tempuh wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka = int.tryParse(cleaned);
    if (angka == null) {
      return 'Jarak tempuh harus berupa angka';
    }
    if (angka <= 10000) {
      return 'Jarak Tempuh Min. 10.000 km';
    }
    if (angka >= 300000) {
      return 'Jarak Tempuh Max. 300.000 km';
    }
    return null;
  }

  static String? warna(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Warna wajib diisi';
    }
    return null;
  }

  static String? deskripsi(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'Deskripsi wajib diisi';
    }
    if (value != null &&
        value.trim().isNotEmpty &&
        value.trim().length < AppConstants.minPanjangDeskripsi) {
      return 'Deskripsi minimal ${AppConstants.minPanjangDeskripsi} karakter';
    }
    return null;
  }
  static String? textRequiredNoEmoji(String? value, {String fieldName = 'Field'}) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName wajib diisi';
    }

    final validPattern = RegExp(r'^[a-zA-Z0-9\s.,/&()\-]+$');
    if (!validPattern.hasMatch(text)) {
      return '$fieldName tidak boleh mengandung emoji atau karakter tidak valid';
    }

    return null;
  }

  // ── Transaksi ──
    static String? namaPembeli(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Nama pembeli wajib diisi';
      }
      if (value.trim().length < 3) {
        return 'Nama pembeli minimal 3 karakter';
      }
      return null;
    }
    static String? nomorPembeli(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Nomor HP pembeli wajib diisi';
      }
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length < 10 || digits.length > 15) {
        return 'Nomor HP tidak valid (10–15 digit)';
      }
      return null;
    }
  static String? hargaModal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga modal wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka = double.tryParse(cleaned);
    if (angka == null || angka <= 0) {
      return 'Harga modal tidak valid';
    }
    if (angka < 80000000) {
      return 'Harga modal minimal Rp 80.000.000';
    }
    if (angka > 1000000000) {
      return 'Harga modal maksimal Rp 1.000.000.000';
    }
    return null;
  }
  static String? hargaJual(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga jual wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka = double.tryParse(cleaned);
    if (angka == null || angka <= 0) {
      return 'Harga jual tidak valid';
    }
    if (angka < 80000000) {
      return 'Harga jual minimal Rp 80.000.000';
    }
    if (angka > 1000000000) {
      return 'Harga jual maksimal Rp 1.000.000.000';
    }
    return null;
  }
  static String? hargaDeal(String? value, {required double hargaModal}) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga deal wajib diisi';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final angka = double.tryParse(cleaned);
    if (angka == null || angka <= 0) {
      return 'Harga deal tidak valid';
    }
    if (angka < 80000000) {
      return 'Harga deal minimal Rp 80.000.000';
    }
    if (angka > 1000000000) {
      return 'Harga deal maksimal Rp 1.000.000.000';
    }
    if (angka < hargaModal) {
      return 'Harga deal tidak boleh lebih kecil dari harga modal';
    }
    return null;
  }

// ── Generic ──
  static String? wajibDiisi(String? value, {required String labelField}) {
    if (value == null || value.trim().isEmpty) {
      return '$labelField wajib diisi';
    }
    return null;
  }

  static String _formatAngka(double angka) {
    return angka.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}