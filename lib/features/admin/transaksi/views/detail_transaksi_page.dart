import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/admin/transaksi/controllers/transaksi_controller.dart';
import 'package:showroom_mobil/shared/models/transaksi_model.dart';

class DetailTransaksiPage extends StatelessWidget {
  const DetailTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransaksiController>();
    final transaksi = Get.arguments as TransaksiModel;

    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          children: [
            _SectionCard(
              title: 'Informasi Mobil',
              children: [
                _DetailRow(
                  label: 'Mobil',
                  value: transaksi.mobil != null
                      ? '${transaksi.mobil!.merek} ${transaksi.mobil!.tipeModel}'
                      : '-',
                ),
                _DetailRow(
                  label: 'Tahun',
                  value: transaksi.mobil?.tahun.toString() ?? '-',
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _SectionCard(
              title: 'Informasi Pembeli',
              children: [
                _DetailRow(
                  label: 'Nama Pembeli',
                  value: transaksi.namaPembeli,
                ),
                _DetailRow(
                  label: 'Nomor Pembeli',
                  value: transaksi.nomorPembeli,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _SectionCard(
              title: 'Rincian Harga',
              children: [
                _DetailRow(
                  label: 'Harga Modal',
                  value: fmt.format(transaksi.hargaModal),
                ),
                _DetailRow(
                  label: 'Harga Jual',
                  value: fmt.format(transaksi.hargaJual),
                ),
                _DetailRow(
                  label: 'Harga Deal',
                  value: fmt.format(transaksi.hargaDeal),
                ),
                _DetailRow(
                  label: 'Profit',
                  value: fmt.format(transaksi.profit),
                  valueColor: transaksi.profit >= 0
                      ? AppTheme.success
                      : AppTheme.error,
                  isBold: true,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _SectionCard(
              title: 'Informasi Transaksi',
              children: [
                _DetailRow(
                  label: 'Tanggal',
                  value: DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(transaksi.tanggalTransaksi),
                ),
                _DetailRow(
                  label: 'Nota',
                  value: transaksi.notaTransaksi != null
                      ? 'Tersedia'
                      : 'Tidak tersedia',
                ),
                if (transaksi.notaTransaksi != null) ...[
                  const SizedBox(height: AppTheme.spacingSm),
                  OutlinedButton.icon(
                    onPressed: () => _bukaNota(transaksi.notaTransaksi!),
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text('Lihat Nota'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppTheme.spacingXl),
            ElevatedButton.icon(
              onPressed: () => controller.hapusTransaksi(transaksi),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Transaksi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bukaNota(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: valueColor ?? AppTheme.textPrimary,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}