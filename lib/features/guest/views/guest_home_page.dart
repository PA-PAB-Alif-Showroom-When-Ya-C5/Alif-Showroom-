import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/core/utils/maps_launcher.dart';
import 'package:showroom_mobil/core/utils/whatsapp_launcher.dart';
import 'package:showroom_mobil/features/guest/controllers/guest_controller.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key});

  static const String _bannerKreditAsset =
      'assets/images/kredit_info.jpeg';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GuestController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        onRefresh: controller.refreshBeranda,
        color: AppTheme.primary,
        child: CustomScrollView(
          slivers: [
            _GuestAppBar(),


            const SliverToBoxAdapter(
              child: _AksiCepat(),
            ),


            const SliverToBoxAdapter(
              child: _InfoKreditSection(
                bannerAssetPath: _bannerKreditAsset,
              ),
            ),


            SliverToBoxAdapter(
              child: _MobilTerbaruSection(controller: controller),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXl),
            ),
          ],
        ),
      ),
    );
  }
}



class _GuestAppBar extends StatelessWidget {
  const _GuestAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppTheme.primary,
      automaticallyImplyLeading: false,
      actions: [
        TextButton.icon(
          onPressed: () => Get.toNamed(AppRoutes.login),
          icon: const Icon(Icons.login, color: Colors.white, size: 18),
          label: const Text(
            'Masuk',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMd,
            60,
            AppTheme.spacingMd,
            AppTheme.spacingMd,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Showroom Mobil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Alif Berkah Dua Bersaudara',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _AksiCepat extends StatelessWidget {
  const _AksiCepat();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingMd,
        AppTheme.spacingMd,
        AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          _AksiButton(
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: WhatsappLauncher.tanyaKatalog,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          _AksiButton(
            icon: Icons.location_on_outlined,
            label: 'Lokasi',
            color: AppTheme.error,
            onTap: MapsLauncher.bukaLokasiShowroom,
          ),
        ],
      ),
    );
  }
}

class _AksiButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AksiButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _InfoKreditSection extends StatelessWidget {
  final String bannerAssetPath;

  const _InfoKreditSection({
    required this.bannerAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingSm,
        AppTheme.spacingMd,
        AppTheme.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'List Kredit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            onTap: () {
              Get.to(
                () => _KreditBannerPreviewPage(
                  imageAssetPath: bannerAssetPath,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 7,
                    child: Image.asset(
                      bannerAssetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.accent.withOpacity(0.12),
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: AppTheme.accent,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Banner kredit belum ditemukan',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Klik banner untuk melihat informasi pengajuan kredit',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                          child: const Text(
                            'Lihat',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KreditBannerPreviewPage extends StatelessWidget {
  final String imageAssetPath;

  const _KreditBannerPreviewPage({
    required this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Informasi Pengajuan Kredit'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Image.asset(
              imageAssetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                color: Colors.white,
                child: const Column(
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: AppTheme.textHint,
                    ),
                    SizedBox(height: AppTheme.spacingMd),
                    Text(
                      'Gambar pengajuan kredit belum ditemukan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class _MobilTerbaruSection extends StatelessWidget {
  final GuestController controller;
  const _MobilTerbaruSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mobil Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.katalog),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Obx(() {
            if (controller.isLoadingHome.value) {
              return _ShimmerList();
            }
            if (controller.errorHome.value.isNotEmpty) {
              return _InlineError(
                message: controller.errorHome.value,
                onRetry: controller.refreshBeranda,
              );
            }
            if (controller.mobilTerbaru.isEmpty) {
              return const _InlineEmpty(
                message: 'Belum ada mobil tersedia.',
              );
            }
            return Column(
              children: controller.mobilTerbaru
                  .map(
                    (m) => _MobilCard(
                      mobil: m,
                      onTap: () => Get.toNamed(
                        AppRoutes.detailMobil,
                        arguments: m,
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}



class _MobilCard extends StatelessWidget {
  final MobilModel mobil;
  final VoidCallback onTap;

  const _MobilCard({
    required this.mobil,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMd),
                bottomLeft: Radius.circular(AppTheme.radiusMd),
              ),
              child: SizedBox(
                width: 100,
                height: 90,
                child: mobil.fotoMobil != null
                    ? CachedNetworkImage(
                        imageUrl: mobil.fotoMobil!,
                        fit: BoxFit.cover,
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
                    Text(
                      '${mobil.merek} ${mobil.tipeModel}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mobil.tahun} · ${mobil.transmisi.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatRupiah(mobil.harga),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: AppTheme.spacingSm),
              child: Icon(
                Icons.chevron_right,
                color: AppTheme.textHint,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRupiah(double v) => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(v);
}

class _FotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary.withOpacity(0.06),
      child: const Icon(
        Icons.directions_car_outlined,
        color: AppTheme.primary,
        size: 32,
      ),
    );
  }
}



class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 90,
                color: AppTheme.divider,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Grey(w: double.infinity, h: 14),
                      SizedBox(height: 6),
                      _Grey(w: 120, h: 12),
                      SizedBox(height: 6),
                      _Grey(w: 90, h: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Grey extends StatelessWidget {
  final double w;
  final double h;

  const _Grey({
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: AppTheme.divider,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String message;

  const _InlineEmpty({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 48,
              color: AppTheme.textHint.withOpacity(0.4),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingLg),
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}