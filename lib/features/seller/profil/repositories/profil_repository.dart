import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/profil_pengguna_model.dart';

class ProfilRepository {
  final _supabase = Supabase.instance.client;

  Future<ProfilPenggunaModel?> getProfilById(String userId) async {
    final data = await _supabase
        .from(SupabaseTable.profilPengguna)
        .select()
        .eq(SupabaseColumn.id, userId)
        .maybeSingle();

    if (data == null) return null;
    return ProfilPenggunaModel.fromJson(data);
  }

  Future<void> updateProfil({
    required String userId,
    required String namaLengkap,
    required String nomorWhatsapp,
    String? alamatLengkap,
  }) async {
    await _supabase
        .from(SupabaseTable.profilPengguna)
        .update({
          SupabaseColumn.namaLengkap:   namaLengkap.trim(),
          SupabaseColumn.nomorWhatsapp: nomorWhatsapp.trim(),
          if (alamatLengkap != null && alamatLengkap.trim().isNotEmpty)
            SupabaseColumn.alamatLengkap: alamatLengkap.trim(),
        })
        .eq(SupabaseColumn.id, userId);
  }

  // ── Update URL foto profil ────────────────────────────────
  Future<void> updateFotoProfil({
    required String userId,
    required String fotoUrl,
  }) async {
    await _supabase
        .from(SupabaseTable.profilPengguna)
        .update({SupabaseColumn.fotoProfil: fotoUrl})
        .eq(SupabaseColumn.id, userId);
  }
}