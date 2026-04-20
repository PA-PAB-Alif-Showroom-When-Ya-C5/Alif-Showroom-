import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/profil_pengguna_model.dart';

/// Repository untuk operasi autentikasi.
/// Berkomunikasi langsung dengan Supabase Auth dan tabel profil_pengguna.
class AuthRepository {
  final _supabase = Supabase.instance.client;

  // ── Login ────────────────────────────────────────────────

  /// Login dengan email dan password.
  /// Melempar [AuthException] jika kredensial salah.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ── Register ─────────────────────────────────────────────

  /// Register akun seller baru.
  ///
  /// Alur:
  /// 1. Daftar ke Supabase Auth dengan metadata role
  /// 2. Trigger [handle_new_user] di database otomatis membuat
  ///    baris di profil_pengguna
  ///
  /// Melempar [AuthException] jika email sudah terdaftar.
  Future<void> registerSeller({
    required String email,
    required String password,
    required String namaLengkap,
    required String nomorWhatsapp,
  }) async {
    await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        // Metadata ini dibaca oleh trigger handle_new_user di Supabase
        'role':           'seller',
        'nama_lengkap':   namaLengkap.trim(),
        'nomor_whatsapp': nomorWhatsapp.trim(),
      },
    );
  }

  // ── Profil ───────────────────────────────────────────────

  /// Mengambil profil pengguna berdasarkan user ID.
  /// Mengembalikan null jika profil tidak ditemukan.
  Future<ProfilPenggunaModel?> getProfilById(String userId) async {
    final data = await _supabase
        .from(SupabaseTable.profilPengguna)
        .select()
        .eq(SupabaseColumn.id, userId)
        .maybeSingle();

    if (data == null) return null;
    return ProfilPenggunaModel.fromJson(data);
  }

  // ── Sign Out ─────────────────────────────────────────────

  /// Logout dari Supabase Auth.
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ── Session ──────────────────────────────────────────────

  /// Mengecek apakah ada session aktif saat ini.
  bool get hasActiveSession => _supabase.auth.currentSession != null;

  /// Mengambil user ID dari session aktif.
  String? get currentUserId => _supabase.auth.currentUser?.id;
}