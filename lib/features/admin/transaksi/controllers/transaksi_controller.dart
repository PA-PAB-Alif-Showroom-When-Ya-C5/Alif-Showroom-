import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/core/services/storage_service.dart';
import 'package:showroom_mobil/features/admin/transaksi/repositories/transaksi_repository.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';
import 'package:showroom_mobil/shared/models/transaksi_model.dart';
import 'package:showroom_mobil/core/utils/currency_helper.dart';

class TransaksiController extends GetxController {
  // ── Dependencies ─────────────────────────────────────────
  final _repo           = TransaksiRepository();
  final _storageService = StorageService();
  final _authService    = Get.find<AuthService>();

  // ── Form ─────────────────────────────────────────────────
  final formKey          = GlobalKey<FormState>();
  final namaPembeliCtrl  = TextEditingController();
  final nomorPembeliCtrl = TextEditingController();
  final hargaModalCtrl   = TextEditingController();
  final hargaJualCtrl    = TextEditingController();
  final hargaDealCtrl    = TextEditingController();

  // ── State: Daftar Transaksi ───────────────────────────────
  final transaksiList = <TransaksiModel>[].obs;
  final isLoading     = false.obs;
  final errorMessage  = ''.obs;

  // ── State: Form ───────────────────────────────────────────
  final mobilTersediaList  = <MobilModel>[].obs;
  final selectedMobil      = Rxn<MobilModel>();
  final selectedNota       = Rxn<File>();
  final notaFileName       = RxnString();
  final isSaving           = false.obs;
  final profitHitung       = 0.0.obs;
  final tanggalTransaksi   = Rx<DateTime>(DateTime.now());

  // ── Computed: Total Profit ────────────────────────────────
  double get totalProfit => transaksiList.fold(
      0.0, (sum, t) => sum + t.profit);

  @override
  void onInit() {
    super.onInit();
    loadTransaksi();

    // Auto-hitung profit saat harga berubah
    hargaDealCtrl.addListener(_hitungProfit);
    hargaModalCtrl.addListener(_hitungProfit);
  }

  @override
  void onClose() {
    namaPembeliCtrl.dispose();
    nomorPembeliCtrl.dispose();
    hargaModalCtrl.dispose();
    hargaJualCtrl.dispose();
    hargaDealCtrl.dispose();
    super.onClose();
  }

  // ── Load Daftar Transaksi ─────────────────────────────────
  Future<void> loadTransaksi() async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final list = await _repo.getAll();
      transaksiList.assignAll(list);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data transaksi.';
      debugPrint('[Transaksi] $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadTransaksi();

  // ── Navigasi & Detail ──────────────────────────────────────
  
  void keDetailTransaksi(TransaksiModel transaksi) {
    Get.toNamed(
      AppRoutes.detailTransaksi,
      arguments: transaksi,
    );
  }

  Future<void> keFormTransaksi() async {
    _resetForm();
    await _loadMobilTersedia();
    Get.toNamed(AppRoutes.formTransaksi);
  }

  // ── Action: Hapus Transaksi ────────────────────────────────
  
  Future<void> hapusTransaksi(TransaksiModel transaksi) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text(
          'Transaksi akan dihapus dan status mobil akan dikembalikan menjadi Tersedia.\n\nLanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      isLoading.value = true;
      await _repo.deleteTransaksiDanKembalikanStatusMobil(
        transaksiId: transaksi.id,
        mobilId: transaksi.mobilId,
      );

      // Jika user menghapus dari layar detail, maka balik ke list
      if (Get.currentRoute == AppRoutes.detailTransaksi) {
        Get.back();
      }

      await loadTransaksi();
      _showSuccess('Transaksi berhasil dihapus.');
    } catch (e) {
      _showError('Gagal menghapus transaksi.');
      debugPrint('[Transaksi] Hapus error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Repository Helpers ─────────────────────────────────────

  Future<void> _loadMobilTersedia() async {
    try {
      final list = await _repo.getMobilTersedia();
      mobilTersediaList.assignAll(list);
    } catch (e) {
      debugPrint('[Transaksi] Load mobil tersedia gagal: $e');
    }
  }

  // ── Pilih Nota ────────────────────────────────────────────
  Future<void> pickNota() async {
    final result = await FilePicker.platform.pickFiles(
      type:           FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      selectedNota.value  = File(result.files.single.path!);
      notaFileName.value  = result.files.single.name;
    }
  }

  void removeNota() {
    selectedNota.value  = null;
    notaFileName.value  = null;
  }

  // ── Hitung Profit Otomatis ────────────────────────────────
  void _hitungProfit() {
    final modal = double.tryParse(
        hargaModalCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final deal  = double.tryParse(
        hargaDealCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''))  ?? 0;
    profitHitung.value = deal - modal;
  }

  // ── Pilih Tanggal Transaksi ───────────────────────────────
  Future<void> pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context:      context,
      initialDate:  tanggalTransaksi.value,
      firstDate:    DateTime(2020),
      lastDate:     DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:    AppTheme.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) tanggalTransaksi.value = picked;
  }

  // ── Simpan Transaksi ───────────────────────────────────────
  Future<void> simpanTransaksi() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedMobil.value == null) {
      _showError('Pilih mobil yang akan dijual.');
      return;
    }
    
    if (selectedNota.value == null) {
      _showError('Nota transaksi wajib diunggah.');
      return;
    }

