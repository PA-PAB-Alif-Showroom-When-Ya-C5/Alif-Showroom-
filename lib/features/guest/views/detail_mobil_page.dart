import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/utils/whatsapp_launcher.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class DetailMobilPage extends StatelessWidget {
  const DetailMobilPage({super.key});

  @override
  Widget build(BuildContext context) {

    final args = Get.arguments;

    if (args == null || args is! MobilModel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
        Get.snackbar(
          'Error',
          'Data mobil tidak ditemukan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final MobilModel mobil = args;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [


          SliverAppBar(
            expandedHeight:  280,
            pinned:          true,
            backgroundColor: AppTheme.primary,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black38,
                child: Icon(Icons.arrow_back,
                    color: Colors.white, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: mobil.fotoMobil != null
                  ? CachedNetworkImage(
                      imageUrl:    mobil.fotoMobil!,
                      fit:         BoxFit.cover,
                      placeholder: (_, __) => _FotoPlaceholder(),
                      errorWidget: (_, __, ___) => _FotoPlaceholder(),
                    )
                  : _FotoPlaceholder(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  _NamaHargaHeader(mobil: mobil),
                  const SizedBox(height: AppTheme.spacingMd),


                  _SectionCard(
                    title: 'Spesifikasi',
                    icon:  Icons.directions_car_outlined,
                    rows: [
                      _Row('Merek',        mobil.merek),
                      _Row('Tipe / Model', mobil.tipeModel),
                      _Row('Tahun',        '${mobil.tahun}'),
                      _Row('Warna',        mobil.warna),
                      _Row('Transmisi',    mobil.transmisi.label),
                      _Row('Bahan Bakar',  mobil.bahanBakar.label),
                      _Row('Jarak Tempuh',
                          _formatJarak(mobil.jarakTempuh)),
                      _Row('Status STNK',  mobil.statusStnk.label),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),


                  if (mobil.deskripsi != null &&
                      mobil.deskripsi!.isNotEmpty) ...[
                    _DeskripsiCard(deskripsi: mobil.deskripsi!),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],


                  _TombolWhatsapp(mobil: mobil),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatJarak(int km) =>
      '${NumberFormat('#,###', 'id_ID').format(km)} km';
}



class _NamaHargaHeader extends StatelessWidget {
  final MobilModel mobil;
  const _NamaHargaHeader({required this.mobil});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${mobil.merek} ${mobil.tipeModel}',
            style: const TextStyle(
              fontSize:   22,
              fontWeight: FontWeight.bold,
              color:      AppTheme.textPrimary,
            )),
        const SizedBox(height: 4),
        Text('${mobil.tahun} · ${mobil.transmisi.label}',
            style: const TextStyle(
                fontSize: 14, color: AppTheme.textSecondary)),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp ',
              decimalDigits: 0).format(mobil.harga),
          style: const TextStyle(
            fontSize:   24,
            fontWeight: FontWeight.bold,
            color:      AppTheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXs),
        // Badge tersedia
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd, vertical: 4),
          decoration: BoxDecoration(
            color:        AppTheme.success.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(
                color: AppTheme.success.withOpacity(0.4)),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle_outline,
                color: AppTheme.success, size: 14),
            SizedBox(width: 4),
            Text('Tersedia',
                style: TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w600,
                  color:      AppTheme.success,
                )),
          ]),
        ),
      ],
    );
  }
}



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
                SizedBox(width: 120,
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
            Text('Deskripsi',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600,
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



class _TombolWhatsapp extends StatelessWidget {
  final MobilModel mobil;
  const _TombolWhatsapp({required this.mobil});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => WhatsappLauncher.tanyaMobil(
          namaMobil: '${mobil.merek} ${mobil.tipeModel}',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingMd),
        ),
        icon:  const Icon(Icons.chat_outlined),
        label: const Text('Tanya via WhatsApp',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}



class _FotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: AppTheme.primary.withOpacity(0.08),
    child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
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