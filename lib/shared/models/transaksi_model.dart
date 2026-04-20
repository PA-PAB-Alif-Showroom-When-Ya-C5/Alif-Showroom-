import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';

class TransaksiModel {
  final String      id;
  final String      mobilId;
  final String      namaPembeli;
  final String      nomorPembeli;
  final double      hargaModal;
  final double      hargaJual;
  final double      hargaDeal;
  final double      profit;
  final String?     notaTransaksi;
  final DateTime    tanggalTransaksi;
  final String      dibuatOleh;
  final DateTime    dibuatPada;
  final DateTime    diupdatePada;

  final MobilModel? mobil;

  const TransaksiModel({
    required this.id,
    required this.mobilId,
    required this.namaPembeli,
    required this.nomorPembeli,
    required this.hargaModal,
    required this.hargaJual,
    required this.hargaDeal,
    required this.profit,
    this.notaTransaksi,
    required this.tanggalTransaksi,
    required this.dibuatOleh,
    required this.dibuatPada,
    required this.diupdatePada,
    this.mobil,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id:               json[SupabaseColumn.id]              as String,
      mobilId:          json[SupabaseColumn.mobilId]         as String,
      namaPembeli:      json[SupabaseColumn.namaPembeli]     as String,
      nomorPembeli:     json[SupabaseColumn.nomorPembeli]    as String,
      hargaModal:       (json[SupabaseColumn.hargaModal]  as num).toDouble(),
      hargaJual:        (json[SupabaseColumn.hargaJual]   as num).toDouble(),
      hargaDeal:        (json[SupabaseColumn.hargaDeal]   as num).toDouble(),
      profit:           (json[SupabaseColumn.profit]      as num).toDouble(),
      notaTransaksi:    json[SupabaseColumn.notaTransaksi]   as String?,
      tanggalTransaksi: DateTime.parse(
                          json[SupabaseColumn.tanggalTransaksi] as String),
      dibuatOleh:       json[SupabaseColumn.dibuatOleh]     as String,
      dibuatPada:       DateTime.parse(
                          json[SupabaseColumn.dibuatPada]    as String),
      diupdatePada:     DateTime.parse(
                          json[SupabaseColumn.diupdatePada]  as String),
      mobil: json['mobil'] != null
          ? MobilModel.fromJson(json['mobil'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJsonInsert() {
    return {
      SupabaseColumn.mobilId: mobilId,
      SupabaseColumn.namaPembeli: namaPembeli,
      SupabaseColumn.nomorPembeli: nomorPembeli,
      SupabaseColumn.hargaModal: hargaModal,
      SupabaseColumn.hargaJual: hargaJual,
      SupabaseColumn.hargaDeal: hargaDeal,
      SupabaseColumn.notaTransaksi: notaTransaksi, // tambahkan ini
      SupabaseColumn.tanggalTransaksi:
          tanggalTransaksi.toIso8601String().split('T')[0],
      SupabaseColumn.dibuatOleh: dibuatOleh,
    };
  }
}