import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/shared/models/transaksi_model.dart';

class TransaksiTile extends StatelessWidget {
  final TransaksiModel transaksi;
  final VoidCallback onTap;

  const TransaksiTile({
    super.key,
    required this.transaksi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final namaMobil = transaksi.mobil != null
        ? '${transaksi.mobil!.merek} ${transaksi.mobil!.tipeModel}'
        : 'Mobil';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Baris 1: Nama mobil + tanggal ───────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      namaMobil,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    _formatTanggal(transaksi.tanggalTransaksi),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXs),

              // ── Baris 2: Nama pembeli ────────────────────
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      transaksi.namaPembeli,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (transaksi.notaTransaksi != null) ...[
                    const SizedBox(width: AppTheme.spacingSm),
                    const Icon(
                      Icons.receipt_outlined,
                      size: 14,
                      color: AppTheme.info,
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      'Ada nota',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.info,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              Wrap(
                spacing: AppTheme.spacingSm,
                runSpacing: AppTheme.spacingSm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _HargaItem(
                    label: 'Harga Deal',
                    value: _fmtRupiah(transaksi.hargaDeal),
                    color: AppTheme.primary,
                    isBold: true,
                  ),
                  _HargaItem(
                    label: 'Modal',
                    value: _fmtRupiah(transaksi.hargaModal),
                    color: AppTheme.textSecondary,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                        color: AppTheme.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 14,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _fmtRupiah(transaksi.profit),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXs),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right,
                  color: AppTheme.textHint,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTanggal(DateTime dt) =>
      DateFormat('dd MMM yyyy', 'id_ID').format(dt);

  String _fmtRupiah(double v) => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(v);
}

class _HargaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _HargaItem({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textHint,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      );
}