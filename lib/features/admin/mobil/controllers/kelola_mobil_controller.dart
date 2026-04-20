import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/core/services/storage_service.dart';
import 'package:showroom_mobil/features/admin/mobil/repositories/mobil_repository.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/core/utils/text_normalizer.dart';
import 'package:showroom_mobil/core/utils/currency_helper.dart';

class KelolaMobilController extends GetxController {
  // ── Dependencies ─────────────────────────────────────────
  final _repo           = MobilRepository();
  final _storageService = StorageService();
  final _authService    = Get.find<AuthService>();

  // ── Form ─────────────────────────────────────────────────
  final formKey          = GlobalKey<FormState>();
  final merekCtrl        = TextEditingController();
  final tipeModelCtrl    = TextEditingController();
  final tahunCtrl        = TextEditingController();
  final hargaCtrl        = TextEditingController();
  final jarakTempuhCtrl  = TextEditingController();
  final warnaCtrl        = TextEditingController();
  final deskripsiCtrl    = TextEditingController();

  // ── Dropdown State ────────────────────────────────────────
  final selectedTransmisi  = Rxn<Transmisi>();
  final selectedBahanBakar = Rxn<BahanBakar>();
  final selectedStatusStnk = Rxn<StatusStnk>();
  final selectedStatusMobil = Rx<StatusMobil>(StatusMobil.tersedia);

  // ── Foto ─────────────────────────────────────────────────
  final selectedImage   = Rxn<File>();
  final existingFotoUrl = RxnString();  // URL foto lama saat edit

  // ── List & State ─────────────────────────────────────────
  final mobilList    = <MobilModel>[].obs;
  final isLoading    = false.obs;
  final isSaving     = false.obs;
  final errorMessage = ''.obs;
  final editingMobil = Rxn<MobilModel>();  // null = mode tambah

  bool get isEditMode => editingMobil.value != null;

  // ── Filter ────────────────────────────────────────────────
  final selectedFilterStatus = Rxn<StatusMobil>();

