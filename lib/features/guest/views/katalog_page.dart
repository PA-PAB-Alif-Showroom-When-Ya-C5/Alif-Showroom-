import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/features/guest/controllers/guest_controller.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';

class KatalogPage extends StatelessWidget {
  const KatalogPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.isRegistered<GuestController>()
        ? Get.find<GuestController>()
        : Get.put(GuestController());


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.mobilFiltered.isEmpty &&
          !controller.isLoadingKatalog.value) {
        controller.loadKatalog();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Mobil'),
        actions: [

          Obx(() => controller.hasActiveFilter
              ? IconButton(
                  icon:    const Icon(Icons.filter_alt_off_outlined),
                  tooltip: 'Reset Filter',
                  onPressed: controller.resetFilter,
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [


          _SearchBar(controller: controller),


          _FilterBar(controller: controller),


          Expanded(
            child: Obx(() {


              if (controller.isLoadingKatalog.value &&
                  controller.mobilFiltered.isEmpty) {
                return const _LoadingState();
              }


              if (controller.errorKatalog.value.isNotEmpty &&
                  controller.mobilFiltered.isEmpty) {
                return _ErrorState(
                  message: controller.errorKatalog.value,
                  onRetry: controller.refreshKatalog,
                );
              }


              if (controller.mobilFiltered.isEmpty) {
                return _EmptyState(
                  hasFilter: controller.hasActiveFilter,
                  onReset:   controller.resetFilter,
                );
              }


              return RefreshIndicator(
                onRefresh: controller.refreshKatalog,
                color:     AppTheme.primary,
                child: ListView.builder(
                  padding:     const EdgeInsets.only(
                      bottom: AppTheme.spacingXl),
                  itemCount:   controller.mobilFiltered.length,
                  itemBuilder: (_, index) {
                    final mobil = controller.mobilFiltered[index];
                    return _KatalogCard(
                      mobil: mobil,
                      onTap: () => Get.toNamed(
                        AppRoutes.detailMobil,
                        arguments: mobil,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}



class _SearchBar extends StatelessWidget {
  final GuestController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: TextField(
        controller:  controller.searchCtrl,
        onChanged:   controller.setSearch,
        decoration: InputDecoration(
          hintText:     'Cari merek atau tipe...',
          prefixIcon:   const Icon(Icons.search, size: 20),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon:      const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    controller.searchCtrl.clear();
                    controller.setSearch('');
                  },
                )
              : const SizedBox.shrink()),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical:   AppTheme.spacingSm),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            borderSide:   const BorderSide(color: AppTheme.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            borderSide:   const BorderSide(color: AppTheme.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            borderSide:   const BorderSide(
                color: AppTheme.primary, width: 2),
          ),
          filled:     true,
          fillColor:  AppTheme.background,
        ),
      ),
    );
  }
}



class _FilterBar extends StatelessWidget {
  final GuestController controller;
  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   Colors.white,
      padding: const EdgeInsets.only(
        left:   AppTheme.spacingMd,
        right:  AppTheme.spacingMd,
        bottom: AppTheme.spacingMd,
      ),
      child: Row(children: [


        _FilterChipButton(
          label:    'Tahun',
          icon:     Icons.calendar_today_outlined,
          isActive: controller.filterTahunMin.value != null ||
              controller.filterTahunMax.value != null,
          onTap: () => _showTahunDialog(context, controller),
        ),
        const SizedBox(width: AppTheme.spacingSm),


        _FilterChipButton(
          label:    'Harga',
          icon:     Icons.attach_money_outlined,
          isActive: controller.filterHargaMin.value != null ||
              controller.filterHargaMax.value != null,
          onTap: () => _showHargaDialog(context, controller),
        ),
      ]),
    );
  }

  void _showTahunDialog(
      BuildContext context, GuestController controller) {
    final minCtrl = TextEditingController(
        text: controller.filterTahunMin.value?.toString() ?? '');
    final maxCtrl = TextEditingController(
        text: controller.filterTahunMax.value?.toString() ?? '');

    Get.dialog(AlertDialog(
      title:   const Text('Filter Tahun'),
      content: Row(children: [
        Expanded(child: TextField(
          controller:   minCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(
              labelText: 'Dari', hintText: '2015'),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child:   Text('–'),
        ),
        Expanded(child: TextField(
          controller:   maxCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(
              labelText: 'Sampai', hintText: '2025'),
        )),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            controller.setFilterTahun(min: null, max: null);
            Get.back();
          },
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.setFilterTahun(
              min: int.tryParse(minCtrl.text),
              max: int.tryParse(maxCtrl.text),
            );
            Get.back();
          },
          child: const Text('Terapkan'),
        ),
      ],
    ));
  }

  void _showHargaDialog(
      BuildContext context, GuestController controller) {
    final minCtrl = TextEditingController(
        text: controller.filterHargaMin.value?.toStringAsFixed(0) ?? '');
    final maxCtrl = TextEditingController(
        text: controller.filterHargaMax.value?.toStringAsFixed(0) ?? '');

    Get.dialog(AlertDialog(
      title:   const Text('Filter Harga'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller:   minCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Harga Minimum',
            hintText:  '80000000',
            prefixText: 'Rp ',
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextField(
          controller:   maxCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Harga Maksimum',
            hintText:  '500000000',
            prefixText: 'Rp ',
          ),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            controller.setFilterHarga(min: null, max: null);
            Get.back();
          },
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.setFilterHarga(
              min: double.tryParse(minCtrl.text),
              max: double.tryParse(maxCtrl.text),
            );
            Get.back();
          },
          child: const Text('Terapkan'),
        ),
      ],
    ));
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isActive ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _KatalogCard extends StatelessWidget {
  final MobilModel   mobil;
  final VoidCallback onTap;
  const _KatalogCard({required this.mobil, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical:   AppTheme.spacingXs),
      child:  InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Row(children: [


          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft:    Radius.circular(AppTheme.radiusMd),
              bottomLeft: Radius.circular(AppTheme.radiusMd),
            ),
            child: SizedBox(
              width:  110,
              height: 100,
              child:  mobil.fotoMobil != null
                  ? CachedNetworkImage(
                      imageUrl:    mobil.fotoMobil!,
                      fit:         BoxFit.cover,
                      placeholder: (_, __) => _FotoPlaceholder(),
                      errorWidget: (_, __, ___) => _FotoPlaceholder(),
                    )
                  : _FotoPlaceholder(),
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${mobil.merek} ${mobil.tipeModel}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize:   14,
                        color:      AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    '${mobil.tahun} · ${mobil.transmisi.label} '
                    '· ${mobil.bahanBakar.label}',
                    style: const TextStyle(
                        fontSize: 12,
                        color:    AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatJarak(mobil.jarakTempuh)} · ${mobil.warna}',
                    style: const TextStyle(
                        fontSize: 11,
                        color:    AppTheme.textHint),
                  ),
                  const SizedBox(height: 6),
                  Text(_formatRupiah(mobil.harga),
                      style: const TextStyle(
                        fontSize:   15,
                        fontWeight: FontWeight.bold,
                        color:      AppTheme.primary,
                      )),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(right: AppTheme.spacingSm),
            child: Icon(Icons.chevron_right,
                color: AppTheme.textHint, size: 20),
          ),
        ]),
      ),
    );
  }

  String _formatRupiah(double v) => NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  String _formatJarak(int km) =>
      '${NumberFormat('#,###', 'id_ID').format(km)} km';
}

