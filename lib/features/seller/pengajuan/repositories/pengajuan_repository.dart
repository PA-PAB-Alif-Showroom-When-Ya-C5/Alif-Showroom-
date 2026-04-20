import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';

class PengajuanRepository {
  final _supabase = Supabase.instance.client;

  // ── Insert Pengajuan (tanpa foto) ────────────────────────
  // Return: ID pengajuan yang baru dibuat.
  // Foto diupload terpisah — ID ini dipakai sebagai nama file.
  Future<String> createPengajuan(PengajuanModel model) async {
    final response = await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .insert(model.toJsonInsert())
        .select(SupabaseColumn.id)   // minta Supabase return id-nya
        .single();

    return response[SupabaseColumn.id] as String;
  }

  // ── Update URL Foto Setelah Upload Berhasil ───────────────
  Future<void> updateFotoPengajuan({
    required String pengajuanId,
    required String fotoUrl,
  }) async {
    await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .update({SupabaseColumn.fotoMobil: fotoUrl})
        .eq(SupabaseColumn.id, pengajuanId);
  }

  // ── Ambil Semua Pengajuan Milik Seller ───────────────────
  // RLS di Supabase sudah memfilter berdasarkan seller_id = auth.uid(),
  // tapi kita tetap filter eksplisit sebagai double safety.
  Future<List<PengajuanModel>> getMySemua(String sellerId) async {
    final response = await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .select()
        .eq(SupabaseColumn.sellerId, sellerId)
        .order(SupabaseColumn.dibuatPada, ascending: false);

    return (response as List)
        .map((json) => PengajuanModel.fromJson(json))
        .toList();
  }
}