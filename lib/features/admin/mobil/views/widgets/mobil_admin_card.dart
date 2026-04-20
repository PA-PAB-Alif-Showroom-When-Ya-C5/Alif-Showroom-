// lib/features/admin/mobil/views/widgets/mobil_admin_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';  

class MobilAdminCard extends StatelessWidget {
  final MobilModel   mobil;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  const MobilAdminCard({
    super.key,
    required this.mobil,
    required this.onEdit,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical:   AppTheme.spacingXs,
      ),
      child: Column(
        children: [
          // ── Foto + Info ─────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft:     Radius.circular(AppTheme.radiusMd),
                  bottomLeft:  Radius.circular(AppTheme.radiusMd),
                ),
                child: SizedBox(
                  width:  100,
                  height: 100,
                  child:  mobil.fotoMobil != null
                      ? CachedNetworkImage(
                          imageUrl:    mobil.fotoMobil!,
                          fit:         BoxFit.cover,
                          placeholder: (_, __) => const _FotoPlaceholder(),
                          errorWidget: (_, __, ___) =>
                              const _FotoPlaceholder(),
                        )
                      : const _FotoPlaceholder(),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris nama + status badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${mobil.merek} ${mobil.tipeModel}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize:   15,
                                color:      AppTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingXs),
                          _StatusBadge(status: mobil.statusMobil),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXs),

                      // Tahun & transmisi
                      Text(
                        '${mobil.tahun} · ${mobil.transmisi.label} '
                        '· ${mobil.bahanBakar.label}',
                        style: const TextStyle(
                          fontSize: 12,
                          color:    AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXs),

                      // Harga
                      Text(
                        _formatRupiah(mobil.harga),
                        style: const TextStyle(
                          fontSize:   15,
                          fontWeight: FontWeight.w700,
                          color:      AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXs),

                      // Jarak tempuh & warna
                      Text(
                        '${_formatJarak(mobil.jarakTempuh)} · ${mobil.warna}',
                        style: const TextStyle(
                          fontSize: 12,
                          color:    AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Divider + Aksi ───────────────────────────────
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical:   AppTheme.spacingXs,
            ),
            child: Row(
              children: [
                // Status STNK
                Icon(
                  Icons.assignment_outlined,
                  size:  14,
                  color: AppTheme.textHint,
                ),
                const SizedBox(width: 4),
                Text(
                  'STNK: ${mobil.statusStnk.label}',
                  style: const TextStyle(
                    fontSize: 12,
                    color:    AppTheme.textHint,
                  ),
                ),

                const Spacer(),

                // Tombol Edit
                TextButton.icon(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical:   AppTheme.spacingXs,
                    ),
                    minimumSize: Size.zero,
                  ),
                  icon:  const Icon(Icons.edit_outlined, size: 16),
                  label: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 13),
                  ),
                ),

                // Tombol Hapus
                TextButton.icon(
                  onPressed: onHapus,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical:   AppTheme.spacingXs,
                    ),
                    minimumSize: Size.zero,
                  ),
                  icon:  const Icon(Icons.delete_outline, size: 16),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(double angka) => NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(angka);

  String _formatJarak(int km) =>
      '${NumberFormat('#,###', 'id_ID').format(km)} km';
}

// ── Sub-widget ────────────────────────────────────────────────

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.06),
      child: const Icon(
        Icons.directions_car_outlined,
        color: AppTheme.primary,
        size:  36,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StatusMobil status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
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
}