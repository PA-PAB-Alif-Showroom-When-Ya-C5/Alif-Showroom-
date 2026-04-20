import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/features/admin/transaksi/controllers/transaksi_controller.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/core/utils/currency_input_formatter.dart';
import 'package:showroom_mobil/core/utils/app_input_formatter.dart';

class FormTransaksiPage extends StatelessWidget {
  const FormTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransaksiController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              _SectionLabel('Mobil yang Dijual'),
              const SizedBox(height: AppTheme.spacingSm),
              _PilihMobilDropdown(controller: controller),
              const SizedBox(height: AppTheme.spacingLg),


              _SectionLabel('Data Pembeli'),
              const SizedBox(height: AppTheme.spacingSm),

              TextFormField(
                controller: controller.namaPembeliCtrl,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  AppInputFormatter.textNoEmoji,
                ],
                validator: (value) => ValidatorHelper.textRequiredNoEmoji(
                  value,
                  fieldName: 'Nama pembeli',
                ),
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  hintText: 'Masukkan nama lengkap pembeli',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: controller.nomorPembeliCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidatorHelper.nomorPembeli,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP Pembeli',
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),


              _SectionLabel('Tanggal Transaksi'),
              const SizedBox(height: AppTheme.spacingSm),
              _TanggalPicker(controller: controller),
              const SizedBox(height: AppTheme.spacingLg),


              _SectionLabel('Rincian Harga'),
              const SizedBox(height: AppTheme.spacingSm),


              TextFormField(
                controller: controller.hargaModalCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidatorHelper.hargaModal,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Harga Modal',
                  hintText: 'Contoh: 150.000.000',
                  prefixIcon: Icon(Icons.money_outlined),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),


              TextFormField(
                controller: controller.hargaJualCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ValidatorHelper.hargaJual,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Harga Jual',
                  hintText: 'Contoh: 165.000.000',
                  prefixIcon: Icon(Icons.sell_outlined),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Harga Deal
              TextFormField(
                controller: controller.hargaDealCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => ValidatorHelper.hargaDeal(
                  value,
                  hargaModal: double.tryParse(
                        controller.hargaModalCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), ''),
                      ) ??
                      0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Harga Deal',
                  hintText: 'Harga kesepakatan',
                  prefixIcon: Icon(Icons.handshake_outlined),
                  prefixText: 'Rp ',
                  helperText:
                      'Jika tidak ada negosiasi, isi sama dengan harga jual',
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),


              _ProfitPreview(controller: controller),
              const SizedBox(height: AppTheme.spacingLg),


              _SectionLabel('Nota Transaksi'),
              const SizedBox(height: AppTheme.spacingSm),
              _NotaPicker(controller: controller),
              const SizedBox(height: AppTheme.spacingXl),


              Obx(() => ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.simpanTransaksi,
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_outlined),
                    label: Text(controller.isSaving.value
                        ? 'Menyimpan...'
                        : 'Simpan Transaksi'),
                  )),
              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}



class _PilihMobilDropdown extends StatelessWidget {
  final TransaksiController controller;
  const _PilihMobilDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.mobilTersediaList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.warning.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
          ),
          child: const Row(children: [
            Icon(Icons.warning_amber_outlined,
                color: AppTheme.warning, size: 20),
            SizedBox(width: AppTheme.spacingSm),
            Text('Tidak ada mobil dengan status tersedia.',
                style: TextStyle(color: AppTheme.warning, fontSize: 13)),
          ]),
        );
      }

      return DropdownButtonFormField<MobilModel>(
        value: controller.selectedMobil.value,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Pilih Mobil',
          prefixIcon: Icon(Icons.directions_car_outlined),
          helperText: 'Hanya menampilkan mobil berstatus Tersedia',
        ),
        items: controller.mobilTersediaList.map((mobil) {
          return DropdownMenuItem<MobilModel>(
            value: mobil,

            child: Text(
              '${mobil.merek} ${mobil.tipeModel} (${mobil.tahun})',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (v) => controller.selectedMobil.value = v,
        validator: (_) => controller.selectedMobil.value == null
            ? 'Pilih mobil terlebih dahulu'
            : null,
      );
    });
  }
}



class _TanggalPicker extends StatelessWidget {
  final TransaksiController controller;
  const _TanggalPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => controller.pilihTanggal(context),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Row(children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(controller.tanggalTransaksi.value),
                  style: const TextStyle(
                      fontSize: 15, color: AppTheme.textPrimary),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
            ]),
          ),
        ));
  }
}



class _ProfitPreview extends StatelessWidget {
  final TransaksiController controller;
  const _ProfitPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profit = controller.profitHitung.value;
      final isPositif = profit >= 0;
      final color = isPositif ? AppTheme.success : AppTheme.error;
      final fmt = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(
            isPositif
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              isPositif ? 'Estimasi Profit' : 'Potensi Rugi',
              style: TextStyle(fontSize: 12, color: color),
            ),
            Text(
              fmt.format(profit.abs()),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ]),
          const Spacer(),
          Text(
            '= Deal - Modal',
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.7)),
          ),
        ]),
      );
    });
  }
}



class _NotaPicker extends StatelessWidget {
  final TransaksiController controller;
  const _NotaPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fileName = controller.notaFileName.value;

      if (fileName != null) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.success.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.success.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Icon(Icons.insert_drive_file_outlined,
                color: AppTheme.success, size: 28),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('File terpilih',
                      style: TextStyle(fontSize: 11, color: AppTheme.success)),
                  Text(fileName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              onPressed: controller.removeNota,
              icon: const Icon(Icons.close, color: AppTheme.textHint, size: 20),
            ),
          ]),
        );
      }

      return GestureDetector(
        onTap: controller.pickNota,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: const Column(
            children: [
              Icon(Icons.upload_file_outlined,
                  size: 36, color: AppTheme.primary),
              SizedBox(height: AppTheme.spacingSm),
              Text('Upload Nota Transaksi',
                  style: TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.w600)),
              SizedBox(height: AppTheme.spacingXs),
              Text('PDF, JPG, atau PNG — Wajib',
                  style: TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
    });
  }
}



class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.primary,
        letterSpacing: 0.5,
      ));
}