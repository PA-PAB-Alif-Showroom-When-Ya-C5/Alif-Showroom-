import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';

class MobilRepository {
  final _supabase = Supabase.instance.client;

  // ── Ambil semua mobil (admin lihat semua status) ─────────
  Future<List<MobilModel>> getAll() async {
    final response = await _supabase
        .from(SupabaseTable.mobil)
        .select()
        .order(SupabaseColumn.dibuatPada, ascending: false);

    return (response as List)
        .map((json) => MobilModel.fromJson(json))
        .toList();
  }

  // ── Tambah mobil baru, return ID ─────────────────────────
  Future<String> create(MobilModel mobil) async {
    final response = await _supabase
        .from(SupabaseTable.mobil)
        .insert(mobil.toJson())
        .select(SupabaseColumn.id)
        .single();

    return response[SupabaseColumn.id] as String;
  }

  // ── Update data mobil ────────────────────────────────────
  Future<void> update(String id, MobilModel mobil) async {
    await _supabase
        .from(SupabaseTable.mobil)
        .update(mobil.toJson())
        .eq(SupabaseColumn.id, id);
  }

  // ── Update URL foto mobil ────────────────────────────────
  Future<void> updateFoto(String id, String fotoUrl) async {
    await _supabase
        .from(SupabaseTable.mobil)
        .update({SupabaseColumn.fotoMobil: fotoUrl})
        .eq(SupabaseColumn.id, id);
  }

  // ── Hapus mobil ──────────────────────────────────────────
  // Hanya bisa hapus jika belum ada transaksi
  Future<void> delete(String id) async {
    // Cek apakah mobil sudah punya transaksi
    final transaksi = await _supabase
        .from(SupabaseTable.transaksiPenjualan)
        .select(SupabaseColumn.id)
        .eq(SupabaseColumn.mobilId, id)
        .maybeSingle();

    if (transaksi != null) {
      throw Exception(
        'Mobil ini tidak bisa dihapus karena sudah memiliki data transaksi.',
      );
    }

    await _supabase
        .from(SupabaseTable.mobil)
        .delete()
        .eq(SupabaseColumn.id, id);
  }
}