class _FotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: AppTheme.primary.withOpacity(0.06),
    child: const Icon(Icons.directions_car_outlined,
        color: AppTheme.primary, size: 34),
  );
}



class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 5,
    padding:   const EdgeInsets.all(AppTheme.spacingMd),
    itemBuilder: (_, __) => Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child:  Row(children: [
        Container(width: 110, height: 100, color: AppTheme.divider),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Grey(w: double.infinity, h: 14),
              const SizedBox(height: 6),
              _Grey(w: 160, h: 12),
              const SizedBox(height: 6),
              _Grey(w: 100, h: 12),
              const SizedBox(height: 8),
              _Grey(w: 120, h: 14),
            ],
          ),
        )),
      ]),
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
  final bool         hasFilter;
  final VoidCallback onReset;
  const _EmptyState({required this.hasFilter, required this.onReset});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Icon(
          hasFilter
              ? Icons.search_off_outlined
              : Icons.directions_car_outlined,
          size:  72,
          color: AppTheme.textHint.withOpacity(0.4),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          hasFilter
              ? 'Tidak ada mobil sesuai filter'
              : 'Belum ada mobil tersedia',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          hasFilter
              ? 'Coba ubah atau hapus filter pencarian'
              : 'Kembali lagi nanti',
          style: const TextStyle(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
        if (hasFilter) ...[
          const SizedBox(height: AppTheme.spacingLg),
          OutlinedButton.icon(
            onPressed: onReset,
            icon:      const Icon(Icons.filter_alt_off_outlined),
            label:     const Text('Reset Filter'),
          ),
        ],
      ]),
    ),
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