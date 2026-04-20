class AppConstants {
  AppConstants._();
  static const int defaultPageSize = 20;
  static const int recentTransactionLimit = 5;


  static const int minTahunMobil    = 2015;
  static const int    maxTahunMobilForm = 2026;
  static const double minHargaMobil = 80000000;
  static const double maxHargaMobil = 1000000000;
  static const double minHargaPengajuan = 50000000;
  static const int minPanjangDeskripsi  = 20;
  static const int minPanjangNamaMobil  = 3;
  static const int minNomorWaDigit      = 10;
  static const int maxNomorWaDigit      = 15;
  static const int minPanjangPassword   = 6;
  static const int maxPanjangPassword   = 25;


  static const double imageMaxWidth  = 800;
  static const double imageMaxHeight = 800;
  /// Kualitas kompresi gambar (0–100)
  static const int imageQuality = 75;

  
  static const Duration animationFast   = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow   = Duration(milliseconds: 500);
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // ── Splash Screen ──
  static const Duration splashDuration = Duration(seconds: 2);

  // ── Format ──
  static const String localeId        = 'id_ID';
  static const String currencySymbol  = 'Rp ';
  static const String dateFormat      = 'dd MMMM yyyy';
  static const String monthYearFormat = 'MMMM yyyy';
}