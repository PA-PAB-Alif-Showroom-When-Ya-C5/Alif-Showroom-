abstract class AppRoutes {
  AppRoutes._();


  static const String splash    = '/splash';
  static const String login     = '/login';
  static const String register  = '/register';


  static const String guestHome   = '/';
  static const String katalog     = '/katalog';
  static const String detailMobil = '/katalog/detail';
  static const String kreditInfo  = '/kredit-info';


  static const String adminDashboard    = '/admin/dashboard';
  static const String kelolaMobil       = '/admin/mobil';
  static const String tambahMobil       = '/admin/mobil/tambah';
  static const String editMobil         = '/admin/mobil/edit';
  static const String formMobil         = '/admin/mobil/form';
  static const String detailMobilAdmin  = '/admin/mobil/detail';
  static const String transaksi         = '/admin/transaksi';
  static const String formTransaksi     = '/admin/transaksi/form';
  static const String detailTransaksi = '/admin/transaksi/detail';
  static const String laporan           = '/admin/laporan';
  static const String kelolaPengajuan   = '/admin/pengajuan';
  static const String detailPengajuanAdmin = '/admin/pengajuan/detail';


  static const String sellerDashboard      = '/seller/dashboard';
  static const String ajukanMobil          = '/seller/ajukan';
  static const String riwayatPengajuan     = '/seller/riwayat';
  static const String detailPengajuanSeller = '/seller/riwayat/detail';
  static const String profil               = '/seller/profil';
}