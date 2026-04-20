import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/admin/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:showroom_mobil/features/admin/dashboard/views/widgets/dashboard_stat_card.dart';
import 'package:showroom_mobil/features/admin/dashboard/views/widgets/shortcut_menu_item.dart';
import 'package:showroom_mobil/features/admin/mobil/controllers/kelola_mobil_controller.dart';
import 'package:showroom_mobil/features/admin/mobil/views/kelola_mobil_page.dart';
import 'package:showroom_mobil/features/admin/pengajuan/controllers/kelola_pengajuan_controller.dart';
import 'package:showroom_mobil/features/admin/pengajuan/views/kelola_pengajuan_page.dart';
import 'package:showroom_mobil/features/admin/transaksi/controllers/transaksi_controller.dart';
import 'package:showroom_mobil/features/admin/transaksi/views/transaksi_page.dart';
import 'package:showroom_mobil/features/admin/laporan/controllers/laporan_controller.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashCtrl = Get.put(AdminDashboardController());
    Get.put(KelolaMobilController());
    Get.put(KelolaPengajuanController());
    Get.put(TransaksiController());
    Get.put(LaporanController());

    return Obx(() => Scaffold(
      body: IndexedStack(
        index: dashCtrl.currentTabIndex.value,
        children: const [
          _DashboardTab(),
          KelolaMobilPage(),
          KelolaPengajuanPage(),
          TransaksiPage(),
        ],
      ),
      bottomNavigationBar: _AdminBottomNav(controller: dashCtrl),
    ));
  }
}
class _AdminBottomNav extends StatelessWidget {
  final AdminDashboardController controller;
  const _AdminBottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex:     controller.currentTabIndex.value,
      onTap:            controller.changeTab,
      type:             BottomNavigationBarType.fixed,
      selectedItemColor:   AppTheme.primary,
      unselectedItemColor: AppTheme.textSecondary,
      selectedLabelStyle:  const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: [
        const BottomNavigationBarItem(
          icon:  Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon:  Icon(Icons.directions_car_outlined),
          activeIcon: Icon(Icons.directions_car_rounded),
          label: 'Mobil',
        ),
        BottomNavigationBarItem(
          icon: Obx(() {
            final count = Get.find<AdminDashboardController>()
                .pengajuanMenunggu.value;
            if (count == 0) {
              return const Icon(Icons.inbox_outlined);
            }
            return Badge(
              label: Text('$count'),
              child: const Icon(Icons.inbox_outlined),
            );
          }),
          activeIcon: const Icon(Icons.inbox_rounded),
          label: 'Pengajuan',
        ),
        const BottomNavigationBarItem(
          icon:  Icon(Icons.point_of_sale_outlined),
          activeIcon: Icon(Icons.point_of_sale_rounded),
          label: 'Transaksi',
        ),
      ],
    ));
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.refresh,
          color:     AppTheme.primary,
          child: CustomScrollView(
            slivers: [
              _DashboardAppBar(controller: controller),

              if (controller.errorMessage.value.isNotEmpty)
                SliverToBoxAdapter(
                  child: _ErrorBanner(
                    message: controller.errorMessage.value,
                    onRetry: controller.refresh,
                  ),
                ),

              SliverToBoxAdapter(
                child: _StatSection(controller: controller),
              ),
              SliverToBoxAdapter(
                child: _ShortcutSection(controller: controller),
              ),
              SliverToBoxAdapter(
                child: _TransaksiTerbaruSection(controller: controller),
              ),
              SliverToBoxAdapter(
                child: _StatusShowroomSection(controller: controller),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingXl),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _DashboardAppBar extends StatelessWidget {
  final AdminDashboardController controller;
  const _DashboardAppBar({required this.controller});

  String _greeting() {
    return 'Alif Berkah Dua Bersaudara';
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight:   120,
      pinned:           true,
      backgroundColor:  AppTheme.primary,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon:      const Icon(Icons.logout, color: Colors.white),
          tooltip:   'Keluar',
          onPressed: controller.logout,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryLight],
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd, 60,
            AppTheme.spacingMd, AppTheme.spacingMd,
          ),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  )),
              const SizedBox(height: 4),
              Obx(() => Text(controller.namaAdmin,
                  style: const TextStyle(
                    color: Colors.white, fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ))),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                    .format(DateTime.now()),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatSection extends StatelessWidget {
  final AdminDashboardController controller;
  const _StatSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingSm,
        AppTheme.spacingMd,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          const _SectionTitle('Ringkasan Showroom'),
          const SizedBox(height: 8),
          Obx(() => GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppTheme.spacingSm,
            mainAxisSpacing: AppTheme.spacingSm,
            childAspectRatio: 1.28,
            children: [
              DashboardStatCard(
                label: 'Total Mobil',
                value: '${controller.totalMobil.value}',
                icon: Icons.directions_car_rounded,
                color: AppTheme.primary,
              ),
              DashboardStatCard(
                label: 'Mobil Tersedia',
                value: '${controller.totalMobilTersedia.value}',
                icon: Icons.check_circle_outline,
                color: AppTheme.success,
                subtitle: 'Siap dijual',
              ),
              DashboardStatCard(
                label: 'Mobil Terjual',
                value: '${controller.totalMobilTerjual.value}',
                icon: Icons.sell_outlined,
                color: AppTheme.info,
              ),
              DashboardStatCard(
                label: 'Pengajuan Masuk',
                value: '${controller.pengajuanMenunggu.value}',
                icon: Icons.inbox_outlined,
                color: AppTheme.warning,
                subtitle: 'Menunggu review',
              ),
              DashboardStatCard(
                label: 'Total Transaksi',
                value: '${controller.totalTransaksi.value}',
                icon: Icons.receipt_long_outlined,
                color: AppTheme.primaryLight,
              ),
              DashboardStatCard(
                label: 'Total Profit',
                value: _singkat(controller.totalProfit.value),
                icon: Icons.trending_up_rounded,
                color: AppTheme.success,
                subtitle: _rupiah(controller.totalProfit.value),
              ),
            ],
          )),
        ],
      ),
    );
  }

  String _rupiah(double v) => NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  String _singkat(double v) {
    if (v >= 1e9) return 'Rp ${(v / 1e9).toStringAsFixed(1)}M';
    if (v >= 1e6) return 'Rp ${(v / 1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return 'Rp ${(v / 1e3).toStringAsFixed(0)}Rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}

