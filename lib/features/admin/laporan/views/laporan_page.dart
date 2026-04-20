import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/admin/laporan/controllers/laporan_controller.dart';
import 'package:showroom_mobil/features/admin/laporan/views/widgets/bar_chart_merek.dart';
import 'package:showroom_mobil/features/admin/laporan/views/widgets/laporan_summary_card.dart';
import 'package:showroom_mobil/features/admin/laporan/views/widgets/line_chart_profit.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaporanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(
            () => controller.isExporting.value
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.download_outlined),
                    tooltip: 'Export Excel',
                    onPressed: controller.exportExcel,
                  ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.refresh,
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.laporanBulanan.isEmpty) {
          return const _LoadingState();
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.laporanBulanan.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.refresh,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _FilterSection(controller: controller),
              ),
              SliverToBoxAdapter(
                child: _SummarySection(controller: controller),
              ),
              SliverToBoxAdapter(
                child: _ChartSection(
                  title: 'Merek Terlaris',
                  subtitle: 'Jumlah unit terjual per merek',
                  icon: Icons.bar_chart_outlined,
                  child: BarChartMerek(
                    data: controller.merekTerlaris,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _ChartSection(
                  title: 'Tren Profit',
                  subtitle: 'Profit per bulan dalam periode ini',
                  icon: Icons.show_chart_outlined,
                  child: LineChartProfit(
                    data: controller.laporanBulanan,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _TabelDetail(controller: controller),
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

// ── Filter Section ──
class _FilterSection extends StatelessWidget {
  final LaporanController controller;
  const _FilterSection({required this.controller});

  static const _namaBulan = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: controller.selectedTahun.value,
              decoration: const InputDecoration(
                labelText: 'Tahun',
                prefixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: controller.tahunList
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text('$t'),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) controller.setTahun(v);
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: DropdownButtonFormField<int?>(
              value: controller.selectedBulan.value,
              decoration: const InputDecoration(
                labelText: 'Bulan',
                prefixIcon: Icon(
                  Icons.date_range_outlined,
                  size: 18,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Semua'),
                ),
                ...List.generate(12, (i) => i + 1).map(
                  (b) => DropdownMenuItem<int?>(
                    value: b,
                    child: Text(_namaBulan[b]),
                  ),
                ),
              ],
              onChanged: controller.setBulan,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary Section ──
class _SummarySection extends StatelessWidget {
  final LaporanController controller;
  const _SummarySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final profit = controller.totalProfit;

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.labelPeriode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (controller.isLoading.value)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppTheme.spacingMd,
            mainAxisSpacing: AppTheme.spacingMd,
            childAspectRatio: 1.6,
            children: [
              LaporanSummaryCard(
                label: 'Total Transaksi',
                value: '${controller.totalTransaksi} Transaksi',
                icon: Icons.receipt_long_outlined,
                color: AppTheme.primary,
              ),
              LaporanSummaryCard(
                label: 'Mobil Terjual',
                value: '${controller.totalMobilTerjual} Unit',
                icon: Icons.directions_car_rounded,
                color: AppTheme.info,
              ),
              LaporanSummaryCard(
                label: 'Total Penjualan',
                value: _singkat(controller.totalPenjualan),
                subtitle: fmt.format(controller.totalPenjualan),
                icon: Icons.attach_money_outlined,
                color: AppTheme.primaryLight,
              ),
              LaporanSummaryCard(
                label: 'Total Profit',
                value: _singkat(profit),
                subtitle: fmt.format(profit),
                icon: Icons.trending_up_rounded,
                color: profit >= 0 ? AppTheme.success : AppTheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _singkat(double v) {
    if (v >= 1e9) return 'Rp ${(v / 1e9).toStringAsFixed(1)}M';
    if (v >= 1e6) return 'Rp ${(v / 1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return 'Rp ${(v / 1e3).toStringAsFixed(0)}Rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}

// ── Chart Section ──
class _ChartSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _ChartSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: AppTheme.spacingXs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(height: 1),
          const SizedBox(height: AppTheme.spacingMd),
          child,
        ],
      ),
    );
  }
}

// ── Tabel Detail Section ──
class _TabelDetail extends StatelessWidget {
  final LaporanController controller;
  const _TabelDetail({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.laporanBulanan.isEmpty) {
      return const SizedBox.shrink();
    }

    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: const [
                Icon(
                  Icons.table_chart_outlined,
                  color: AppTheme.primary,
                  size: 20,
                ),
                SizedBox(width: AppTheme.spacingXs),
                Text(
                  'Detail Per Bulan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _TabelHeaderRow(),
          const Divider(height: 1),
          ...controller.laporanBulanan.asMap().entries.map(
            (entry) => Column(
              children: [
                _TabelDataRow(
                  item: entry.value,
                  isAlternate: entry.key % 2 == 1,
                  fmt: fmt,
                ),
                if (entry.key < controller.laporanBulanan.length - 1)
                  const Divider(height: 1),
              ],
            ),
          ),
          const Divider(height: 1),
          _TabelTotalRow(
            totalTransaksi: controller.totalTransaksi,
            totalMobil: controller.totalMobilTerjual,
            totalPenjualan: controller.totalPenjualan,
            totalProfit: controller.totalProfit,
            fmt: fmt,
          ),
        ],
      ),
    );
  }
}

class _TabelHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: 10,
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Bulan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Trx',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Unit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Profit',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabelDataRow extends StatelessWidget {
  final dynamic item;
  final bool isAlternate;
  final NumberFormat fmt;

  const _TabelDataRow({
    required this.item,
    required this.isAlternate,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isAlternate
          ? AppTheme.background.withOpacity(0.5)
          : Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${item.namaBulan} ${item.tahun}',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${item.jumlahTransaksi}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${item.jumlahMobilTerjual}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _singkat(item.totalProfit.toDouble()),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: item.totalProfit >= 0
                    ? AppTheme.success
                    : AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _singkat(double v) {
    if (v >= 1e6) return 'Rp ${(v / 1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return 'Rp ${(v / 1e3).toStringAsFixed(0)}Rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}

class _TabelTotalRow extends StatelessWidget {
  final int totalTransaksi;
  final int totalMobil;
  final double totalPenjualan;
  final double totalProfit;
  final NumberFormat fmt;

  const _TabelTotalRow({
    required this.totalTransaksi,
    required this.totalMobil,
    required this.totalPenjualan,
    required this.totalProfit,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.06),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: 10,
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'TOTAL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$totalTransaksi',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$totalMobil',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _singkat(totalProfit),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: totalProfit >= 0
                    ? AppTheme.success
                    : AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _singkat(double v) {
    if (v >= 1e6) return 'Rp ${(v / 1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return 'Rp ${(v / 1e3).toStringAsFixed(0)}Rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }
}

// ── Loading & Error State ──

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppTheme.spacingMd),
          Text(
            'Memuat laporan...',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

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
              size: 64,
              color: AppTheme.error.withOpacity(0.4),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}