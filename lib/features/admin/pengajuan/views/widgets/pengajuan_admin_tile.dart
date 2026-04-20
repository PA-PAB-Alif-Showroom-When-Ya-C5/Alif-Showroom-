import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';

class PengajuanAdminTile extends StatelessWidget {
  final PengajuanModel pengajuan;
  final VoidCallback   onTap;

  const PengajuanAdminTile({
    super.key,
    required this.pengajuan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical:   AppTheme.spacingXs,
      ),
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Foto ────────────────────────────────────
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusSm),
                child: SizedBox(
                  width:  72,
                  height: 72,
                  child:  pengajuan.fotoMobil != null
                      ? CachedNetworkImage(
                          imageUrl:    pengajuan.fotoMobil!,
                          fit:         BoxFit.cover,
                          placeholder: (_, __) =>
                              const _FotoPlaceholder(),
                          errorWidget: (_, __, ___) =>
                              const _FotoPlaceholder(),
                        )
                      : const _FotoPlaceholder(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // ── Info ─────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Nama + badge status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${pengajuan.merek} ${pengajuan.tipeModel}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:   14,
                              color:      AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingXs),
                        _StatusBadge(
                            status: pengajuan.statusPengajuan),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Tahun & transmisi
                    Text(
                      '${pengajuan.tahun} · '
                      '${pengajuan.transmisi.label} · '
                      '${pengajuan.bahanBakar.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        color:    AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Harga
                    Text(
                      _formatRupiah(pengajuan.hargaDiinginkan),
                      style: const TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w700,
                        color:      AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Tanggal & catatan
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,
                            size: 12, color: AppTheme.textHint),
                        const SizedBox(width: 4),
                        Text(
                          _formatTanggal(pengajuan.dibuatPada),
                          style: const TextStyle(
                            fontSize: 11,
                            color:    AppTheme.textHint,
                          ),
                        ),
                        if (pengajuan.catatanAdmin != null &&
                            pengajuan.catatanAdmin!.isNotEmpty) ...[
                          const SizedBox(width: AppTheme.spacingSm),
                          const Icon(Icons.comment_outlined,
                              size: 12, color: AppTheme.info),
                          const SizedBox(width: 2),
                          const Text('Ada catatan',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:    AppTheme.info)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right,
                  color: AppTheme.textHint, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRupiah(double v) => NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  String _formatTanggal(DateTime dt) =>
      DateFormat('dd MMM yyyy', 'id_ID').format(dt);
}

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    color: AppTheme.primary.withOpacity(0.06),
    child: const Icon(Icons.directions_car_outlined,
        color: AppTheme.primary, size: 32),
  );
}

class _StatusBadge extends StatelessWidget {
  final StatusPengajuan status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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