import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/features/auth/repositories/auth_repository.dart';

class AuthController extends GetxController {
  // ── Dependencies ─────────────────────────────────────────
  final AuthRepository _repo = AuthRepository();
  final AuthService _authService = Get.find<AuthService>();

  // ── Form Keys ────────────────────────────────────────────
  final loginFormKey    = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // ── Controllers Login ─────────────────────────────────────
  final loginEmailCtrl    = TextEditingController();
  final loginPasswordCtrl = TextEditingController();

  // ── Controllers Register ──────────────────────────────────
  final registerNamaCtrl     = TextEditingController();
  final registerEmailCtrl    = TextEditingController();
  final registerWaCtrl       = TextEditingController();
  final registerPasswordCtrl = TextEditingController();
  final registerKonfirmasiCtrl = TextEditingController();

  // ── Observable State ─────────────────────────────────────
  final isLoginLoading    = false.obs;
  final isRegisterLoading = false.obs;
  final isLoginPasswordVisible    = false.obs;
  final isRegisterPasswordVisible = false.obs;
  final isKonfirmasiPasswordVisible = false.obs;
  final loginError    = ''.obs;
  final registerError = ''.obs;

  // ── Computed Getter ───────────────────────────────────────
  String get registerPassword => registerPasswordCtrl.text;

  // ── Login ─────────────────────────────────────────────────

  Future<void> login() async {
    // Reset error sebelumnya
    loginError.value = '';

    // Validasi form
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoginLoading.value = true;

      await _repo.signIn(
        email:    loginEmailCtrl.text,
        password: loginPasswordCtrl.text,
      );

      // Load profil ke AuthService setelah login berhasil
      final userId = _repo.currentUserId;
      if (userId == null) throw Exception('User ID tidak ditemukan setelah login');

      await _authService.loadUserProfile(userId);

      // Navigasi berdasarkan role — hapus semua halaman sebelumnya
      _redirectByRole();
    } on AuthException catch (e) {
      loginError.value = _parseAuthError(e.message);
    } catch (e) {
      loginError.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isLoginLoading.value = false;
    }
  }

  // ── Register ──────────────────────────────────────────────

  Future<void> registerSeller() async {
    // Reset error sebelumnya
    registerError.value = '';

    // Validasi form
    if (!registerFormKey.currentState!.validate()) return;

    try {
      isRegisterLoading.value = true;

      await _repo.registerSeller(
        email:          registerEmailCtrl.text,
        password:       registerPasswordCtrl.text,
        namaLengkap:    registerNamaCtrl.text,
        nomorWhatsapp:  registerWaCtrl.text,
      );

      // Setelah register, langsung login otomatis
      await _repo.signIn(
        email:    registerEmailCtrl.text,
        password: registerPasswordCtrl.text,
      );

      final userId = _repo.currentUserId;
      if (userId == null) throw Exception('User ID tidak ditemukan setelah register');

      // Load profil — tunggu sebentar karena trigger database
      // perlu waktu sesaat untuk membuat baris profil_pengguna
      await Future.delayed(const Duration(milliseconds: 500));
      await _authService.loadUserProfile(userId);

      // Seller selalu diarahkan ke seller dashboard
      Get.offAllNamed(AppRoutes.sellerDashboard);
    } on AuthException catch (e) {
      registerError.value = _parseAuthError(e.message);
    } catch (e) {
      registerError.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // ── Toggle Visibility Password ────────────────────────────

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  void toggleKonfirmasiVisibility() {
    isKonfirmasiPasswordVisible.value = !isKonfirmasiPasswordVisible.value;
  }

  // ── Private Helpers ───────────────────────────────────────

  void _redirectByRole() {
    if (_authService.isAdmin) {
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else if (_authService.isSeller) {
      Get.offAllNamed(AppRoutes.sellerDashboard);
    } else {
      // Fallback — seharusnya tidak terjadi
      Get.offAllNamed(AppRoutes.guestHome);
    }
  }

  /// Menerjemahkan pesan error Supabase Auth ke bahasa Indonesia
  String _parseAuthError(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password')) {
      return 'Email atau password salah';
    }
    if (msg.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek inbox kamu.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('already been registered')) {
      return 'Email ini sudah terdaftar. Gunakan email lain.';
    }
    if (msg.contains('password should be at least')) {
      return 'Password minimal 6 karakter';
    }
    if (msg.contains('unable to validate email address')) {
      return 'Format email tidak valid';
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return 'Gagal terhubung ke server. Periksa koneksi internet kamu.';
    }
    if (msg.contains('rate limit') || msg.contains('too many requests')) {
      return 'Terlalu banyak percobaan. Tunggu beberapa menit.';
    }

    return 'Terjadi kesalahan: $message';
  }

  // ── Lifecycle ─────────────────────────────────────────────

  @override
  void onClose() {
    // Selalu dispose TextEditingController untuk mencegah memory leak
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    registerNamaCtrl.dispose();
    registerEmailCtrl.dispose();
    registerWaCtrl.dispose();
    registerPasswordCtrl.dispose();
    registerKonfirmasiCtrl.dispose();
    super.onClose();
  }
}