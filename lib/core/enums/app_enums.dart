import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

// ── USER ROLE ──
enum UserRole { admin, seller }

extension UserRoleExt on UserRole {
  String get dbValue => name;

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.seller:
        return 'Seller';
    }
  }

  static UserRole fromString(String value) {
    final normalized = value.toLowerCase();
    return UserRole.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('UserRole tidak valid: $value'),
    );
  }
}

// ── Transmisi ──
enum Transmisi { manual, matic }

extension TransmisiExt on Transmisi {
  String get dbValue => name;

  String get label {
    switch (this) {
      case Transmisi.manual:
        return 'Manual';
      case Transmisi.matic:
        return 'Matic';
    }
  }

  static Transmisi fromString(String value) {
    final normalized = value.toLowerCase();
    return Transmisi.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('Transmisi tidak valid: $value'),
    );
  }
}

// ── Bahan Bakar ──
enum BahanBakar { bensin, diesel, listrik, hybrid }

extension BahanBakarExt on BahanBakar {
  String get dbValue => name;

  String get label {
    switch (this) {
      case BahanBakar.bensin:
        return 'Bensin';
      case BahanBakar.diesel:
        return 'Diesel';
      case BahanBakar.listrik:
        return 'Listrik';
      case BahanBakar.hybrid:
        return 'Hybrid';
    }
  }

  static BahanBakar fromString(String value) {
    final normalized = value.toLowerCase();
    return BahanBakar.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('BahanBakar tidak valid: $value'),
    );
  }
}

// ── Status Mobil ──
enum StatusMobil { tersedia, terjual }

extension StatusMobilExt on StatusMobil {
  String get dbValue => name;

  String get label {
    switch (this) {
      case StatusMobil.tersedia:
        return 'Tersedia';
      case StatusMobil.terjual:
        return 'Terjual';
    }
  }

  Color get color {
    switch (this) {
      case StatusMobil.tersedia:
        return AppTheme.statusTersedia;
      case StatusMobil.terjual:
        return AppTheme.statusTerjual;
    }
  }

  static StatusMobil fromString(String value) {
    final normalized = value.toLowerCase();
    return StatusMobil.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('StatusMobil tidak valid: $value'),
    );
  }
}

// ── Status Pengajuan ──
enum StatusPengajuan { menunggu, diproses, diterima, ditolak }

extension StatusPengajuanExt on StatusPengajuan {
  String get dbValue => name;

  String get label {
    switch (this) {
      case StatusPengajuan.menunggu:
        return 'Menunggu';
      case StatusPengajuan.diproses:
        return 'Diproses';
      case StatusPengajuan.diterima:
        return 'Diterima';
      case StatusPengajuan.ditolak:
        return 'Ditolak';
    }
  }

  Color get color {
    switch (this) {
      case StatusPengajuan.menunggu:
        return AppTheme.statusMenunggu;
      case StatusPengajuan.diproses:
        return AppTheme.statusDiproses;
      case StatusPengajuan.diterima:
        return AppTheme.statusDiterima;
      case StatusPengajuan.ditolak:
        return AppTheme.statusDitolak;
    }
  }

  static StatusPengajuan fromString(String value) {
    final normalized = value.toLowerCase();
    return StatusPengajuan.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('StatusPengajuan tidak valid: $value'),
    );
  }
}

// ── Status STNK ──
enum StatusStnk { aktif, tidak_aktif, tidak_diketahui }

extension StatusStnkExt on StatusStnk {
  String get dbValue => name;

  String get label {
    switch (this) {
      case StatusStnk.aktif:
        return 'Aktif';
      case StatusStnk.tidak_aktif:
        return 'Tidak Aktif';
      case StatusStnk.tidak_diketahui:
        return 'Tidak Diketahui';
    }
  }

  static StatusStnk fromString(String value) {
    final normalized = value.toLowerCase();
    return StatusStnk.values.firstWhere(
      (e) => e.dbValue == normalized,
      orElse: () => throw ArgumentError('StatusStnk tidak valid: $value'),
    );
  }
}