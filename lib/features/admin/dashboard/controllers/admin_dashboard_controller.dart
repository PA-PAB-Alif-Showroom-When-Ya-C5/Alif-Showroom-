import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/features/admin/dashboard/repositories/dashboard_repository.dart';

class AdminDashboardController extends GetxController {
  final _repo        = DashboardRepository();
  final _authService = Get.find<AuthService>();
  final currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  final totalMobil         = 0.obs;
  final totalMobilTersedia = 0.obs;
  final totalMobilTerjual  = 0.obs;
  final totalTransaksi     = 0.obs;
  final totalProfit        = 0.0.obs;
  final pengajuanMenunggu  = 0.obs;
  final transaksiTerbaru   = <Map<String, dynamic>>[].obs;
  final isLoading          = false.obs;
  final errorMessage       = ''.obs;

  String get namaAdmin =>
      _authService.currentUser?.namaLengkap ?? 'Admin';

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final results = await Future.wait([
        _repo.getRingkasan(),
        _repo.getJumlahPengajuanMenunggu(),
        _repo.getTransaksiTerbaru(),
      ]);

      final ringkasan = results[0] as Map<String, dynamic>;
      totalMobil.value         =
          (ringkasan['total_mobil']          ?? 0) as int;
      totalMobilTersedia.value =
          (ringkasan['total_mobil_tersedia'] ?? 0) as int;
      totalMobilTerjual.value  =
          (ringkasan['total_mobil_terjual']  ?? 0) as int;
      totalTransaksi.value     =
          (ringkasan['total_transaksi']      ?? 0) as int;
      totalProfit.value        =
          ((ringkasan['total_profit'] ?? 0) as num).toDouble();
      pengajuanMenunggu.value  = results[1] as int;
      transaksiTerbaru.assignAll(
          results[2] as List<Map<String, dynamic>>);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data dashboard.';
      debugPrint('[Dashboard] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => loadDashboard();
  void keKelolaMobil()     => changeTab(1);
  void keKelolaPengajuan() => changeTab(2);
  void keTransaksi()       => changeTab(3);
  void keLaporan() => Get.toNamed(AppRoutes.laporan);

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title:   const Text('Keluar'),
        content: const Text('Kamu akan keluar dari akun admin.\nLanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:     const Text('Batal'),
          ),
          ElevatedButton(
            style:    ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Keluar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.guestHome);
  }
}