import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/core/services/storage_service.dart';
import 'package:showroom_mobil/features/seller/pengajuan/repositories/pengajuan_repository.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';
import 'package:showroom_mobil/core/utils/text_normalizer.dart';
import 'package:showroom_mobil/core/utils/currency_helper.dart';

class PengajuanController extends GetxController {
  // ── Dependencies ─────────────────────────────────────────
  final _repo           = PengajuanRepository();
  final _storageService = StorageService();
  final _authService    = Get.find<AuthService>();

  // ── Form Key ─────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ── Text Controllers ──────────────────────────────────────
  final merekCtrl            = TextEditingController();
  final tipeModelCtrl        = TextEditingController();
  final tahunCtrl            = TextEditingController();
  final jarakTempuhCtrl      = TextEditingController();
  final hargaDiinginkanCtrl  = TextEditingController();
  final deskripsiKondisiCtrl = TextEditingController();
  final nomorWhatsappCtrl    = TextEditingController();

  // ── Dropdown State ────────────────────────────────────────
  final selectedTransmisi  = Rxn<Transmisi>();
  final selectedBahanBakar = Rxn<BahanBakar>();
  final selectedStatusStnk = Rxn<StatusStnk>();

  // ── Foto State ────────────────────────────────────────────
  final selectedImage = Rxn<File>();

  // ── Loading & Error ───────────────────────────────────────
  final isSubmitting  = false.obs;
  final submitError   = ''.obs;
  final errorMessage = ''.obs;

  // ── Pengajuan List (untuk RiwayatPage) ───────────────────
  final pengajuanList = <PengajuanModel>[].obs;
  final isLoadingList = false.obs;
  final selectedFilter = Rxn<StatusPengajuan>();

  // Tambahkan getter — filter di memori, tanpa query ulang
  List<PengajuanModel> get filteredList {
    final filter = selectedFilter.value;
    if (filter == null) return pengajuanList;
    return pengajuanList
        .where((e) => e.statusPengajuan == filter)
        .toList();
  }

  // Tambahkan method untuk set filter dari UI
  void setFilter(StatusPengajuan? status) {
    selectedFilter.value = status;
  }

