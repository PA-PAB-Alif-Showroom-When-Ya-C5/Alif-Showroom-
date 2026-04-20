import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/features/admin/mobil/controllers/kelola_mobil_controller.dart';
import 'package:showroom_mobil/core/utils/app_input_formatter.dart';
import 'package:showroom_mobil/core/utils/currency_input_formatter.dart';

class FormMobilPage extends StatelessWidget {
  const FormMobilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KelolaMobilController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditMode ? 'Edit Mobil' : 'Tambah Mobil',
        )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── FOTO ───────────────────────────────────────
              _SectionLabel('Foto Mobil *'),
              const SizedBox(height: AppTheme.spacingSm),
              _FotoPicker(controller: controller),
              const SizedBox(height: AppTheme.spacingLg),

              // ── IDENTITAS MOBIL ────────────────────────────
              _SectionLabel('Identitas Mobil'),
              const SizedBox(height: AppTheme.spacingSm),

              // Merek
              TextFormField(
                controller: controller.merekCtrl,
                inputFormatters: [
                  AppInputFormatter.textNoEmoji,
                ],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorHelper.textRequiredNoEmoji(
                  value,
                  fieldName: 'Merek',
                ),
                decoration: const InputDecoration(
                  labelText: 'Merek',
                  hintText: 'Toyota, Honda, Suzuki...',
                  prefixIcon: Icon(Icons.branding_watermark_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Tipe / Model
              TextFormField(
                controller: controller.tipeModelCtrl,
                inputFormatters: [
                  AppInputFormatter.textNoEmoji,
                ],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorHelper.textRequiredNoEmoji(
                  value,
                  fieldName: 'Tipe / Model',
                ),
                decoration: const InputDecoration(
                  labelText: 'Tipe / Model',
                  hintText: 'Avanza, Brio, Ertiga...',
                  prefixIcon: Icon(Icons.model_training_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Tahun & Warna
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.tahunCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ValidatorHelper.tahunMobil,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Tahun',
                      hintText: '2020',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: TextFormField(
                    controller: controller.warnaCtrl,
                    inputFormatters: [
                      AppInputFormatter.textNoEmoji,
                    ],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => ValidatorHelper.textRequiredNoEmoji(
                      value,
                      fieldName: 'Warna',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Warna',
                      hintText: 'Putih, Hitam...',
                      prefixIcon: Icon(Icons.palette_outlined),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: AppTheme.spacingLg),

              // ── SPESIFIKASI ────────────────────────────────
              _SectionLabel('Spesifikasi'),
              const SizedBox(height: AppTheme.spacingSm),

              // Transmisi
              Obx(() => DropdownButtonFormField<Transmisi>(
                value:     controller.selectedTransmisi.value,
                decoration: const InputDecoration(
                  labelText:  'Transmisi',
                  prefixIcon: Icon(Icons.settings_outlined),
                ),
                items: Transmisi.values.map((t) =>
                    DropdownMenuItem(value: t, child: Text(t.label))
                ).toList(),
                onChanged: (v) => controller.selectedTransmisi.value = v,
                validator: (_) => controller.selectedTransmisi.value == null
                    ? 'Pilih transmisi' : null,
              )),
              const SizedBox(height: AppTheme.spacingMd),

              // Bahan Bakar
              Obx(() => DropdownButtonFormField<BahanBakar>(
                value:     controller.selectedBahanBakar.value,
                decoration: const InputDecoration(
                  labelText:  'Bahan Bakar',
                  prefixIcon: Icon(Icons.local_gas_station_outlined),
                ),
                items: BahanBakar.values.map((b) =>
                    DropdownMenuItem(value: b, child: Text(b.label))
                ).toList(),
                onChanged: (v) => controller.selectedBahanBakar.value = v,
                validator: (_) => controller.selectedBahanBakar.value == null
                    ? 'Pilih bahan bakar' : null,
              )),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: controller.jarakTempuhCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(), // ✅ pakai ini
                ],
                validator: ValidatorHelper.jarakTempuh,
                decoration: const InputDecoration(
                  labelText: 'Jarak Tempuh',
                  hintText: 'Contoh: 150.000',
                  suffixText: 'km', // ✅ lebih cocok daripada prefix
                  prefixIcon: Icon(Icons.speed_outlined),
                ),
              ),

              // ── HARGA & STATUS ─────────────────────────────
              _SectionLabel('Harga & Status'),
              const SizedBox(height: AppTheme.spacingSm),

              // Harga
              TextFormField(
                controller:       controller.hargaCtrl,
                keyboardType:     TextInputType.number,
                textInputAction:  TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:        ValidatorHelper.hargaMobil,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText:  'Harga',
                  hintText:   '150.000.000', // Update hint agar sesuai format baru
                  prefixIcon: Icon(Icons.attach_money_outlined),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Status STNK
              Obx(() => DropdownButtonFormField<StatusStnk>(
                value:     controller.selectedStatusStnk.value,
                decoration: const InputDecoration(
                  labelText:  'Status STNK',
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                items: StatusStnk.values.map((s) =>
                    DropdownMenuItem(value: s, child: Text(s.label))
                ).toList(),
                onChanged: (v) => controller.selectedStatusStnk.value = v,
                validator: (_) => controller.selectedStatusStnk.value == null
                    ? 'Pilih status STNK' : null,
              )),
              const SizedBox(height: AppTheme.spacingMd),

              // Status Mobil (hanya tampil saat edit)
              Obx(() {
                if (!controller.isEditMode) return const SizedBox.shrink();
                return Column(
                  children: [
                    DropdownButtonFormField<StatusMobil>(
                      value: controller.selectedStatusMobil.value,
                      decoration: const InputDecoration(
                        labelText:  'Status Mobil',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      items: StatusMobil.values.map((s) =>
                          DropdownMenuItem(value: s, child: Text(s.label))
                      ).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          controller.selectedStatusMobil.value = v;
                        }
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],
                );
              }),
              const SizedBox(height: AppTheme.spacingLg),

              // ── DESKRIPSI ──────────────────────────────────
              _SectionLabel('Deskripsi (opsional)'),
              const SizedBox(height: AppTheme.spacingSm),

              TextFormField(
                controller:      controller.deskripsiCtrl,
                maxLines:        4,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    ValidatorHelper.deskripsi(v, isRequired: false),
                decoration: const InputDecoration(
                  labelText:          'Deskripsi Mobil',
                  hintText:           'Kondisi interior, riwayat servis, dll.',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // ── TOMBOL SIMPAN ──────────────────────────────
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.simpanMobil,
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(controller.isSaving.value
                    ? 'Menyimpan...'
                    : controller.isEditMode
                        ? 'Simpan Perubahan'
                        : 'Tambah Mobil'),
              )),
              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// Widget Lokal
// ════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600,
      color: AppTheme.primary, letterSpacing: 0.5,
    ),
  );
}

class _FotoPicker extends StatelessWidget {
  final KelolaMobilController controller;
  const _FotoPicker({required this.controller});

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
            const Text('Pilih Sumber Foto',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppTheme.primary),
              title:   const Text('Kamera'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppTheme.primary),
              title:   const Text('Galeri'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
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
      final localFile   = controller.selectedImage.value;
      final networkUrl  = controller.existingFotoUrl.value;

      // ── Ada foto baru dari device ──────────────────────
      if (localFile != null) {
        return _FotoPreview(
          child:       Image.file(localFile, fit: BoxFit.cover),
          onGanti:     () => _showSourcePicker(context),
          onHapus:     controller.removeImage,
        );
      }

      // ── Ada foto lama dari Supabase (mode edit) ────────
      if (networkUrl != null && networkUrl.isNotEmpty) {
        return _FotoPreview(
          child: CachedNetworkImage(
            imageUrl:    networkUrl,
            fit:         BoxFit.cover,
            placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          onGanti: () => _showSourcePicker(context),
          onHapus: controller.removeImage,
        );
      }

      // ── Belum ada foto ─────────────────────────────────
      return GestureDetector(
        onTap: () => _showSourcePicker(context),
        child: Container(
          width:  double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color:        AppTheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.3), width: 1.5,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  size: 44, color: AppTheme.primary),
              SizedBox(height: AppTheme.spacingSm),
              Text('Tambah Foto Mobil',
                  style: TextStyle(
                    color: AppTheme.primary, fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: AppTheme.spacingXs),
              Text('Wajib Menggunakan Foto',
                  style: TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary,
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class _FotoPreview extends StatelessWidget {
  final Widget       child;
  final VoidCallback onGanti;
  final VoidCallback onHapus;
  const _FotoPreview({
    required this.child,
    required this.onGanti,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: SizedBox(
            width: double.infinity, height: 200, child: child,
          ),
        ),
        Positioned(
          top: AppTheme.spacingSm, right: AppTheme.spacingSm,
          child: GestureDetector(
            onTap: onHapus,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54, shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
        Positioned(
          bottom: AppTheme.spacingSm, right: AppTheme.spacingSm,
          child: GestureDetector(
            onTap: onGanti,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd, vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Ganti',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}