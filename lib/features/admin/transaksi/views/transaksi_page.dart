import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/admin/transaksi/controllers/transaksi_controller.dart';
import 'package:showroom_mobil/features/admin/transaksi/views/widgets/transaksi_tile.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransaksiController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                )
              : IconButton(
                  icon:      const Icon(Icons.refresh),
                  onPressed: controller.refresh,
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_transaksi',
        onPressed:       controller.keFormTransaksi,
        icon:            const Icon(Icons.add),
        label:           const Text('Buat Transaksi'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.transaksiList.isEmpty) {
          return const _LoadingState();
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.transaksiList.isEmpty) {
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


              SliverToBoxAdapter(
                child: _SummaryCard(controller: controller),
              ),


              if (controller.transaksiList.isEmpty)
                const SliverFillRemaining(child: _EmptyState())
              else


              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => TransaksiTile(
                    transaksi: controller.transaksiList[index],
                    onTap: () => controller.keDetailTransaksi(
                      controller.transaksiList[index],
                    ),
                  ),
                  childCount: controller.transaksiList.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        );
      }),
    );
  }
}



class _SummaryCard extends StatelessWidget {
  final TransaksiController controller;
  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total  = controller.transaksiList.length;
      final profit = controller.totalProfit;
      final fmt    = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
        child: Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Transaksi',
                  style: TextStyle(color: Colors.white70,
                      fontSize: 13)),
              Text('$total Transaksi',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )),
          Container(width: 1, height: 48, color: Colors.white24,
              margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd)),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Profit',
                  style: TextStyle(color: Colors.white70,
                      fontSize: 13)),
              Text(
                profit >= 1e6
                    ? 'Rp ${(profit/1e6).toStringAsFixed(1)}Jt'
                    : fmt.format(profit),
                style: const TextStyle(
                  color: Colors.white, fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(fmt.format(profit),
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 11)),
            ],
          )),
        ]),
      );
    });
  }
}



class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 3,
    padding:   const EdgeInsets.all(AppTheme.spacingMd),
    itemBuilder: (_, __) => Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child:  Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Grey(w: double.infinity, h: 16),
            const SizedBox(height: 8),
            _Grey(w: 160, h: 13),
            const SizedBox(height: 12),
            _Grey(w: double.infinity, h: 13),
          ],
        ),
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
    child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Icon(Icons.receipt_long_outlined, size: 80,
          color: AppTheme.primary.withOpacity(0.3)),
      const SizedBox(height: AppTheme.spacingMd),
      const Text('Belum Ada Transaksi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary)),
      const SizedBox(height: AppTheme.spacingSm),
      const Text('Tap tombol + untuk mencatat transaksi baru.',
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
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
      ]),
    ),
  );
}