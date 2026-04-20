import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';

class DashboardRepository {
  final _supabase = Supabase.instance.client;

  // ── Ringkasan Dari View Supabase ──
  Future<Map<String, dynamic>> getRingkasan() async {
    final data = await _supabase
        .from(SupabaseTable.vRingkasanDashboardAdmin)
        .select()
        .single();
    return data;
  }

  // ── Jumlah Pengajuan Menunggu ──
  Future<int> getJumlahPengajuanMenunggu() async {
    final response = await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .select(SupabaseColumn.id)
        .eq(SupabaseColumn.statusPengajuan, 'menunggu');
    return (response as List).length;
  }

  // ── 5 transaksi terbaru ──
  Future<List<Map<String, dynamic>>> getTransaksiTerbaru() async {
    final response = await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .select('''
          id,
          nama_pembeli,
          harga_deal,
          profit,
          tanggal_transaksi,
          mobil ( merek, tipe_model )
        ''')
        .order(SupabaseColumn.tanggalTransaksi, ascending: false)
        .limit(5);
    return List<Map<String, dynamic>>.from(response);
  }
}