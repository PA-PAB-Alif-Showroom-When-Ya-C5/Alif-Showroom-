import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/features/seller/pengajuan/controllers/pengajuan_controller.dart';
import 'package:showroom_mobil/features/seller/pengajuan/views/widgets/pengajuan_seller_tile.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';

class RiwayatPengajuanPage extends StatelessWidget {
  const RiwayatPengajuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PengajuanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengajuan'),
        actions: [
          // Tombol refresh manual
          Obx(() => controller.isLoadingList.value
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width:  20,
                    height: 20,
                    child:  CircularProgressIndicator(
                      strokeWidth: 2,
                      color:       Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon:     const Icon(Icons.refresh),
                  tooltip:  'Muat ulang',
                  onPressed: controller.refreshPengajuan,
                )),
        ],
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────
        if (controller.isLoadingList.value &&
            controller.pengajuanList.isEmpty) {
          return const _LoadingState();
        }

        // ── Error ────────────────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty &&
            controller.pengajuanList.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.refreshPengajuan,
          );
        }

        // ── Empty ────────────────────────────────────────────
        if (controller.pengajuanList.isEmpty) {
          return const _EmptyState();
        }

        // ── Data ─────────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: controller.refreshPengajuan,
          color:     AppTheme.primary,
          child: CustomScrollView(
            slivers: [

              // Ringkasan statistik di atas list
              SliverToBoxAdapter(
                child: _StatisticHeader(
                  semua:    controller.pengajuanList,
                ),
              ),

              // Filter chip status
              SliverToBoxAdapter(
                child: _FilterChips(controller: controller),
              ),

              // List pengajuan
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = controller.filteredList[index];
                    return PengajuanSellerTile(
                      pengajuan: item,
                      onTap: () => _onTapItem(item),
                    );
                  },
                  childCount: controller.filteredList.length,
                ),
              ),

              // Padding bawah agar tidak tertutup bottom nav
              const SliverToBoxAdapter(
                child: SizedBox(height: AppTheme.spacingXl),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onTapItem(PengajuanModel item) {
    Get.toNamed(
      AppRoutes.detailPengajuanSeller,
      arguments: item,   // kirim object langsung, tanpa query ulang
    );
  }
}

// ════════════════════════════════════════════════════════════
// State Widgets
// ════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemBuilder: (_, __) => const _ShimmerTile(),
    );
  }
}

// Shimmer loading tile — tidak perlu package shimmer eksternal
class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(
          children: [
            // Foto placeholder
            Container(
              width:  72,
              height: 72,
              decoration: BoxDecoration(
                color:        AppTheme.divider,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Teks placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreyBox(width: double.infinity, height: 14),
                  const SizedBox(height: 8),
                  _GreyBox(width: 120, height: 12),
                  const SizedBox(height: 8),
                  _GreyBox(width: 90,  height: 12),
                  const SizedBox(height: 8),
                  _GreyBox(width: 150, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreyBox extends StatelessWidget {
  final double width;
  final double height;
  const _GreyBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  width,
      height: height,
      decoration: BoxDecoration(
        color:        AppTheme.divider,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size:  80,
              color: AppTheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Text(
              'Belum Ada Pengajuan',
              style: TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.w600,
                color:      AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            const Text(
              'Pengajuan mobil yang kamu kirim\nakan muncul di sini.',
              style: TextStyle(
                color:   AppTheme.textSecondary,
                height:  1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size:  64,
              color: AppTheme.error.withOpacity(0.4),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.w600,
                color:      AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon:      const Icon(Icons.refresh),
              label:     const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Statistik Header
// ════════════════════════════════════════════════════════════

class _StatisticHeader extends StatelessWidget {
  final List<PengajuanModel> semua;
  const _StatisticHeader({required this.semua});

  @override
  Widget build(BuildContext context) {
    // Hitung per status dari list yang sudah ada — tanpa query tambahan
    final menunggu = semua.where(
      (e) => e.statusPengajuan == StatusPengajuan.menunggu).length;
    final diproses = semua.where(
      (e) => e.statusPengajuan == StatusPengajuan.diproses).length;
    final diterima = semua.where(
      (e) => e.statusPengajuan == StatusPengajuan.diterima).length;
    final ditolak  = semua.where(
      (e) => e.statusPengajuan == StatusPengajuan.ditolak).length;

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color:        AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total ${semua.length} Pengajuan',
            style: const TextStyle(
              color:      Colors.white,
              fontSize:   16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              _StatChip(
                label: 'Menunggu',
                count: menunggu,
                color: AppTheme.statusMenunggu,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatChip(
                label: 'Diproses',
                count: diproses,
                color: AppTheme.statusDiproses,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatChip(
                label: 'Diterima',
                count: diterima,
                color: AppTheme.statusDiterima,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              _StatChip(
                label: 'Ditolak',
                count: ditolak,
                color: AppTheme.statusDitolak,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int    count;
  final Color  color;
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
        decoration: BoxDecoration(
          color:        Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color:      color,
                fontSize:   18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color:    Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Filter Chips
// ════════════════════════════════════════════════════════════

class _FilterChips extends StatelessWidget {
  final PengajuanController controller;
  const _FilterChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical:   AppTheme.spacingSm,
      ),
      child: Obx(() {
        return Row(
          children: [
            // Chip "Semua"
            _FilterChip(
              label:      'Semua',
              isSelected: controller.selectedFilter.value == null,
              onTap:      () => controller.setFilter(null),
            ),
            const SizedBox(width: AppTheme.spacingSm),

            // Chip per status
            ...StatusPengajuan.values.map((status) => Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacingSm),
              child: _FilterChip(
                label:      status.label,
                isSelected:
                    controller.selectedFilter.value == status,
                color:      status.color,
                onTap:      () => controller.setFilter(status),
              ),
            )),
          ],
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String    label;
  final bool      isSelected;
  final Color?    color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppTheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical:   AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : activeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected
                ? activeColor
                : activeColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : activeColor,
          ),
        ),
      ),
    );
  }
}