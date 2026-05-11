import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/utils/maps_launcher.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/core/utils/whatsapp_launcher.dart';
import 'package:showroom_mobil/features/seller/profil/controllers/profil_controller.dart';

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfilController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          Obx(() => controller.isEditMode.value
              ? TextButton(
                  onPressed: controller.cancelEditMode,
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : IconButton(
                  icon:    const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Profil',
                  onPressed: controller.enterEditMode,
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.profil.value == null) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.loadProfil,
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: controller.isEditMode.value
              ? _EditForm(controller: controller)
              : _ViewProfil(controller: controller),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════
// View Mode
// ════════════════════════════════════════════════════════════

class _ViewProfil extends StatelessWidget {
  final ProfilController controller;
  const _ViewProfil({required this.controller});

  @override
  Widget build(BuildContext context) {
    final profil = controller.profil.value;
    if (profil == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: AppTheme.spacingMd),

        // ── Avatar ────────────────────────────────────────
        _AvatarView(
          fotoUrl: profil.fotoProfil,
          inisial: profil.inisial,
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Nama
        Text(
          profil.namaLengkap,
          style: const TextStyle(
            fontSize:   22,
            fontWeight: FontWeight.bold,
            color:      AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXs),

        // Badge role
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical:   AppTheme.spacingXs,
          ),
          decoration: BoxDecoration(
            color:        AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          ),
          child: const Text(
            'Seller',
            style: TextStyle(
              color:      AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize:   13,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // ── Info Card ──────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacingSm),
            child: Column(
              children: [
                _InfoTile(
                  icon:  Icons.email_outlined,
                  label: 'Email',
                  value: profil.email,
                ),
                const Divider(height: 1, indent: 56),
                _InfoTile(
                  icon:  Icons.phone_outlined,
                  label: 'WhatsApp',
                  value: profil.nomorWhatsapp,
                ),
                const Divider(height: 1, indent: 56),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // ── Tombol Kontak Showroom ─────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hubungi Showroom',
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      AppTheme.primary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),

                // Tombol WhatsApp
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: WhatsappLauncher.hubungiSebagaiSeller,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      side: const BorderSide(
                          color: Color(0xFF25D366)),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                    icon:  const Icon(Icons.chat_outlined),
                    label: const Text('WhatsApp Showroom'),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),

                // Tombol Lokasi
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: MapsLauncher.bukaLokasiShowroom,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd),
                    ),
                    icon:  const Icon(Icons.location_on_outlined),
                    label: const Text('Lihat Lokasi Showroom'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // ── Tombol Logout ──────────────────────────────────
        const SizedBox(height: AppTheme.spacingXl),
        OutlinedButton.icon(
          onPressed: controller.logout,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.error,
            side:            const BorderSide(color: AppTheme.error),
          ),
          icon:  const Icon(Icons.logout),
          label: const Text('Keluar'),
        ),
        const SizedBox(height: AppTheme.spacingLg),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// Widget Pendukung — tidak ada perubahan dari versi asli
// ════════════════════════════════════════════════════════════

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 22),
      title: Text(label,
          style: const TextStyle(
              fontSize: 12, color: AppTheme.textSecondary)),
      subtitle: Text(value,
          style: const TextStyle(
              fontSize:   15,
              color:      AppTheme.textPrimary,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _AvatarView extends StatelessWidget {
  final String? fotoUrl;
  final String  inisial;
  const _AvatarView({this.fotoUrl, required this.inisial});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius:          52,
      backgroundColor: AppTheme.primary.withOpacity(0.12),
      child: fotoUrl != null && fotoUrl!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl:    fotoUrl!,
                width:       104,
                height:      104,
                fit:         BoxFit.cover,
                placeholder: (_, __) => _InisialAvatar(inisial: inisial),
                errorWidget: (_, __, ___) =>
                    _InisialAvatar(inisial: inisial),
              ),
            )
          : _InisialAvatar(inisial: inisial),
    );
  }
}

class _InisialAvatar extends StatelessWidget {
  final String inisial;
  const _InisialAvatar({required this.inisial});

  @override
  Widget build(BuildContext context) {
    return Text(
      inisial,
      style: const TextStyle(
        fontSize:   32,
        fontWeight: FontWeight.bold,
        color:      AppTheme.primary,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Edit Mode
// ════════════════════════════════════════════════════════════

class _EditForm extends StatelessWidget {
  final ProfilController controller;
  const _EditForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacingMd),
          _AvatarEdit(controller: controller),
          const SizedBox(height: AppTheme.spacingLg),

          TextFormField(
            controller:         controller.namaCtrl,
            textCapitalization: TextCapitalization.words,
            textInputAction:    TextInputAction.next,
            autovalidateMode:   AutovalidateMode.onUserInteraction,
            validator:          ValidatorHelper.namaLengkap,
            decoration: const InputDecoration(
              labelText:  'Nama Lengkap',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          TextFormField(
            controller:      controller.waCtrl,
            keyboardType:    TextInputType.phone,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator:       ValidatorHelper.nomorWhatsapp,
            decoration: const InputDecoration(
              labelText:  'Nomor WhatsApp',
              hintText:   '08xxxxxxxxxx',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          Obx(() => ElevatedButton.icon(
            onPressed: controller.isSaving.value
                ? null
                : controller.saveProfil,
            icon: controller.isSaving.value
                ? const SizedBox(
                    width:  18,
                    height: 18,
                    child:  CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(controller.isSaving.value
                ? 'Menyimpan...'
                : 'Simpan Perubahan'),
          )),
          const SizedBox(height: AppTheme.spacingLg),
        ],
      ),
    );
  }
}

class _AvatarEdit extends StatelessWidget {
  final ProfilController controller;
  const _AvatarEdit({required this.controller});

  void _showSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLg),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppTheme.spacingMd),
            const Text('Ganti Foto Profil',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16)),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppTheme.primary),
              title:   const Text('Kamera'),
              onTap: () {
                Get.back();
                controller.pickFotoProfil(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppTheme.primary),
              title:   const Text('Galeri'),
              onTap: () {
                Get.back();
                controller.pickFotoProfil(ImageSource.gallery);
              },
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final localFile  = controller.selectedImage.value;
      final networkUrl = controller.profil.value?.fotoProfil;
      final inisial    = controller.profil.value?.inisial ?? '?';

      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius:          52,
            backgroundColor: AppTheme.primary.withOpacity(0.12),
            child: localFile != null
                ? ClipOval(
                    child: Image.file(localFile,
                        width: 104, height: 104, fit: BoxFit.cover))
                : networkUrl != null && networkUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:    networkUrl,
                          width:       104,
                          height:      104,
                          fit:         BoxFit.cover,
                          placeholder: (_, __) =>
                              _InisialAvatar(inisial: inisial),
                          errorWidget: (_, __, ___) =>
                              _InisialAvatar(inisial: inisial),
                        ),
                      )
                    : _InisialAvatar(inisial: inisial),
          ),
          Positioned(
            bottom: 0,
            right:  MediaQuery.of(context).size.width / 2 - 60,
            child: GestureDetector(
              onTap: () => _showSourcePicker(context),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingXs),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ════════════════════════════════════════════════════════════
// Error State
// ════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size:  64,
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
          ],
        ),
      ),
    );
  }
}