import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/features/admin/pengajuan/controllers/kelola_pengajuan_controller.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';

class DetailPengajuanAdminPage extends StatelessWidget {
  const DetailPengajuanAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KelolaPengajuanController>();

    return Obx(() {
      final pengajuan = controller.selectedPengajuan.value;
      if (pengajuan == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: AppTheme.background,
        body: CustomScrollView(
          slivers: [

            // ── Hero Foto ──────────────────────────────
            _SliverFotoHeader(fotoUrl: pengajuan.fotoMobil),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Nama + status badge
                    _NamaHeader(
                      merek:     pengajuan.merek,
                      tipeModel: pengajuan.tipeModel,
                      tahun:     pengajuan.tahun,
                      transmisi: pengajuan.transmisi.label,
                      status:    pengajuan.statusPengajuan,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Panel update status + catatan ────
                    _PanelUpdateAdmin(controller: controller),
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Spesifikasi ──────────────────────
                    _SectionCard(
                      title: 'Spesifikasi Kendaraan',
                      icon:  Icons.directions_car_outlined,
                      rows: [
                        _Row('Merek',        pengajuan.merek),
                        _Row('Tipe / Model', pengajuan.tipeModel),
                        _Row('Tahun',        '${pengajuan.tahun}'),
                        _Row('Transmisi',    pengajuan.transmisi.label),
                        _Row('Bahan Bakar',  pengajuan.bahanBakar.label),
                        _Row('Jarak Tempuh',
                            _formatJarak(pengajuan.jarakTempuh)),
                        _Row('Status STNK',  pengajuan.statusStnk.label),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Harga & Kontak ───────────────────
                    _SectionCard(
                      title: 'Harga & Kontak Seller',
                      icon:  Icons.attach_money_outlined,
                      rows: [
                        _Row('Harga Diinginkan',
                            _formatRupiah(pengajuan.hargaDiinginkan)),
                        _Row('Nomor WhatsApp',
                            pengajuan.nomorWhatsapp),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Deskripsi ────────────────────────
                    _DeskripsiCard(
                        deskripsi: pengajuan.deskripsiKondisi),
                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Timestamp ────────────────────────
                    _TimestampCard(
                      dibuatPada:   pengajuan.dibuatPada,
                      diupdatePada: pengajuan.diupdatePada,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatRupiah(double v) => NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  String _formatJarak(int km) =>
      '${NumberFormat('#,###', 'id_ID').format(km)} km';
}

// ── Sliver foto header ────────────────────────────────────────

class _SliverFotoHeader extends StatelessWidget {
  final String? fotoUrl;
  const _SliverFotoHeader({this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight:  240,
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
        background: fotoUrl != null && fotoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl:    fotoUrl!,
                fit:         BoxFit.cover,
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
  Widget build(BuildContext context) => Container(
    color: AppTheme.primary.withOpacity(0.08),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.directions_car_outlined, size: 72,
          color: AppTheme.primary.withOpacity(0.4)),
      const SizedBox(height: AppTheme.spacingSm),
      Text('Foto tidak tersedia',
          style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.6),
              fontSize: 13)),
    ]),
  );
}

// ── Nama header ───────────────────────────────────────────────

class _NamaHeader extends StatelessWidget {
  final String          merek;
  final String          tipeModel;
  final int             tahun;
  final String          transmisi;
  final StatusPengajuan status;
  const _NamaHeader({
    required this.merek,
    required this.tipeModel,
    required this.tahun,
    required this.transmisi,
    required this.status,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$merek $tipeModel',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('$tahun · $transmisi',
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.textSecondary)),
        ],
      )),
      const SizedBox(width: AppTheme.spacingSm),
      _BigStatusBadge(status: status),
    ],
  );
}

class _BigStatusBadge extends StatelessWidget {
  final StatusPengajuan status;
  const _BigStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color:        status.color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      border:       Border.all(color: status.color.withOpacity(0.4)),
    ),
    child: Text(status.label,
        style: TextStyle(
          fontSize:   13,
          fontWeight: FontWeight.w700,
          color:      status.color,
        )),
  );
}

// ── Panel update admin ────────────────────────────────────────

class _PanelUpdateAdmin extends StatelessWidget {
  final KelolaPengajuanController controller;
  const _PanelUpdateAdmin({required this.controller});

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
            const Row(children: [
              Icon(Icons.admin_panel_settings_outlined,
                  size: 18, color: AppTheme.primary),
              SizedBox(width: AppTheme.spacingXs),
              Text('Tindakan Admin',
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                    color:      AppTheme.primary,
                  )),
            ]),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spacingMd),

            // ── Pilih Status ───────────────────────────
            const Text('Ubah Status Pengajuan',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary)),
            const SizedBox(height: AppTheme.spacingSm),

            Obx(() => Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingSm,
              children: StatusPengajuan.values.map((s) {
                final isSelected =
                    controller.selectedStatus.value == s;
                return GestureDetector(
                  onTap: () =>
                      controller.selectedStatus.value = s,
                  child: AnimatedContainer(
                    duration: AppConstants.animationFast,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical:   AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? s.color
                          : s.color.withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(
                        color: isSelected
                            ? s.color
                            : s.color.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min,
                        children: [
                      if (isSelected) ...[
                        Icon(Icons.check, color: Colors.white,
                            size: 14),
                        const SizedBox(width: 4),
                      ],
                      Text(s.label,
                          style: TextStyle(
                            fontSize:   13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : s.color,
                          )),
                    ]),
                  ),
                );
              }).toList(),
            )),

            const SizedBox(height: AppTheme.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppTheme.spacingMd),

            // ── Catatan Admin ──────────────────────────
            const Text('Catatan Admin',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary)),
            const SizedBox(height: AppTheme.spacingSm),

            TextFormField(
              controller: controller.catatanCtrl,
              maxLines:   4,
              decoration: const InputDecoration(
                hintText: 'Tulis catatan untuk seller...\n'
                    'Contoh: Unit sudah kami tinjau, '
                    'harga perlu didiskusikan.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // ── Tombol Simpan ──────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.simpanPerubahan,
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_outlined),
                label: Text(controller.isSaving.value
                    ? 'Menyimpan...'
                    : 'Simpan Perubahan'),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ── Section card generik ──────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String    title;
  final IconData  icon;
  final List<_Row> rows;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child:  Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingXs),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppTheme.primary)),
          ]),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(height: 1),
          const SizedBox(height: AppTheme.spacingSm),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 130,
                    child: Text(r.label,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary))),
                const Text(': ',
                    style: TextStyle(color: AppTheme.textSecondary)),
                Expanded(child: Text(r.value,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary))),
              ],
            ),
          )),
        ],
      ),
    ),
  );
}

