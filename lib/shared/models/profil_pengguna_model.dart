import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class ProfilPenggunaModel {
  final String id;
  final String namaLengkap;
  final String email;
  final String nomorWhatsapp;
  final String? fotoProfil;
  final UserRole role;
  final DateTime dibuatPada;
  final DateTime diupdatePada;

  const ProfilPenggunaModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nomorWhatsapp,
    this.fotoProfil,
    required this.role,
    required this.dibuatPada,
    required this.diupdatePada,
  });

  // ── Deserialisasi dari JSON Supabase ─────────────────────
  factory ProfilPenggunaModel.fromJson(Map<String, dynamic> json) {
    return ProfilPenggunaModel(
      id:             json[SupabaseColumn.id] as String,
      namaLengkap:    json[SupabaseColumn.namaLengkap] as String,
      email:          json[SupabaseColumn.email] as String,
      nomorWhatsapp:  json[SupabaseColumn.nomorWhatsapp] as String,
      fotoProfil:     json[SupabaseColumn.fotoProfil] as String?,
      role:           UserRoleExt.fromString(json[SupabaseColumn.role] as String),
      dibuatPada:     DateTime.parse(json[SupabaseColumn.dibuatPada] as String),
      diupdatePada:   DateTime.parse(json[SupabaseColumn.diupdatePada] as String),
    );
  }

  // ── Serialisasi ke JSON untuk INSERT/UPDATE ──────────────
  // Tidak menyertakan id, dibuat_pada, diupdate_pada —
  // ketiganya dihandle database
  Map<String, dynamic> toJson() {
    return {
      SupabaseColumn.namaLengkap:   namaLengkap,
      SupabaseColumn.email:         email,
      SupabaseColumn.nomorWhatsapp: nomorWhatsapp,
      if (fotoProfil != null)
        SupabaseColumn.fotoProfil: fotoProfil,
      SupabaseColumn.role:          role.dbValue,
    };
  }

  // ── CopyWith untuk update sebagian field ─────────────────
  ProfilPenggunaModel copyWith({
    String? namaLengkap,
    String? nomorWhatsapp,
    String? fotoProfil,
  }) {
    return ProfilPenggunaModel(
      id:             id,
      namaLengkap:    namaLengkap    ?? this.namaLengkap,
      email:          email,
      nomorWhatsapp:  nomorWhatsapp  ?? this.nomorWhatsapp,
      fotoProfil:     fotoProfil     ?? this.fotoProfil,
      role:           role,
      dibuatPada:     dibuatPada,
      diupdatePada:   diupdatePada,
    );
  }

  // ── Helper getter ────────────────────────────────────────
  bool get isAdmin  => role == UserRole.admin;
  bool get isSeller => role == UserRole.seller;

  /// Inisial nama untuk avatar fallback
  String get inisial {
    final parts = namaLengkap.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  String toString() =>
      'ProfilPenggunaModel(id: $id, nama: $namaLengkap, role: ${role.dbValue})';
}