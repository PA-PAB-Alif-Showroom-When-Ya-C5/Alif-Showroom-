import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';

class DetailPengajuanSellerPage extends StatelessWidget {
  const DetailPengajuanSellerPage({super.key});

  // Data diterima dari arguments, tidak perlu controller baru
  PengajuanModel get pengajuan => Get.arguments as PengajuanModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [

          // ── App Bar dengan foto sebagai background ────────
          _SliverHeader(pengajuan: pengajuan),

          // ── Konten detail ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Nama mobil + status
                  _HeaderInfo(pengajuan: pengajuan),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Status pengajuan (card berwarna)
                  _StatusCard(status: pengajuan.statusPengajuan),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Catatan admin
                  _CatatanAdminCard(catatan: pengajuan.catatanAdmin),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Spesifikasi kendaraan
                  _SectionCard(
                    title: 'Spesifikasi Kendaraan',
                    icon:  Icons.directions_car_outlined,
                    rows: [
                      _InfoRow('Merek',         pengajuan.merek),
                      _InfoRow('Tipe / Model',  pengajuan.tipeModel),
                      _InfoRow('Tahun',         '${pengajuan.tahun}'),
                      _InfoRow('Transmisi',     pengajuan.transmisi.label),
                      _InfoRow('Bahan Bakar',   pengajuan.bahanBakar.label),
                      _InfoRow('Jarak Tempuh',
                          _formatJarak(pengajuan.jarakTempuh)),
                      _InfoRow('Status STNK',   pengajuan.statusStnk.label),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Harga & kontak
                  _SectionCard(
                    title: 'Harga & Kontak',
                    icon:  Icons.attach_money_outlined,
                    rows: [
                      _InfoRow('Harga Diinginkan',
                          _formatRupiah(pengajuan.hargaDiinginkan)),
                      _InfoRow('Nomor WhatsApp',
                          pengajuan.nomorWhatsapp),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Deskripsi kondisi
                  _DeskripsiCard(deskripsi: pengajuan.deskripsiKondisi),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Timestamp
                  _TimestampCard(pengajuan: pengajuan),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Formatter ─────────────────────────────────────────────

  String _formatRupiah(double angka) {
    return NumberFormat.currency(
      locale:        'id_ID',
      symbol:        'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  String _formatJarak(int km) {
    return NumberFormat('#,###', 'id_ID').format(km) + ' km';
  }
}

// ════════════════════════════════════════════════════════════
// Sliver Header — foto mobil sebagai hero image
// ════════════════════════════════════════════════════════════

class _SliverHeader extends StatelessWidget {
  final PengajuanModel pengajuan;
  const _SliverHeader({required this.pengajuan});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight:  260,
      pinned:          true,
      backgroundColor: AppTheme.primary,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.black38,
          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _FotoHeader(fotoUrl: pengajuan.fotoMobil),
      ),
    );
  }
}

class _FotoHeader extends StatelessWidget {
  final String? fotoUrl;
  const _FotoHeader({this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    if (fotoUrl != null && fotoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl:    fotoUrl!,
        fit:         BoxFit.cover,
        placeholder: (_, __) => const _FotoPlaceholder(),
        errorWidget: (_, __, ___) => const _FotoPlaceholder(),
      );
    }
    return const _FotoPlaceholder();
  }
}

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size:  72,
            color: AppTheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Foto tidak tersedia',
            style: TextStyle(
              color:    AppTheme.textSecondary.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Header Info — nama mobil + badge status
// ════════════════════════════════════════════════════════════

class _HeaderInfo extends StatelessWidget {
  final PengajuanModel pengajuan;
  const _HeaderInfo({required this.pengajuan});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${pengajuan.merek} ${pengajuan.tipeModel}',
                style: const TextStyle(
                  fontSize:   22,
                  fontWeight: FontWeight.bold,
                  color:      AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                '${pengajuan.tahun} · ${pengajuan.transmisi.label}',
                style: const TextStyle(
                  fontSize: 14,
                  color:    AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// Status Card — tampilan besar status pengajuan
// ════════════════════════════════════════════════════════════

class _StatusCard extends StatelessWidget {
  final StatusPengajuan status;
  const _StatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color:        status.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border:       Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(_statusIcon(status), color: status.color, size: 28),
          const SizedBox(width: AppTheme.spacingMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Pengajuan',
                style: TextStyle(
                  fontSize: 12,
                  color:    AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status.label,
                style: TextStyle(
                  fontSize:   18,
                  fontWeight: FontWeight.bold,
                  color:      status.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(StatusPengajuan s) {
    switch (s) {
      case StatusPengajuan.menunggu:  return Icons.schedule_outlined;
      case StatusPengajuan.diproses:  return Icons.sync_outlined;
      case StatusPengajuan.diterima:  return Icons.check_circle_outline;
      case StatusPengajuan.ditolak:   return Icons.cancel_outlined;
    }
  }
}

// ════════════════════════════════════════════════════════════
// Catatan Admin Card
// ════════════════════════════════════════════════════════════

class _CatatanAdminCard extends StatelessWidget {
  final String? catatan;
  const _CatatanAdminCard({this.catatan});

  bool get _adaCatatan =>
      catatan != null && catatan!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: _adaCatatan
            ? AppTheme.info.withOpacity(0.07)
            : AppTheme.divider.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: _adaCatatan
              ? AppTheme.info.withOpacity(0.3)
              : AppTheme.divider,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            size:  20,
            color: _adaCatatan ? AppTheme.info : AppTheme.textHint,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Admin',
                  style: TextStyle(
                    fontSize:   12,
                    fontWeight: FontWeight.w600,
                    color:      _adaCatatan
                        ? AppTheme.info
                        : AppTheme.textHint,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  _adaCatatan
                      ? catatan!
                      : 'Belum ada catatan dari admin.',
                  style: TextStyle(
                    fontSize: 14,
                    color:    _adaCatatan
                        ? AppTheme.textPrimary
                        : AppTheme.textHint,
                    fontStyle: _adaCatatan
                        ? FontStyle.normal
                        : FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Section Card — wrapper untuk grup info
// ════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String       title;
  final IconData     icon;
  final List<_InfoRow> rows;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Section title
            Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.primary),
                const SizedBox(width: AppTheme.spacingXs),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                    color:      AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spacingSm),

            // Rows
            ...rows.map((row) => _buildRow(row)),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(_InfoRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              row.label,
              style: const TextStyle(
                fontSize: 13,
                color:    AppTheme.textSecondary,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          Expanded(
            child: Text(
              row.value,
              style: const TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w500,
                color:      AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data class sederhana untuk satu baris info
class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}

// ════════════════════════════════════════════════════════════
// Deskripsi Kondisi Card
// ════════════════════════════════════════════════════════════

class _DeskripsiCard extends StatelessWidget {
  final String deskripsi;
  const _DeskripsiCard({required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description_outlined,
                    size: 18, color: AppTheme.primary),
                SizedBox(width: AppTheme.spacingXs),
                Text(
                  'Deskripsi Kondisi',
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                    color:      AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 14,
                color:    AppTheme.textPrimary,
                height:   1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Timestamp Card
// ════════════════════════════════════════════════════════════

class _TimestampCard extends StatelessWidget {
  final PengajuanModel pengajuan;
  const _TimestampCard({required this.pengajuan});

  String _format(DateTime dt) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color:        AppTheme.divider.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          _TimestampRow(
            label: 'Diajukan pada',
            value: _format(pengajuan.dibuatPada),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          _TimestampRow(
            label: 'Terakhir diperbarui',
            value: _format(pengajuan.diupdatePada),
          ),
        ],
      ),
    );
  }
}

class _TimestampRow extends StatelessWidget {
  final String label;
  final String value;
  const _TimestampRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_outlined,
          size:  14,
          color: AppTheme.textHint,
        ),
        const SizedBox(width: AppTheme.spacingXs),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color:    AppTheme.textHint,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color:    AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}