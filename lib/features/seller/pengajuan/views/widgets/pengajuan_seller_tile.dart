import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class PengajuanSellerTile extends StatelessWidget {
  final PengajuanModel pengajuan;
  final VoidCallback? onTap;

  const PengajuanSellerTile({
    super.key,
    required this.pengajuan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical:   AppTheme.spacingXs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Foto Mobil ────────────────────────────────
              _FotoMobil(fotoUrl: pengajuan.fotoMobil),
              const SizedBox(width: AppTheme.spacingMd),

              // ── Info Utama ────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Baris 1: nama mobil + badge status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${pengajuan.merek} ${pengajuan.tipeModel}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:   15,
                              color:      AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        _StatusBadge(status: pengajuan.statusPengajuan),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Tahun & Transmisi
                    Text(
                      '${pengajuan.tahun} · ${pengajuan.transmisi.label}',
                      style: const TextStyle(
                        fontSize: 13,
                        color:    AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Harga yang diinginkan
                    Text(
                      _formatRupiah(pengajuan.hargaDiinginkan),
                      style: const TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Tanggal pengajuan
                    Text(
                      'Diajukan ${_formatTanggal(pengajuan.dibuatPada)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color:    AppTheme.textHint,
                      ),
                    ),

                    // Catatan admin (tampil hanya jika ada)
                    if (pengajuan.catatanAdmin != null &&
                        pengajuan.catatanAdmin!.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacingSm),
                      _CatatanAdmin(catatan: pengajuan.catatanAdmin!),
                    ],
                  ],
                ),
              ),

              // Chevron
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textHint,
                size:  20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRupiah(double angka) {
    return NumberFormat.currency(
      locale:        'id_ID',
      symbol:        'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  String _formatTanggal(DateTime dt) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
  }
}

// ── Sub-widget: Foto ─────────────────────────────────────────

class _FotoMobil extends StatelessWidget {
  final String? fotoUrl;
  const _FotoMobil({this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: SizedBox(
        width:  72,
        height: 72,
        child: fotoUrl != null
            ? CachedNetworkImage(
                imageUrl:   fotoUrl!,
                fit:        BoxFit.cover,
                placeholder: (_, __) => const _FotoPlaceholder(),
                errorWidget: (_, __, ___) => const _FotoPlaceholder(),
              )
            : const _FotoPlaceholder(),
      ),
    );
  }
}

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.06),
      child: const Icon(
        Icons.directions_car_outlined,
        color: AppTheme.primary,
        size:  32,
      ),
    );
  }
}

// ── Sub-widget: Status Badge ─────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final StatusPengajuan status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical:   3,
      ),
      decoration: BoxDecoration(
        color:        status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border:       Border.all(color: status.color.withOpacity(0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize:   11,
          fontWeight: FontWeight.w600,
          color:      status.color,
        ),
      ),
    );
  }
}

// ── Sub-widget: Catatan Admin ────────────────────────────────

class _CatatanAdmin extends StatelessWidget {
  final String catatan;
  const _CatatanAdmin({required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSm),
      decoration: BoxDecoration(
        color:        AppTheme.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border:       Border.all(color: AppTheme.info.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            size:  14,
            color: AppTheme.info,
          ),
          const SizedBox(width: AppTheme.spacingXs),
          Expanded(
            child: Text(
              catatan,
              style: const TextStyle(
                fontSize: 12,
                color:    AppTheme.info,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}