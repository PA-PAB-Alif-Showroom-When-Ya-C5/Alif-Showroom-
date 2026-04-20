import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class AuthUser {
  final String id;
  final String email;
  final String namaLengkap;
  final UserRole role;

  const AuthUser({
    required this.id,
    required this.email,
    required this.namaLengkap,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id:           json[SupabaseColumn.id] as String,
      email:        json[SupabaseColumn.email] as String,
      namaLengkap:  json[SupabaseColumn.namaLengkap] as String,
      role:         UserRoleExt.fromString(json[SupabaseColumn.role] as String),
    );
  }
}

class AuthService extends GetxService {
  final _supabase = Supabase.instance.client;

  // ── State ──
  final Rxn<AuthUser> _currentUser = Rxn<AuthUser>();

  // ── Getters Publik ──
  AuthUser? get currentUser => _currentUser.value;
  bool get isLoggedIn       => _supabase.auth.currentSession != null;
  bool get isAdmin          => _currentUser.value?.role == UserRole.admin;
  bool get isSeller         => _currentUser.value?.role == UserRole.seller;
  bool get isGuest          => !isLoggedIn;
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ── Inisialisasi ──
  Future<AuthService> init() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await loadUserProfile(session.user.id);
    }
    return this;
  }

  // ── Public Methods ──
  Future<void> loadUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from(SupabaseTable.profilPengguna)
          .select()
          .eq(SupabaseColumn.id, userId)
          .maybeSingle();

      if (data != null) {
        _currentUser.value = AuthUser.fromJson(data);
      } else {
        // Profil tidak ditemukan — bersihkan state
        _currentUser.value = null;
      }
    } catch (_) {
      _currentUser.value = null;
    }
  }
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _currentUser.value = null;
  }
}