  List<MobilModel> get filteredList {
    final filter = selectedFilterStatus.value;
    if (filter == null) return mobilList;
    return mobilList
        .where((m) => m.statusMobil == filter)
        .toList();
  }

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadMobil();
  }

  @override
  void onClose() {
    merekCtrl.dispose();
    tipeModelCtrl.dispose();
    tahunCtrl.dispose();
    hargaCtrl.dispose();
    jarakTempuhCtrl.dispose();
    warnaCtrl.dispose();
    deskripsiCtrl.dispose();
    super.onClose();
  }

  // ── Load Data ─────────────────────────────────────────────
  Future<void> loadMobil() async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final list = await _repo.getAll();
      mobilList.assignAll(list);
    } catch (e) {
      debugPrint('ERROR LOAD MOBIL: $e');
      errorMessage.value = 'Gagal memuat data mobil.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMobil() => loadMobil();

  // ── Navigasi ke Form ──────────────────────────────────────
  void keHalamanTambah() {
    _resetForm();
    editingMobil.value = null;
    Get.toNamed(AppRoutes.tambahMobil);
  }

  void keHalamanEdit(MobilModel mobil) {
    _resetForm();
    editingMobil.value    = mobil;
    existingFotoUrl.value = mobil.fotoMobil;
    _populateForm(mobil);
    Get.toNamed(AppRoutes.editMobil);
  }

  // ── Image Picker ──────────────────────────────────────────
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
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
    selectedImage.value   = null;
    existingFotoUrl.value = null;
  }

  // ── Simpan (Tambah / Edit) ────────────────────────────────
  Future<void> simpanMobil() async {
    // ── Validasi form ───────────────────────────────────────
    if (!formKey.currentState!.validate()) return;
    if (selectedImage.value == null) {
      Get.snackbar(
        'Gagal',
        'Foto mobil wajib diunggah.',
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(AppTheme.spacingMd),
      );
      return;
    }
    if (selectedTransmisi.value  == null ||
        selectedBahanBakar.value == null ||
        selectedStatusStnk.value == null) {
      _showError('Pilih transmisi, bahan bakar, dan status STNK.');
      return;
    }

    // ── Dialog konfirmasi ───────────────────────────────────
    final confirmed = await _showConfirmDialog(
      title:   isEditMode ? 'Simpan Perubahan' : 'Tambah Mobil',
      message: isEditMode
          ? 'Apakah kamu yakin ingin menyimpan perubahan data mobil ini?'
          : 'Apakah kamu yakin ingin menambahkan mobil ini ke showroom?',
    );
    if (confirmed != true) return;

    isSaving.value = true;

    try {
      final adminId = _authService.currentUserId!;
      final model   = _buildModel(adminId);

      if (isEditMode) {
        // ── Edit ──────────────────────────────────────────
        await _repo.update(editingMobil.value!.id, model);

        if (selectedImage.value != null) {
          final fotoUrl = await _storageService.uploadFotoMobil(
            file:    selectedImage.value!,
            mobilId: editingMobil.value!.id,
          );
          await _repo.updateFoto(editingMobil.value!.id, fotoUrl);
        }

        // 1. Kembali dulu ke halaman sebelumnya
        Get.back();

        // 2. Refresh list setelah halaman kembali aktif
        await loadMobil();

        // 3. Tampilkan snackbar setelah navigasi selesai
        _showSuccess('Berhasil memperbarui data mobil.');

      } else {
        // ── Tambah ────────────────────────────────────────
        final mobilId = await _repo.create(model);

        if (selectedImage.value != null) {
          try {
            final fotoUrl = await _storageService.uploadFotoMobil(
              file:    selectedImage.value!,
              mobilId: mobilId,
            );
            await _repo.updateFoto(mobilId, fotoUrl);
          } catch (fotoError) {
            debugPrint('[KelolaMobil] Upload foto gagal: $fotoError');
          }
        }

        // 1. Reset form sebelum kembali
        _resetForm();

        // 2. Kembali ke halaman daftar mobil
        Get.back();

        // 3. Refresh list setelah halaman kembali aktif
        await loadMobil();

        // 4. Tampilkan snackbar setelah navigasi selesai
        _showSuccess('Berhasil menambahkan mobil.');
      }

    } catch (e) {
      // Error ditampilkan tanpa navigasi — user tetap di form
      _showError(_parseError(e));
    } finally {
      isSaving.value = false;
    }
  }

  // ── Hapus Mobil ───────────────────────────────────────────
  Future<void> hapusMobil(MobilModel mobil) async {
    final confirmed = await _showConfirmDialog(
      title:        'Hapus Mobil',
      message:      'Hapus ${mobil.merek} ${mobil.tipeModel}?\n\n'
                    'Tindakan ini tidak bisa dibatalkan.',
      confirmLabel: 'Hapus',
      isDanger:     true,
    );
    if (confirmed != true) return;

    try {
      await _repo.delete(mobil.id);
      mobilList.removeWhere((m) => m.id == mobil.id);
      _showSuccess('Mobil berhasil dihapus.');
    } catch (e) {
      _showError(_parseError(e));
    }
  }

  // ── Filter ────────────────────────────────────────────────
  void setFilter(StatusMobil? status) {
    selectedFilterStatus.value = status;
  }

  // ── Private Helpers ───────────────────────────────────────
  MobilModel _buildModel(String adminId) {
    return MobilModel(
      id:           '',
      merek: TextNormalizer.toTitleCase(merekCtrl.text),
      tipeModel:    tipeModelCtrl.text.trim(),
      tahun:        int.parse(tahunCtrl.text.trim()),
      transmisi:    selectedTransmisi.value!,
      harga: CurrencyHelper.parseToDouble(hargaCtrl.text),
      jarakTempuh:  int.parse(
                      jarakTempuhCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')),
      bahanBakar:   selectedBahanBakar.value!,
      warna:        warnaCtrl.text.trim(),
      statusStnk:   selectedStatusStnk.value!,
      deskripsi:    deskripsiCtrl.text.trim().isEmpty
                      ? null
                      : deskripsiCtrl.text.trim(),
      statusMobil:  selectedStatusMobil.value,
      dibuatOleh:   adminId,
      dibuatPada:   DateTime.now(),
      diupdatePada: DateTime.now(),
    );
  }

  void _populateForm(MobilModel mobil) {
    merekCtrl.text       = mobil.merek;
    tipeModelCtrl.text   = mobil.tipeModel;
    tahunCtrl.text       = mobil.tahun.toString();
    hargaCtrl.text       = mobil.harga.toStringAsFixed(0);
    jarakTempuhCtrl.text = mobil.jarakTempuh.toString();
    warnaCtrl.text       = mobil.warna;
    deskripsiCtrl.text   = mobil.deskripsi ?? '';
    selectedTransmisi.value   = mobil.transmisi;
    selectedBahanBakar.value  = mobil.bahanBakar;
    selectedStatusStnk.value  = mobil.statusStnk;
    selectedStatusMobil.value = mobil.statusMobil;
  }

  void _resetForm() {
    formKey.currentState?.reset();
    merekCtrl.clear();
    tipeModelCtrl.clear();
    tahunCtrl.clear();
    hargaCtrl.clear();
    jarakTempuhCtrl.clear();
    warnaCtrl.clear();
    deskripsiCtrl.clear();
    selectedTransmisi.value   = null;
    selectedBahanBakar.value  = null;
    selectedStatusStnk.value  = null;
    selectedStatusMobil.value = StatusMobil.tersedia;
    selectedImage.value       = null;
    existingFotoUrl.value     = null;
    editingMobil.value        = null;
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = 'Ya, Simpan',
    bool   isDanger     = false,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title:   Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:     const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? AppTheme.error : AppTheme.primary,
            ),
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String pesan) {
    Get.snackbar(
      'Berhasil', pesan,
      backgroundColor: AppTheme.success,
      colorText:       Colors.white,
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(AppTheme.spacingMd),
    );
  }

  void _showError(String pesan) {
    Get.snackbar(
      'Gagal', pesan,
      backgroundColor: AppTheme.error,
      colorText:       Colors.white,
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(AppTheme.spacingMd),
      duration:        const Duration(seconds: 4),
    );
  }

  String _parseError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('tidak bisa dihapus')) {
      return e.toString().replaceAll('Exception: ', '');
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Gagal terhubung. Periksa koneksi internet.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}