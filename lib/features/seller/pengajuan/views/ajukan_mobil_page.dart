import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/features/seller/pengajuan/controllers/pengajuan_controller.dart';
import 'package:showroom_mobil/core/utils/app_input_formatter.dart';
import 'package:showroom_mobil/core/utils/currency_input_formatter.dart';

class AjukanMobilPage extends StatelessWidget {
  const AjukanMobilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PengajuanController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Mobil'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── FOTO MOBIL ──────────────────────────────────
              _SectionLabel('Foto Mobil'),
              const SizedBox(height: AppTheme.spacingSm),
              _FotoPickerWidget(controller: controller),
              const SizedBox(height: AppTheme.spacingLg),

              // ── DATA MOBIL ──────────────────────────────────
              _SectionLabel('Data Mobil'),
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

              // Tahun & Transmisi (2 kolom)
              Row(
                children: [
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
                    child: Obx(() => DropdownButtonFormField<Transmisi>(
                      value: controller.selectedTransmisi.value,
                      decoration: const InputDecoration(
                        labelText: 'Transmisi',
                        prefixIcon: Icon(Icons.settings_outlined),
                      ),
                      items: Transmisi.values
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.label),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          controller.selectedTransmisi.value = val,
                      validator: (_) =>
                          controller.selectedTransmisi.value == null
                              ? 'Pilih transmisi'
                              : null,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Jarak Tempuh
              TextFormField(
                controller: controller.jarakTempuhCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidatorHelper.jarakTempuh,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Jarak Tempuh',
                  hintText: 'Contoh: 150.000',
                  prefixIcon: Icon(Icons.speed_outlined),
                  suffixText: 'km',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Bahan Bakar
              Obx(() => DropdownButtonFormField<BahanBakar>(
                value: controller.selectedBahanBakar.value,
                decoration: const InputDecoration(
                  labelText: 'Bahan Bakar',
                  prefixIcon: Icon(Icons.local_gas_station_outlined),
                ),
                items: BahanBakar.values
                    .map((b) => DropdownMenuItem(
                          value: b,
                          child: Text(b.label),
                        ))
                    .toList(),
                onChanged: (val) =>
                    controller.selectedBahanBakar.value = val,
                validator: (_) =>
                    controller.selectedBahanBakar.value == null
                        ? 'Pilih bahan bakar'
                        : null,
              )),
              const SizedBox(height: AppTheme.spacingMd),

              // Status STNK
              Obx(() => DropdownButtonFormField<StatusStnk>(
                value: controller.selectedStatusStnk.value,
                decoration: const InputDecoration(
                  labelText: 'Status STNK',
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                items: StatusStnk.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ))
                    .toList(),
                onChanged: (val) =>
                    controller.selectedStatusStnk.value = val,
                validator: (_) =>
                    controller.selectedStatusStnk.value == null
                        ? 'Pilih status STNK'
                        : null,
              )),
              const SizedBox(height: AppTheme.spacingLg),

              // ── HARGA & KONTAK ──────────────────────────────
              _SectionLabel('Harga & Kontak'),
              const SizedBox(height: AppTheme.spacingSm),

              // Harga yang Diinginkan
              TextFormField(
                controller:       controller.hargaDiinginkanCtrl,
                keyboardType:     TextInputType.number,
                textInputAction:  TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:        ValidatorHelper.hargaPengajuan,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, 
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText:  'Harga yang Diinginkan',
                  hintText:   '80.000.000',
                  prefixIcon: Icon(Icons.attach_money_outlined),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Nomor WhatsApp
              TextFormField(
                controller: controller.nomorWhatsappCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidatorHelper.nomorWhatsapp,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined),
                  helperText: 'Nomor yang bisa dihubungi admin',
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // ── DESKRIPSI ───────────────────────────────────
              _SectionLabel('Kondisi Kendaraan'),
              const SizedBox(height: AppTheme.spacingSm),

              TextFormField(
                controller: controller.deskripsiKondisiCtrl,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) =>
                    ValidatorHelper.deskripsi(v, isRequired: true),
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Kondisi',
                  hintText:
                      'Jelaskan kondisi mobil secara jujur dan detail.\n'
                      'Contoh: AC dingin, mesin halus, body mulus...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // ── TOMBOL SUBMIT ───────────────────────────────
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitPengajuan,
                icon: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  controller.isSubmitting.value
                      ? 'Mengirim...'
                      : 'Kirim Pengajuan',
                ),
              )),

              const SizedBox(height: AppTheme.spacingMd),

              // Catatan bawah form
              const Text(
                'Pengajuan akan direview oleh admin showroom.\n'
                'Pastikan semua informasi yang kamu berikan akurat.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textHint,
                ),
                textAlign: TextAlign.center,
              ),

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
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _FotoPickerWidget extends StatelessWidget {
  final PengajuanController controller;
  const _FotoPickerWidget({required this.controller});

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
            const SizedBox(height: AppTheme.spacingSm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppTheme.primary),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppTheme.primary),
              title: const Text('Galeri'),
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
      final file = controller.selectedImage.value;

      // ── Ada foto dipilih ──────────────────────────────────
      if (file != null) {
        return Stack(
          children: [
            // Preview foto
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Image.file(
                file,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            // Tombol hapus foto
            Positioned(
              top: AppTheme.spacingSm,
              right: AppTheme.spacingSm,
              child: GestureDetector(
                onTap: controller.removeImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),

            // Tombol ganti foto
            Positioned(
              bottom: AppTheme.spacingSm,
              right: AppTheme.spacingSm,
              child: GestureDetector(
                onTap: () => _showSourcePicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Ganti',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }

      // ── Belum ada foto ────────────────────────────────────
      return GestureDetector(
        onTap: () => _showSourcePicker(context),
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.3),
              style: BorderStyle.solid,
              width: 1.5,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 44,
                color: AppTheme.primary,
              ),
              SizedBox(height: AppTheme.spacingSm),
              Text(
                'Tambah Foto Mobil',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppTheme.spacingXs),
              Text(
                'Ketuk untuk memilih dari kamera atau galeri',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}