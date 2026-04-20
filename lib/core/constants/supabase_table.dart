class SupabaseTable {
  SupabaseTable._();
  // ── Tabel Utama ──
  static const String profilPengguna    = 'profil_pengguna';
  static const String mobil             = 'mobil';
  static const String pengajuanMobil    = 'pengajuan_mobil';
  static const String transaksiPenjualan = 'transaksi_penjualan';

  // ── View ──
  static const String vRingkasanDashboardAdmin  = 'v_ringkasan_dashboard_admin';
  static const String vLaporanPenjualanBulanan  = 'v_laporan_penjualan_bulanan';
}

class SupabaseBucket {
  SupabaseBucket._();

  static const String fotoMobil      = 'foto-mobil';
  static const String notaTransaksi  = 'nota-transaksi';
  static const String fotoProfil     = 'foto-profil';
}

class SupabaseColumn {
  SupabaseColumn._();

  // ── Profil Pengguna ──
  static const String id             = 'id';
  static const String namaLengkap    = 'nama_lengkap';
  static const String email          = 'email';
  static const String nomorWhatsapp  = 'nomor_whatsapp';
  static const String alamatLengkap  = 'alamat_lengkap';
  static const String fotoProfil     = 'foto_profil';
  static const String role           = 'role';

  // ── Mobil ──
  static const String merek          = 'merek';
  static const String tipeModel      = 'tipe_model';
  static const String tahun          = 'tahun';
  static const String transmisi      = 'transmisi';
  static const String harga          = 'harga';
  static const String jarakTempuh    = 'jarak_tempuh';
  static const String bahanBakar     = 'bahan_bakar';
  static const String warna          = 'warna';
  static const String statusStnk     = 'status_stnk';
  static const String deskripsi      = 'deskripsi';
  static const String statusMobil    = 'status_mobil';
  static const String fotoMobil      = 'foto_mobil';
  static const String dibuatOleh     = 'dibuat_oleh';
  static const String dibuatPada     = 'dibuat_pada';
  static const String diupdatePada   = 'diupdate_pada';

  // ── Pengajuan Mobil ──
  static const String sellerId           = 'seller_id';
  static const String hargaDiinginkan    = 'harga_diinginkan';
  static const String deskripsiKondisi   = 'deskripsi_kondisi';
  static const String statusPengajuan    = 'status_pengajuan';
  static const String catatanAdmin       = 'catatan_admin';

  // ── Transaksi Penjualan ──
  static const String mobilId        = 'mobil_id';
  static const String namaPembeli    = 'nama_pembeli';
  static const String nomorPembeli   = 'nomor_pembeli';
  static const String hargaModal     = 'harga_modal';
  static const String hargaJual      = 'harga_jual';
  static const String hargaDeal      = 'harga_deal';
  static const String profit         = 'profit';
  static const String notaTransaksi  = 'nota_transaksi';
  static const String tanggalTransaksi = 'tanggal_transaksi';
}