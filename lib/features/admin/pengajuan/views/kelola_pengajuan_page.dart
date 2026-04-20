import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/features/admin/pengajuan/controllers/kelola_pengajuan_controller.dart';
import 'package:showroom_mobil/features/admin/pengajuan/views/widgets/pengajuan_admin_tile.dart';

class KelolaPengajuanPage extends StatelessWidget {
  const KelolaPengajuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KelolaPengajuanController>();

    return Scaffold(
      appBar: AppBar(
        title:                 const Text('Kelola Pengajuan'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child:   SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                )
              : IconButton(
                  icon:      const Icon(Icons.refresh),
                  tooltip:   'Muat ulang',
                  onPressed: controller.refresh,
                )),
        ],
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────
        if (controller.isLoading.value &&
            controller.pengajuanList.isEmpty) {
          return const _LoadingState();
        }

        // ── Error ────────────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty &&
            controller.pengajuanList.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color:     AppTheme.primary,
          child: CustomScrollView(
            slivers: [

              // ── Header statistik ─────────────────────
              SliverToBoxAdapter(
                child: _StatHeader(controller: controller),
              ),

              // ── Filter chips ──────────────────────────
              SliverToBoxAdapter(
                child: _FilterBar(controller: controller),
              ),

              // ── Empty ─────────────────────────────────
              if (controller.filteredList.isEmpty)
                const SliverFillRemaining(child: _EmptyState())
              else

              // ── List ──────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final item = controller.filteredList[index];
                    return PengajuanAdminTile(
                      pengajuan: item,
                      onTap:     () => controller.bukaDetail(item),
                    );
                  },
                  childCount: controller.filteredList.length,
                ),
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

// ── Stat Header ───────────────────────────────────────────────

class _StatHeader extends StatelessWidget {
  final KelolaPengajuanController controller;
  const _StatHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total ${controller.pengajuanList.length} Pengajuan',
            style: const TextStyle(
              color:      Colors.white,
              fontSize:   16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: StatusPengajuan.values.map((s) {
              final count = controller.countByStatus(s);
              return Expanded(
                child: _StatChip(
                  label: s.label,
                  count: count,
                  color: s.color,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ));
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
  Widget build(BuildContext context) => Container(
    margin:  const EdgeInsets.only(right: 6),
    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
    decoration: BoxDecoration(
      color:        Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
    ),
    child: Column(children: [
      Text('$count',
          style: TextStyle(
            color: color, fontSize: 18, fontWeight: FontWeight.bold,
          )),
      const SizedBox(height: 2),
      Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 9)),
    ]),
  );
}

// ── Filter Bar ────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final KelolaPengajuanController controller;
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
          _FilterChip(
            label:      'Semua',
            isSelected: controller.selectedFilter.value == null,
            color:      AppTheme.primary,
            onTap:      () => controller.setFilter(null),
          ),
          const SizedBox(width: AppTheme.spacingXs),
          ...StatusPengajuan.values.map((s) => Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingXs),
            child: _FilterChip(
              label:      s.label,
              isSelected: controller.selectedFilter.value == s,
              color:      s.color,
              onTap:      () => controller.setFilter(s),
            ),
          )),
        ],
      ),
    ));
  }
}

class _FilterChip extends StatelessWidget {
  final String       label;
  final bool         isSelected;
  final Color        color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingXs),
      decoration: BoxDecoration(
        color:        isSelected ? color : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border:       Border.all(
            color: isSelected ? color : color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize:   13,
            fontWeight: FontWeight.w500,
            color:      isSelected ? Colors.white : color,
          )),
    ),
  );
}

// ── State Widgets ─────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 4,
    padding:   const EdgeInsets.all(AppTheme.spacingMd),
    itemBuilder: (_, __) => Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child:  Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Row(children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Grey(w: double.infinity, h: 14),
              const SizedBox(height: 8),
              _Grey(w: 140, h: 12),
              const SizedBox(height: 8),
              _Grey(w: 100, h: 12),
            ],
          )),
        ]),
      ),
    ),
  );
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
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.inbox_outlined, size: 80,
          color: AppTheme.primary.withOpacity(0.3)),
      const SizedBox(height: AppTheme.spacingMd),
      const Text('Belum Ada Pengajuan',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary)),
      const SizedBox(height: AppTheme.spacingSm),
      const Text('Pengajuan dari seller akan muncul di sini.',
          style: TextStyle(color: AppTheme.textSecondary)),
    ]),
  );
}

class _ErrorState extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      ]),
    ),
  );
}