class _Row {
  final String label, value;
  const _Row(this.label, this.value);
}

// ── Deskripsi card ────────────────────────────────────────────

class _DeskripsiCard extends StatelessWidget {
  final String deskripsi;
  const _DeskripsiCard({required this.deskripsi});

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child:  Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.description_outlined,
                size: 18, color: AppTheme.primary),
            SizedBox(width: AppTheme.spacingXs),
            Text('Deskripsi Kondisi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppTheme.primary)),
          ]),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(height: 1),
          const SizedBox(height: AppTheme.spacingMd),
          Text(deskripsi,
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.textPrimary,
                  height: 1.6)),
        ],
      ),
    ),
  );
}

// ── Timestamp card ────────────────────────────────────────────

class _TimestampCard extends StatelessWidget {
  final DateTime dibuatPada;
  final DateTime diupdatePada;
  const _TimestampCard({
    required this.dibuatPada,
    required this.diupdatePada,
  });

  String _fmt(DateTime dt) =>
      DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt.toLocal());

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppTheme.spacingMd),
    decoration: BoxDecoration(
      color:        AppTheme.divider.withOpacity(0.4),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
    ),
    child: Column(children: [
      _TsRow(label: 'Diajukan pada',       value: _fmt(dibuatPada)),
      const SizedBox(height: AppTheme.spacingXs),
      _TsRow(label: 'Terakhir diperbarui', value: _fmt(diupdatePada)),
    ]),
  );
}

class _TsRow extends StatelessWidget {
  final String label, value;
  const _TsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.access_time_outlined,
        size: 14, color: AppTheme.textHint),
    const SizedBox(width: AppTheme.spacingXs),
    Text('$label: ',
        style: const TextStyle(fontSize: 12, color: AppTheme.textHint)),
    Expanded(child: Text(value,
        style: const TextStyle(
            fontSize: 12, color: AppTheme.textSecondary))),
  ]);
}