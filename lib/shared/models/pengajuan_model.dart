import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class PengajuanModel {
  final String id;
  final String sellerId;
  final String merek;
  final String tipeModel;
  final int tahun;
  final Transmisi transmisi;
  final int jarakTempuh;
  final BahanBakar bahanBakar;
  final double hargaDiinginkan;
  final StatusStnk statusStnk;
  final String deskripsiKondisi;
  final String? fotoMobil;
  final String nomorWhatsapp;
  final StatusPengajuan statusPengajuan;
  final String? catatanAdmin;
  final DateTime dibuatPada;
  final DateTime diupdatePada;

  const PengajuanModel({
    required this.id,
    required this.sellerId,
    required this.merek,
    required this.tipeModel,
    required this.tahun,
    required this.transmisi,
    required this.jarakTempuh,
    required this.bahanBakar,
    required this.hargaDiinginkan,
    required this.statusStnk,
    required this.deskripsiKondisi,
    this.fotoMobil,
    required this.nomorWhatsapp,
    required this.statusPengajuan,
    this.catatanAdmin,
    required this.dibuatPada,
    required this.diupdatePada,
  });

  // ── Deserialisasi dari response Supabase ─────────────────
  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      id:               json[SupabaseColumn.id] as String,
      sellerId:         json[SupabaseColumn.sellerId] as String,
      merek:            json[SupabaseColumn.merek] as String,
      tipeModel:        json[SupabaseColumn.tipeModel] as String,
      tahun:            json[SupabaseColumn.tahun] as int,
      transmisi:        TransmisiExt.fromString(
                          json[SupabaseColumn.transmisi] as String),
      jarakTempuh:      json[SupabaseColumn.jarakTempuh] as int,
      bahanBakar:       BahanBakarExt.fromString(
                          json[SupabaseColumn.bahanBakar] as String),
      hargaDiinginkan:  (json[SupabaseColumn.hargaDiinginkan] as num)
                          .toDouble(),
      statusStnk:       StatusStnkExt.fromString(
                          json[SupabaseColumn.statusStnk] as String),
      deskripsiKondisi: json[SupabaseColumn.deskripsiKondisi] as String,
      fotoMobil:        json[SupabaseColumn.fotoMobil] as String?,
      nomorWhatsapp:    json[SupabaseColumn.nomorWhatsapp] as String,
      statusPengajuan:  StatusPengajuanExt.fromString(
                          json[SupabaseColumn.statusPengajuan] as String),
      catatanAdmin:     json[SupabaseColumn.catatanAdmin] as String?,
      dibuatPada:       DateTime.parse(json[SupabaseColumn.dibuatPada]
                          as String),
      diupdatePada:     DateTime.parse(json[SupabaseColumn.diupdatePada]
                          as String),
    );
  }

  // ── Serialisasi untuk INSERT ke Supabase ─────────────────
  // Tidak menyertakan: id, status_pengajuan, catatan_admin,
  // dibuat_pada, diupdate_pada — semua dihandle database
  Map<String, dynamic> toJsonInsert() {
    return {
      SupabaseColumn.sellerId:         sellerId,
      SupabaseColumn.merek:            merek,
      SupabaseColumn.tipeModel:        tipeModel,
      SupabaseColumn.tahun:            tahun,
      SupabaseColumn.transmisi:        transmisi.dbValue,
      SupabaseColumn.jarakTempuh:      jarakTempuh,
      SupabaseColumn.bahanBakar:       bahanBakar.dbValue,
      SupabaseColumn.hargaDiinginkan:  hargaDiinginkan,
      SupabaseColumn.statusStnk:       statusStnk.dbValue,
      SupabaseColumn.deskripsiKondisi: deskripsiKondisi,
      SupabaseColumn.nomorWhatsapp:    nomorWhatsapp,
      // foto_mobil dikirim terpisah setelah upload selesai
    };
  }
}