  // ── Image Picker ──────────────────────────────────────────
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source:       source,
      maxWidth:     AppConstants.imageMaxWidth,
      maxHeight:    AppConstants.imageMaxHeight,
      imageQuality: AppConstants.imageQuality,
    );

    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // ── Submit Pengajuan ──────────────────────────────────────
    Future<void> submitPengajuan() async {
      submitError.value = '';

      // ── 1. Validasi Form ────────────────────────────────────
      final isFormValid = formKey.currentState?.validate() ?? false;
      if (!isFormValid) {
        _showErrorSnackbar('Periksa kembali isian form kamu.');
        return;
      }

      // ── 2. Validasi Dropdown ────────────────────────────────
      if (selectedTransmisi.value == null  ||
          selectedBahanBakar.value == null ||
          selectedStatusStnk.value == null) {
        _showErrorSnackbar('Pilih transmisi, bahan bakar, dan status STNK.');
        return;
      }

      // ── 3. Validasi Foto ─────────────────────────────────────
      if (selectedImage.value == null) {
        _showErrorSnackbar('Foto mobil wajib diunggah.');
        return;
      }

      // ── 4. Konfirmasi Dialog ─────────────────────────────────
      final confirmed = await _showConfirmDialog();
      if (confirmed != true) return;

      // ── 5. Mulai Proses Submit ───────────────────────────────
      isSubmitting.value = true;

      try {
        final sellerId = _authService.currentUserId;
        if (sellerId == null) {
          throw Exception('Sesi login tidak ditemukan. Silakan login ulang.');
        }

        // ── 6. Bangun Model dari Form ───────────────────────────
        final model = _buildModelFromForm(sellerId);

        // --- Step 7: Insert pengajuan ke database ---
        // Jika bagian ini gagal, proses akan langsung ke catch (e) di bawah
        final pengajuanId = await _repo.createPengajuan(model);

        // --- Step 8 & 9: Upload foto + update URL (DIPISAH) ---
        // Kita gunakan variabel flag untuk menentukan isi pesan snackbar nanti
        bool fotoTersimpan = false;
        
        try {
          final fotoUrl = await _storageService.uploadFotoPengajuan(
            file:        selectedImage.value!,
            pengajuanId: pengajuanId,
          );
          await _repo.updateFotoPengajuan(
            pengajuanId: pengajuanId,
            fotoUrl:     fotoUrl,
          );
          fotoTersimpan = true;
        } catch (fotoError) {
          // Ganti debugPrint biasa dengan log yang lebih detail
          debugPrint('[Foto Error] Tipe: ${fotoError.runtimeType}');
          debugPrint('[Foto Error] Pesan: $fotoError');
        }

        // ── 10. Sukses ──────────────────────────────────────────
        _resetForm();

        // Refresh daftar riwayat SEBELUM snackbar tampil
        await loadMyPengajuan();

        // Berikan feedback yang jujur kepada user
        _showSuccessSnackbar(
          fotoTersimpan
              ? 'Pengajuan berhasil dikirim!'
              : 'Pengajuan terkirim, namun foto gagal diunggah. Silakan hubungi admin.',
        );

      } catch (e) {
        // Catch ini menangkap kegagalan fatal (seperti kegagalan insert data utama)
        submitError.value = _parseError(e);
        _showErrorSnackbar(submitError.value);
      } finally {
        isSubmitting.value = false;
      }
    }

  // ── Load Daftar Pengajuan Seller ──────────────────────────
  Future<void> loadMyPengajuan() async {
    final sellerId = _authService.currentUserId;
    if (sellerId == null) return;

    isLoadingList.value = true;
    errorMessage.value  = '';

    try {
      final list = await _repo.getMySemua(sellerId);
      pengajuanList.assignAll(list);
    } catch (e) {
      errorMessage.value = _parseError(e);
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> refreshPengajuan() => loadMyPengajuan();

  // ── Private Helpers ───────────────────────────────────────

  PengajuanModel _buildModelFromForm(String sellerId) {
    return PengajuanModel(
      id:               '', 
      sellerId:         sellerId,
      merek:            TextNormalizer.toTitleCase(merekCtrl.text),
      tipeModel:        tipeModelCtrl.text.trim(),
      tahun:            int.tryParse(tahunCtrl.text.trim()) ?? 0,
      transmisi:        selectedTransmisi.value!,
      jarakTempuh: int.parse(
        jarakTempuhCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
      ),
      bahanBakar:       selectedBahanBakar.value!,
      hargaDiinginkan:  CurrencyHelper.parseToDouble(hargaDiinginkanCtrl.text),
      statusStnk:       selectedStatusStnk.value!,
      deskripsiKondisi: deskripsiKondisiCtrl.text.trim(),
      nomorWhatsapp:    nomorWhatsappCtrl.text.trim(),
      statusPengajuan:  StatusPengajuan.menunggu,
      dibuatPada:       DateTime.now(),
      diupdatePada:     DateTime.now(),
    );
  }
  Future<bool?> _showConfirmDialog() {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Pengajuan'),
        content: const Text(
          'Pastikan data yang kamu masukkan sudah benar.\n\n'
          'Pengajuan yang sudah dikirim tidak dapat diubah.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Kirim Sekarang'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    formKey.currentState?.reset();
    merekCtrl.clear();
    tipeModelCtrl.clear();
    tahunCtrl.clear();
    jarakTempuhCtrl.clear();
    hargaDiinginkanCtrl.clear();
    deskripsiKondisiCtrl.clear();
    nomorWhatsappCtrl.clear();
    selectedTransmisi.value  = null;
    selectedBahanBakar.value = null;
    selectedStatusStnk.value = null;
    selectedImage.value      = null;
    submitError.value        = '';
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: AppTheme.success,
      colorText:       Colors.white,
      icon:            const Icon(Icons.check_circle, color: Colors.white),
      duration:        const Duration(seconds: 3),
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(AppTheme.spacingMd),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Perhatian',
      message,
      backgroundColor: AppTheme.error,
      colorText:       Colors.white,
      icon:            const Icon(Icons.error_outline, color: Colors.white),
      duration:        const Duration(seconds: 4),
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(AppTheme.spacingMd),
    );
  }

  String _parseError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Gagal terhubung. Periksa koneksi internet kamu.';
    }
    if (msg.contains('row-level security') || msg.contains('rls')) {
      return 'Akses ditolak. Pastikan kamu sudah login sebagai seller.';
    }
    if (msg.contains('sesi login')) {
      return 'Sesi login tidak ditemukan. Silakan login ulang.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Isi nomor WA default dari profil seller jika tersedia
    final waFromProfil = _authService.currentUser?.namaLengkap;
    if (waFromProfil != null) {
      // Ganti dengan field nomor_whatsapp jika AuthUser menyimpannya
    }
    loadMyPengajuan();
  }

  @override
  void onClose() {
    merekCtrl.dispose();
    tipeModelCtrl.dispose();
    tahunCtrl.dispose();
    jarakTempuhCtrl.dispose();
    hargaDiinginkanCtrl.dispose();
    deskripsiKondisiCtrl.dispose();
    nomorWhatsappCtrl.dispose();
    super.onClose();
  }
}