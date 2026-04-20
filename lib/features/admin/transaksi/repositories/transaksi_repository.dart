import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/shared/models/transaksi_model.dart';

class TransaksiRepository {
  final _supabase = Supabase.instance.client;

  // ── Ambil semua transaksi + join mobil ───────────────────
  Future<List<TransaksiModel>> getAll() async {
    final response = await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .select('*, mobil(*)')
        .order(SupabaseColumn.tanggalTransaksi, ascending: false);

    return (response as List)
        .map((json) => TransaksiModel.fromJson(json))
        .toList();
  }

  // ── Ambil mobil berstatus tersedia untuk dropdown ────────
  Future<List<MobilModel>> getMobilTersedia() async {
    final response = await _supabase
        .from(SupabaseTable.mobil)
        .select()
        .eq(SupabaseColumn.statusMobil, 'tersedia')
        .order(SupabaseColumn.merek);

    return (response as List)
        .map((json) => MobilModel.fromJson(json))
        .toList();
  }

  // ── Buat transaksi baru, return ID ───────────────────────
  // Trigger database otomatis:
  //   1. hitung profit (harga_deal - harga_modal)
  //   2. ubah status mobil → terjual
  Future<String> createTransaksi(TransaksiModel transaksi) async {
    final response = await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .insert(transaksi.toJsonInsert())
        .select(SupabaseColumn.id)
        .single();

    return response[SupabaseColumn.id] as String;
  }

  Future<void> deleteTransaksiDanKembalikanStatusMobil({
    required String transaksiId,
    required String mobilId,
  }) async {
    // 1. Hapus transaksi
    await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .delete()
        .eq(SupabaseColumn.id, transaksiId);

    // 2. Kembalikan status mobil jadi tersedia
    await _supabase
        .from(SupabaseTable.mobil)
        .update({
          SupabaseColumn.statusMobil: 'tersedia',
        })
        .eq(SupabaseColumn.id, mobilId);
  }

  // ── Update URL nota setelah upload ───────────────────────
  Future<void> updateNota({
    required String transaksiId,
    required String notaUrl,
  }) async {
    await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .update({SupabaseColumn.notaTransaksi: notaUrl})
        .eq(SupabaseColumn.id, transaksiId);
  }
}