class _ShortcutSection extends StatelessWidget {
  final AdminDashboardController controller;
  const _ShortcutSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        0,
        AppTheme.spacingMd,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),
          const _SectionTitle('Menu Utama'),
          const SizedBox(height: 4),
          Obx(() => GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppTheme.spacingSm,
            mainAxisSpacing: AppTheme.spacingSm,
            childAspectRatio: 1.28,
            children: [
              ShortcutMenuItem(
                label: 'Kelola Mobil',
                icon: Icons.directions_car_rounded,
                color: AppTheme.primary,
                onTap: controller.keKelolaMobil,
              ),
              ShortcutMenuItem(
                label: 'Pengajuan Seller',
                icon: Icons.inbox_rounded,
                color: AppTheme.warning,
                onTap: controller.keKelolaPengajuan,
                badgeCount: controller.pengajuanMenunggu.value,
              ),
              ShortcutMenuItem(
                label: 'Transaksi',
                icon: Icons.point_of_sale_rounded,
                color: AppTheme.info,
                onTap: controller.keTransaksi,
              ),
              ShortcutMenuItem(
                label: 'Laporan',
                icon: Icons.bar_chart_rounded,
                color: AppTheme.success,
                onTap: controller.keLaporan,
              ),
            ],
          )),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }
}

// ── Transaksi Terbaru ─────────────────────────────────────────

class _TransaksiTerbaruSection extends StatelessWidget {
  final AdminDashboardController controller;
  const _TransaksiTerbaruSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionTitle('Transaksi Terbaru'),
              TextButton(
                onPressed: controller.keTransaksi,
                child:     const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Obx(() => controller.transaksiTerbaru.isEmpty
              ? _emptyTransaksi()
              : Column(
                  children: controller.transaksiTerbaru
                      .map((t) => _TransaksiTile(data: t))
                      .toList(),
                )),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }

  Widget _emptyTransaksi() => Container(
    width:   double.infinity,
    padding: const EdgeInsets.all(AppTheme.spacingLg),
    decoration: BoxDecoration(
      color:        Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
    ),
    child: Column(children: [
      Icon(Icons.receipt_long_outlined,
          size: 40, color: AppTheme.textHint.withOpacity(0.5)),
      const SizedBox(height: AppTheme.spacingSm),
      const Text('Belum ada transaksi',
          style: TextStyle(color: AppTheme.textHint, fontSize: 13)),
    ]),
  );
}

