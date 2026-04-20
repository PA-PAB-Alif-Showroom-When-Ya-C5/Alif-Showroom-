// lib/features/seller/profil/controllers/profil_controller.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/core/services/storage_service.dart';
import 'package:showroom_mobil/features/seller/profil/repositories/profil_repository.dart';
import 'package:showroom_mobil/shared/models/profil_pengguna_model.dart';

class ProfilController extends GetxController {
  final _repo           = ProfilRepository();
  final _storageService = StorageService();
  final _authService    = Get.find<AuthService>();

  final formKey        = GlobalKey<FormState>();
  final namaCtrl       = TextEditingController();
  final waCtrl         = TextEditingController();

  final profil         = Rxn<ProfilPenggunaModel>();
  final isLoading      = false.obs;
  final isSaving       = false.obs;
  final isEditMode     = false.obs;
  final selectedImage  = Rxn<File>();
  final errorMessage   = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfil();
  }

  @override
  void onClose() {
    namaCtrl.dispose();
    waCtrl.dispose();
    super.onClose();
  }

  Future<void> loadProfil() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    isLoading.value    = true;
    errorMessage.value = '';

    try {
      final data = await _repo.getProfilById(userId);
      profil.value = data;
      _populateForm(data);
    } catch (e) {
      errorMessage.value = 'Gagal memuat profil. Periksa koneksi kamu.';
    } finally {
      isLoading.value = false;
    }
  }

  void enterEditMode() {
    _populateForm(profil.value);   // reset form ke data saat ini
    isEditMode.value = true;
  }

  void cancelEditMode() {
    isEditMode.value    = false;
    selectedImage.value = null;
    formKey.currentState?.reset();
    _populateForm(profil.value);
  }

  Future<void> saveProfil() async {
    if (!formKey.currentState!.validate()) return;

    final userId = _authService.currentUserId;
    if (userId == null) return;

    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    isSaving.value = true;

    try {
      await _repo.updateProfil(
        userId:        userId,
        namaLengkap:   namaCtrl.text,
        nomorWhatsapp: waCtrl.text,
      );

      if (selectedImage.value != null) {
        final fotoUrl = await _storageService.uploadFotoProfil(
          file:   selectedImage.value!,
          userId: userId,
        );
        await _repo.updateFotoProfil(userId: userId, fotoUrl: fotoUrl);
      }

      await loadProfil();

      isEditMode.value    = false;
      selectedImage.value = null;

      _showSnackbar(
        judul:   'Berhasil',
        pesan:   'Profil berhasil diperbarui.',
        isError: false,
      );
    } catch (e) {
      _showSnackbar(
        judul:   'Gagal',
        pesan:   'Tidak dapat menyimpan perubahan. Coba lagi.',
        isError: true,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> pickFotoProfil(ImageSource source) async {
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

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title:   const Text('Keluar'),
        content: const Text('Kamu akan keluar dari akun seller.\nLanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:     const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.guestHome);
  }

  void _populateForm(ProfilPenggunaModel? data) {
    if (data == null) return;
    namaCtrl.text   = data.namaLengkap;
    waCtrl.text     = data.nomorWhatsapp;
  }

  Future<bool?> _showConfirmDialog() {
    return Get.dialog<bool>(
      AlertDialog(
        title:   const Text('Simpan Perubahan'),
        content: const Text('Apakah kamu yakin ingin menyimpan perubahan profil?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:     const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child:     const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar({
    required String judul,
    required String pesan,
    required bool   isError,
  }) {
    Get.snackbar(
      judul,
      pesan,
      backgroundColor: isError ? AppTheme.error : AppTheme.success,
      colorText:       Colors.white,
      snackPosition:   SnackPosition.BOTTOM,
      margin:          const EdgeInsets.all(AppTheme.spacingMd),
      duration:        const Duration(seconds: 3),
    );
  }
}