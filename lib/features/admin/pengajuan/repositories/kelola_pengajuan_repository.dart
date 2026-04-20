import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';

class KelolaPengajuanRepository {
  final _supabase = Supabase.instance.client;

  // ── Ambil semua pengajuan, join nama seller ───────────────
  Future<List<PengajuanModel>> getAll() async {
    final response = await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .select()
        .order(SupabaseColumn.dibuatPada, ascending: false);

    return (response as List)
        .map((json) => PengajuanModel.fromJson(json))
        .toList();
  }

  // ── Update status pengajuan ───────────────────────────────
  Future<void> updateStatus({
    required String         pengajuanId,
    required StatusPengajuan status,
  }) async {
    await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .update({SupabaseColumn.statusPengajuan: status.dbValue})
        .eq(SupabaseColumn.id, pengajuanId);
  }

  // ── Update catatan admin ──────────────────────────────────
  Future<void> updateCatatan({
    required String pengajuanId,
    required String catatan,
  }) async {
    await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .update({SupabaseColumn.catatanAdmin: catatan.trim()})
        .eq(SupabaseColumn.id, pengajuanId);
  }

  // ── Update status + catatan sekaligus ─────────────────────
  Future<void> updateStatusDanCatatan({
    required String          pengajuanId,
    required StatusPengajuan status,
    required String          catatan,
  }) async {
    await _supabase
        .from(SupabaseTable.pengajuanMobil)
        .update({
          SupabaseColumn.statusPengajuan: status.dbValue,
          SupabaseColumn.catatanAdmin:    catatan.trim(),
        })
        .eq(SupabaseColumn.id, pengajuanId);
  }
}