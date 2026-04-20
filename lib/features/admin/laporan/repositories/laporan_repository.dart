import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/laporan_model.dart';

class LaporanRepository {
  final _supabase = Supabase.instance.client;
  Future<List<LaporanBulananModel>> getLaporanBulanan({
    required int  tahun,
    int?          bulan,
  }) async {
    var query = _supabase
        .from(SupabaseTable.vLaporanPenjualanBulanan)
        .select()
        .eq('tahun', tahun);

    if (bulan != null) {
      query = query.eq('bulan', bulan);
    }

    final response = await query.order('bulan');

    return (response as List)
        .map((json) => LaporanBulananModel.fromJson(json))
        .toList();
  }

  Future<List<int>> getTahunTersedia() async {
    final response = await _supabase
        .from(SupabaseTable.vLaporanPenjualanBulanan)
        .select('tahun')
        .order('tahun', ascending: false);

    final Set<int> unique = {};
    for (final row in response as List) {
      unique.add((row['tahun'] as num).toInt());
    }

    if (unique.isEmpty) return [DateTime.now().year];
    return unique.toList();
  }

  Future<List<MerekTerlaris>> getMerekTerlaris({
    required int tahun,
    int? bulan,
  }) async {
    final awal = bulan != null
        ? DateTime(tahun, bulan, 1)
        : DateTime(tahun, 1, 1);

    final akhir = bulan != null
        ? DateTime(tahun, bulan + 1, 0)
        : DateTime(tahun, 12, 31);

    final awalStr =
        '${awal.year}-${awal.month.toString().padLeft(2, '0')}-${awal.day.toString().padLeft(2, '0')}';

    final akhirStr =
        '${akhir.year}-${akhir.month.toString().padLeft(2, '0')}-${akhir.day.toString().padLeft(2, '0')}';

    final response = await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .select('tanggal_transaksi, mobil!inner(merek)')
        .gte('tanggal_transaksi', awalStr)
        .lte('tanggal_transaksi', akhirStr);

    final Map<String, int> counter = {};
    for (final row in response as List) {
      final mobil = row['mobil'] as Map<String, dynamic>?;
      final merek = mobil?['merek'] as String? ?? 'Lainnya';
      counter[merek] = (counter[merek] ?? 0) + 1;
    }

    final sorted = counter.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(6)
        .map((e) => MerekTerlaris(merek: e.key, jumlah: e.value))
        .toList();
  }
}