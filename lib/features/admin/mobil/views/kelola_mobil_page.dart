import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/features/admin/mobil/controllers/kelola_mobil_controller.dart';
import 'package:showroom_mobil/features/admin/mobil/views/widgets/mobil_admin_card.dart';

class KelolaMobilPage extends StatelessWidget {
  const KelolaMobilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KelolaMobilController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Mobil'),
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon:      const Icon(Icons.refresh),
                  tooltip:   'Muat ulang',
                  onPressed: controller.refreshMobil,
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_mobil',
        onPressed:  controller.keHalamanTambah,
        icon:       const Icon(Icons.add),
        label:      const Text('Tambah Mobil'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────
        if (controller.isLoading.value && controller.mobilList.isEmpty) {
          return const _LoadingState();
        }

        // ── Error ────────────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty &&
            controller.mobilList.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.refreshMobil,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshMobil,
          color:     AppTheme.primary,
          child: CustomScrollView(
            slivers: [

              // ── Ringkasan ─────────────────────────────
              SliverToBoxAdapter(
                child: _RingkasanHeader(controller: controller),
              ),

              // ── Filter Chip ───────────────────────────
              SliverToBoxAdapter(
                child: _FilterBar(controller: controller),
              ),

              // ── Empty ─────────────────────────────────
              if (controller.filteredList.isEmpty)
                const SliverFillRemaining(
                  child: _EmptyState(),
                )
              else

              // ── List Mobil ────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final mobil = controller.filteredList[index];
                    return MobilAdminCard(
                      mobil:   mobil,
                      onEdit:  () => controller.keHalamanEdit(mobil),
                      onHapus: () => controller.hapusMobil(mobil),
                    );
                  },
                  childCount: controller.filteredList.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),  // ruang untuk FAB
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Ringkasan Header
// ════════════════════════════════════════════════════════════

class _RingkasanHeader extends StatelessWidget {
  final KelolaMobilController controller;
  const _RingkasanHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total    = controller.mobilList.length;
      final tersedia = controller.mobilList
          .where((m) => m.statusMobil == StatusMobil.tersedia).length;
      final terjual  = controller.mobilList
          .where((m) => m.statusMobil == StatusMobil.terjual).length;

      return Container(
        margin:  const EdgeInsets.all(AppTheme.spacingMd),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryLight],
            begin:  Alignment.topLeft,
            end:    Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Row(
          children: [
            _StatItem(label: 'Total',    value: '$total',    icon: Icons.directions_car),
            _Divider(),
            _StatItem(label: 'Tersedia', value: '$tersedia', icon: Icons.check_circle_outline),
            _Divider(),
            _StatItem(label: 'Terjual',  value: '$terjual',  icon: Icons.sell_outlined),
          ],
        ),
      );
    });
  }
}

class _StatItem extends StatelessWidget {
  final String   label;
  final String   value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                color: Colors.white, fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 48,
      color: Colors.white24,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Filter Bar
// ════════════════════════════════════════════════════════════

class _FilterBar extends StatelessWidget {
  final KelolaMobilController controller;
  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical:   AppTheme.spacingXs,
      ),
      child: Row(
        children: [
          _Chip(
            label:      'Semua (${controller.mobilList.length})',
            isSelected: controller.selectedFilterStatus.value == null,
            color:      AppTheme.primary,
            onTap:      () => controller.setFilter(null),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          ...StatusMobil.values.map((s) {
            final count = controller.mobilList
                .where((m) => m.statusMobil == s).length;
            return Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacingSm),
              child: _Chip(
                label:      '${s.label} ($count)',
                isSelected: controller.selectedFilterStatus.value == s,
                color:      s.color,
                onTap:      () => controller.setFilter(s),
              ),
            );
          }),
        ],
      ),
    ));
  }
}

class _Chip extends StatelessWidget {
  final String       label;
  final bool         isSelected;
  final Color        color;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical:   AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color:        isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border:       Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w500,
            color:      isSelected ? Colors.white : color,
          ),
        ),
      ),
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
      itemCount: 4,
      padding:   const EdgeInsets.all(AppTheme.spacingMd),
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
        child:  Row(
          children: [
            Container(
              width: 100, height: 100,
              color: AppTheme.divider,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Grey(w: double.infinity, h: 14),
                    const SizedBox(height: 8),
                    _Grey(w: 140, h: 12),
                    const SizedBox(height: 8),
                    _Grey(w: 100, h: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grey extends StatelessWidget {
  final double w, h;
  const _Grey({required this.w, required this.h});

  @override
  Widget build(BuildContext context) => Container(
    width: w, height: h,
    decoration: BoxDecoration(
      color:        AppTheme.divider,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined, size: 80,
              color: AppTheme.primary.withOpacity(0.3)),
          const SizedBox(height: AppTheme.spacingMd),
          const Text('Belum Ada Mobil',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              )),
          const SizedBox(height: AppTheme.spacingSm),
          const Text('Tap tombol + untuk menambahkan mobil baru.',
              style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String       message;
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
            Icon(Icons.wifi_off_rounded, size: 64,
                color: AppTheme.error.withOpacity(0.4)),
            const SizedBox(height: AppTheme.spacingMd),
            Text(message,
                style: const TextStyle(color: AppTheme.textSecondary),
                textAlign: TextAlign.center),
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