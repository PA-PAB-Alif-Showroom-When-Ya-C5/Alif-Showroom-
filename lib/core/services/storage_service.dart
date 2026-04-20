import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  // ── Upload Foto Pengajuan ──
  Future<String> uploadFotoPengajuan({
    required File file,
    required String pengajuanId,
  }) async {
    debugPrint('[Storage] File path: ${file.path}');
    final ext = file.path.split('.').last.toLowerCase();
    final filePath = 'pengajuan_$pengajuanId.$ext';
    debugPrint('[Storage] Upload path: $filePath');
    debugPrint('[Storage] Bucket: ${SupabaseBucket.fotoMobil}');


    if (!await file.exists()) {
      throw Exception('File foto tidak ditemukan di path: ${file.path}');
    }
    String contentType = 'image/jpeg';
    if (ext == 'png') {
      contentType = 'image/png';
    } else if (ext == 'webp') {
      contentType = 'image/webp';
    }
    await _supabase.storage
        .from(SupabaseBucket.fotoMobil)
        .upload(
          filePath,
          file,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentType,
          ),
        );
    final url = _supabase.storage
        .from(SupabaseBucket.fotoMobil)
        .getPublicUrl(filePath);

    debugPrint('[Storage] URL: $url');
    return url;
  }

  // ── Upload Foto Profil ──
  Future<String> uploadFotoProfil({
    required File file,
    required String userId,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final filePath = 'profil_$userId.$ext';

    if (!await file.exists()) {
      throw Exception('File profil tidak ditemukan');
    }
    await _supabase.storage
        .from(SupabaseBucket.fotoProfil)
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return _supabase.storage
        .from(SupabaseBucket.fotoProfil)
        .getPublicUrl(filePath);
  }

  Future<String> uploadFotoMobil({
    required File file,
    required String mobilId,
  }) async {
    final ext      = file.path.split('.').last.toLowerCase();
    final filePath = 'mobil_$mobilId.$ext';

    await _supabase.storage
        .from(SupabaseBucket.fotoMobil)
        .upload(filePath, file,
            fileOptions: const FileOptions(upsert: true));

    return _supabase.storage
        .from(SupabaseBucket.fotoMobil)
        .getPublicUrl(filePath);
  }

  // ── Upload Nota Transaksi ──
  Future<String> uploadNotaTransaksi({
    required File file,
    required String transaksiId,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final filePath = 'nota_$transaksiId.$ext';

    if (!await file.exists()) {
      throw Exception('File nota tidak ditemukan');
    }
    await _supabase.storage
        .from(SupabaseBucket.notaTransaksi)
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    final signedUrl = await _supabase.storage
        .from(SupabaseBucket.notaTransaksi)
        .createSignedUrl(filePath, 60 * 60 * 24 * 7);
    return signedUrl;
  }
}