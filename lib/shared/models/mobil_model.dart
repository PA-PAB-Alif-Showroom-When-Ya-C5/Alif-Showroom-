import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class MobilModel {
  final String id;
  final String merek;
  final String tipeModel;
  final int tahun;
  final Transmisi transmisi;
  final double harga;
  final int jarakTempuh;
  final BahanBakar bahanBakar;
  final String warna;
  final StatusStnk statusStnk;
  final String? deskripsi;
  final StatusMobil statusMobil;
  final String? fotoMobil;
  final String dibuatOleh;
  final DateTime dibuatPada;
  final DateTime diupdatePada;

  const MobilModel({
    required this.id,
    required this.merek,
    required this.tipeModel,
    required this.tahun,
    required this.transmisi,
    required this.harga,
    required this.jarakTempuh,
    required this.bahanBakar,
    required this.warna,
    required this.statusStnk,
    this.deskripsi,
    required this.statusMobil,
    this.fotoMobil,
    required this.dibuatOleh,
    required this.dibuatPada,
    required this.diupdatePada,
  });

  factory MobilModel.fromJson(Map<String, dynamic> json) {
    return MobilModel(
      id:           json[SupabaseColumn.id]          as String,
      merek:        json[SupabaseColumn.merek]        as String,
      tipeModel:    json[SupabaseColumn.tipeModel]    as String,
      tahun:        json[SupabaseColumn.tahun]        as int,
      transmisi:    TransmisiExt.fromString(
                      json[SupabaseColumn.transmisi]  as String),
      harga:        (json[SupabaseColumn.harga] as num).toDouble(),
      jarakTempuh:  json[SupabaseColumn.jarakTempuh] as int,
      bahanBakar:   BahanBakarExt.fromString(
                      json[SupabaseColumn.bahanBakar] as String),
      warna:        json[SupabaseColumn.warna]        as String,
      statusStnk:   StatusStnkExt.fromString(
                      json[SupabaseColumn.statusStnk] as String),
      deskripsi:    json[SupabaseColumn.deskripsi]   as String?,
      statusMobil:  StatusMobilExt.fromString(
                      json[SupabaseColumn.statusMobil] as String),
      fotoMobil:    json[SupabaseColumn.fotoMobil]   as String?,
      dibuatOleh:   json[SupabaseColumn.dibuatOleh]  as String,
      dibuatPada:   DateTime.parse(
                      json[SupabaseColumn.dibuatPada] as String),
      diupdatePada: DateTime.parse(
                      json[SupabaseColumn.diupdatePada] as String),
    );
  }

  // toJson untuk INSERT & UPDATE — tidak sertakan id & timestamp
  Map<String, dynamic> toJson() {
    return {
      SupabaseColumn.merek:       merek,
      SupabaseColumn.tipeModel:   tipeModel,
      SupabaseColumn.tahun:       tahun,
      SupabaseColumn.transmisi:   transmisi.dbValue,
      SupabaseColumn.harga:       harga,
      SupabaseColumn.jarakTempuh: jarakTempuh,
      SupabaseColumn.bahanBakar:  bahanBakar.dbValue,
      SupabaseColumn.warna:       warna,
      SupabaseColumn.statusStnk:  statusStnk.dbValue,
      SupabaseColumn.statusMobil: statusMobil.dbValue,
      SupabaseColumn.dibuatOleh:  dibuatOleh,
      if (deskripsi != null)
        SupabaseColumn.deskripsi: deskripsi,
    };
  }
}