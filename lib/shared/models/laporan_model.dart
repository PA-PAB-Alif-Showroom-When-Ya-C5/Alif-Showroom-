class LaporanBulananModel {
  final int    tahun;
  final int    bulan;
  final int    jumlahTransaksi;
  final int    jumlahMobilTerjual;
  final double totalPenjualan;
  final double totalProfit;

  const LaporanBulananModel({
    required this.tahun,
    required this.bulan,
    required this.jumlahTransaksi,
    required this.jumlahMobilTerjual,
    required this.totalPenjualan,
    required this.totalProfit,
  });

  factory LaporanBulananModel.fromJson(Map<String, dynamic> json) {
    return LaporanBulananModel(
      tahun:              (json['tahun']                as num).toInt(),
      bulan:              (json['bulan']                as num).toInt(),
      jumlahTransaksi:    (json['jumlah_transaksi']     as num).toInt(),
      jumlahMobilTerjual: (json['jumlah_mobil_terjual'] as num).toInt(),
      totalPenjualan:     (json['total_penjualan']      as num).toDouble(),
      totalProfit:        (json['total_profit']         as num).toDouble(),
    );
  }

  /// Nama bulan singkat untuk label chart
  String get namaBulan {
    const bulanList = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return bulan >= 1 && bulan <= 12 ? bulanList[bulan] : '$bulan';
  }
}

/// Model agregat merek terlaris dari tabel transaksi_penjualan + mobil
class MerekTerlaris {
  final String merek;
  final int    jumlah;

  const MerekTerlaris({required this.merek, required this.jumlah});

  factory MerekTerlaris.fromJson(Map<String, dynamic> json) {
    return MerekTerlaris(
      merek:  json['merek']  as String,
      jumlah: (json['jumlah'] as num).toInt(),
    );
  }
}