    final modal = CurrencyHelper.parseToDouble(hargaModalCtrl.text);
    final jual  = CurrencyHelper.parseToDouble(hargaJualCtrl.text);
    final deal  = CurrencyHelper.parseToDouble(hargaDealCtrl.text);

    if (deal < modal) {
      _showError('Harga deal tidak boleh lebih kecil dari harga modal.');
      return;
    }

    final confirmed = await _showKonfirmasiDialog(
      mobil: selectedMobil.value!,
      modal: modal,
      jual: jual,
      deal: deal,
      profit: deal - modal,
    );
    if (confirmed != true) return;

    isSaving.value = true;

    try {
      final adminId = _authService.currentUserId!;
      final tempFileName = DateTime.now().millisecondsSinceEpoch.toString();
      
      final notaUrl = await _storageService.uploadNotaTransaksi(
        file: selectedNota.value!,
        transaksiId: tempFileName,
      );

      final transaksi = TransaksiModel(
        id: '',
        mobilId: selectedMobil.value!.id,
        namaPembeli: namaPembeliCtrl.text.trim(),
        nomorPembeli: nomorPembeliCtrl.text.trim(),
        hargaModal: modal,
        hargaJual: jual,
        hargaDeal: deal,
        profit: deal - modal,
        notaTransaksi: notaUrl,
        tanggalTransaksi: tanggalTransaksi.value,
        dibuatOleh: adminId,
        dibuatPada: DateTime.now(),
        diupdatePada: DateTime.now(),
      );

      await _repo.createTransaksi(transaksi);

      _resetForm();
      Get.back(); 
      await loadTransaksi();
      _showSuccess('Transaksi berhasil disimpan.');

    } catch (e) {
      _showError(_parseError(e));
      debugPrint('[Transaksi] Simpan error: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // ── Private Helpers ───────────────────────────────────────
  void _resetForm() {
    formKey.currentState?.reset();
    namaPembeliCtrl.clear();
    nomorPembeliCtrl.clear();
    hargaModalCtrl.clear();
    hargaJualCtrl.clear();
    hargaDealCtrl.clear();
    selectedMobil.value    = null;
    selectedNota.value     = null;
    notaFileName.value     = null;
    profitHitung.value     = 0;
    tanggalTransaksi.value = DateTime.now();
  }

  Future<bool?> _showKonfirmasiDialog({
    required MobilModel mobil,
    required double     modal,
    required double     jual,
    required double     deal,
    required double     profit,
  }) {
    final fmt = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Get.dialog<bool>(
      AlertDialog(
        title:   const Text('Konfirmasi Transaksi'),
        content: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Periksa ringkasan transaksi:',
                style: TextStyle(color: AppTheme.textSecondary,
                    fontSize: 13)),
            const SizedBox(height: AppTheme.spacingMd),
            _KonfirmasiRow('Mobil',
                '${mobil.merek} ${mobil.tipeModel} (${mobil.tahun})'),
            _KonfirmasiRow('Pembeli',
                namaPembeliCtrl.text.trim()),
            _KonfirmasiRow('Harga Modal', fmt.format(modal)),
            _KonfirmasiRow('Harga Jual',  fmt.format(jual)),
            _KonfirmasiRow('Harga Deal',  fmt.format(deal)),
            const Divider(),
            _KonfirmasiRow('Profit',      fmt.format(profit),
                isHighlight: true),
            const SizedBox(height: AppTheme.spacingSm),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color:        AppTheme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                    AppTheme.radiusSm),
                border: Border.all(
                    color: AppTheme.warning.withOpacity(0.3)),
              ),
              child: const Row(children: [
                Icon(Icons.info_outline,
                    color: AppTheme.warning, size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Status mobil akan otomatis berubah menjadi Terjual.',
                    style: TextStyle(
                        fontSize: 12, color: AppTheme.warning),
                  ),
                ),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:     const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child:     const Text('Simpan Transaksi'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String msg) => Get.snackbar(
    'Berhasil', msg,
    backgroundColor: AppTheme.success,
    colorText:       Colors.white,
    snackPosition:   SnackPosition.BOTTOM,
    margin:          const EdgeInsets.all(AppTheme.spacingMd),
  );

  void _showError(String msg) => Get.snackbar(
    'Gagal', msg,
    backgroundColor: AppTheme.error,
    colorText:       Colors.white,
    snackPosition:   SnackPosition.BOTTOM,
    margin:          const EdgeInsets.all(AppTheme.spacingMd),
    duration:        const Duration(seconds: 4),
  );

  String _parseError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('sudah terjual')) {
      return 'Mobil ini sudah terjual. Pilih mobil lain.';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'Gagal terhubung. Periksa koneksi internet.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}

// Helper widget tetap diletakkan di luar class controller
class _KonfirmasiRow extends StatelessWidget {
  final String label;
  final String value;
  final bool   isHighlight;
  const _KonfirmasiRow(this.label, this.value,
      {this.isHighlight = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text('$label:',
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary)),
        ),
        Expanded(
          child: Text(value,
              style: TextStyle(
                fontSize:   13,
                fontWeight: isHighlight
                    ? FontWeight.bold : FontWeight.w500,
                color: isHighlight
                    ? AppTheme.success : AppTheme.textPrimary,
              )),
        ),
      ],
    ),
  );
}