class _TransaksiTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TransaksiTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final mobil     = data['mobil'] as Map<String, dynamic>?;
    final namaMobil = mobil != null
        ? '${mobil['merek']} ${mobil['tipe_model']}' : 'Mobil';
    final pembeli   = data['nama_pembeli']    as String? ?? '-';
    final deal      = (data['harga_deal']  as num?)?.toDouble() ?? 0;
    final profit    = (data['profit']      as num?)?.toDouble() ?? 0;
    final tanggal   = data['tanggal_transaksi'] as String? ?? '';

    return Container(
      margin:  const EdgeInsets.only(bottom: AppTheme.spacingSm),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color:        AppTheme.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: const Icon(Icons.receipt_long_outlined,
              color: AppTheme.success, size: 22),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(namaMobil,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14,
                    color: AppTheme.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(pembeli,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary)),
            if (tanggal.isNotEmpty)
              Text(_fmt(tanggal),
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textHint)),
          ],
        )),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_singkat(deal),
              style: const TextStyle(fontWeight: FontWeight.w700,
                  fontSize: 14, color: AppTheme.primary)),
          Row(children: [
            const Icon(Icons.trending_up, size: 12, color: AppTheme.success),
            const SizedBox(width: 2),
            Text(_singkat(profit),
                style: const TextStyle(fontSize: 11,
                    color: AppTheme.success, fontWeight: FontWeight.w500)),
          ]),
        ]),
      ]),
    );
  }

  String _fmt(String raw) {
    try { return DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.parse(raw)); }
    catch (_) { return raw; }
  }

  String _singkat(double v) {
    if (v >= 1e9) return 'Rp ${(v/1e9).toStringAsFixed(1)}M';
    if (v >= 1e6) return 'Rp ${(v/1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return 'Rp ${(v/1e3).toStringAsFixed(0)}Rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}

// ── Status Showroom ───────────────────────────────────────────

class _StatusShowroomSection extends StatelessWidget {
  final AdminDashboardController controller;
  const _StatusShowroomSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Status Showroom'),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04),
                    blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Obx(() {
              final tersedia = controller.totalMobilTersedia.value;
              final total    = controller.totalMobil.value;
              final persen   = total > 0
                  ? (tersedia / total).clamp(0.0, 1.0) : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kapasitas Stok Tersedia',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppTheme.textPrimary)),
                      Text('$tersedia dari $total unit',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:           persen,
                      backgroundColor: AppTheme.divider,
                      color:           _barColor(persen),
                      minHeight:       10,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    '${(persen * 100).toStringAsFixed(0)}% unit tersedia',
                    style: TextStyle(fontSize: 12,
                        color: _barColor(persen),
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  const Divider(height: 1),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingXs),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(Icons.inbox_outlined,
                          color: AppTheme.warning, size: 20),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.pengajuanMenunggu.value} '
                          'pengajuan menunggu review',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.textPrimary)),
                        const Text('Segera tinjau pengajuan dari seller',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textHint)),
                      ],
                    )),
                    TextButton(
                      onPressed: controller.keKelolaPengajuan,
                      child: const Text('Review'),
                    ),
                  ]),
                ],
              );
            }),
          ),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }

  Color _barColor(double p) {
    if (p > 0.6) return AppTheme.success;
    if (p > 0.3) return AppTheme.warning;
    return AppTheme.error;
  }
}

// ── Shared ────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary));
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
    margin:  const EdgeInsets.all(AppTheme.spacingMd),
    padding: const EdgeInsets.all(AppTheme.spacingMd),
    decoration: BoxDecoration(
      color:        AppTheme.error.withOpacity(0.08),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      border:       Border.all(color: AppTheme.error.withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
      const SizedBox(width: AppTheme.spacingSm),
      Expanded(child: Text(message,
          style: const TextStyle(color: AppTheme.error, fontSize: 13))),
      TextButton(
        onPressed: onRetry,
        child: const Text('Coba Lagi',
            style: TextStyle(color: AppTheme.error)),
      ),
    ]),
  );
}