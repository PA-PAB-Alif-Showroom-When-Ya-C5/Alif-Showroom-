import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/enums/app_enums.dart';
import 'package:showroom_mobil/features/admin/pengajuan/repositories/kelola_pengajuan_repository.dart';
import 'package:showroom_mobil/shared/models/pengajuan_model.dart';

class KelolaPengajuanController extends GetxController {
  final _repo = KelolaPengajuanRepository();

  // ── State List ────────────────────────────────────────────
  final pengajuanList        = <PengajuanModel>[].obs;
  final isLoading            = false.obs;
  final errorMessage         = ''.obs;
  final selectedFilter       = Rxn<StatusPengajuan>();

  // ── State Detail / Edit ───────────────────────────────────
  final selectedPengajuan    = Rxn<PengajuanModel>();
  final selectedStatus       = Rxn<StatusPengajuan>();
  final catatanCtrl          = TextEditingController();
  final isSaving             = false.obs;

  // ── Computed: list terfilter ──────────────────────────────
  List<PengajuanModel> get filteredList {
    final filter = selectedFilter.value;
    if (filter == null) return pengajuanList;
    return pengajuanList
        .where((p) => p.statusPengajuan == filter)
        .toList();
  }

  // ── Hitung per status untuk badge ────────────────────────
  int countByStatus(StatusPengajuan status) =>
      pengajuanList.where((p) => p.statusPengajuan == status).length;

  @override
  void onInit() {
    super.onInit();
    loadPengajuan();
  }

  @override
  void onClose() {
    catatanCtrl.dispose();
    super.onClose();
  }

  // ── Load Data ─────────────────────────────────────────────
  Future<void> loadPengajuan() async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final list = await _repo.getAll();
      pengajuanList.assignAll(list);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data pengajuan.';
      debugPrint('[KelolaPengajuan] $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => loadPengajuan();

  // ── Filter ────────────────────────────────────────────────
  void setFilter(StatusPengajuan? status) {
    selectedFilter.value = status;
  }

  // ── Buka Detail ───────────────────────────────────────────
  void bukaDetail(PengajuanModel pengajuan) {
    selectedPengajuan.value = pengajuan;
    selectedStatus.value    = pengajuan.statusPengajuan;
    catatanCtrl.text        = pengajuan.catatanAdmin ?? '';
    Get.toNamed(AppRoutes.detailPengajuanAdmin);
  }

  // ── Simpan Perubahan Status + Catatan ─────────────────────
  Future<void> simpanPerubahan() async {
    final pengajuan = selectedPengajuan.value;
    final status    = selectedStatus.value;
    if (pengajuan == null || status == null) return;

    // Cek apakah ada perubahan
    final statusBerubah  = status != pengajuan.statusPengajuan;
    final catatanBerubah =
        catatanCtrl.text.trim() != (pengajuan.catatanAdmin ?? '').trim();

    if (!statusBerubah && !catatanBerubah) {
      Get.snackbar(
        'Tidak Ada Perubahan',
        'Ubah status atau catatan terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        margin:        const EdgeInsets.all(AppTheme.spacingMd),
      );
      return;
    }

    // Dialog konfirmasi
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title:   const Text('Konfirmasi Perubahan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perubahan yang akan disimpan:'),
            const SizedBox(height: 8),
            if (statusBerubah)
              _InfoRow(
                label: 'Status',
                value: '${pengajuan.statusPengajuan.label} '
                    '→ ${status.label}',
              ),
            if (catatanBerubah)
              _InfoRow(
                label: 'Catatan',
                value: catatanCtrl.text.trim().isEmpty
                    ? '(dihapus)'
                    : catatanCtrl.text.trim(),
              ),
          ],
        ),
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
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await _repo.updateStatusDanCatatan(
        pengajuanId: pengajuan.id,
        status:      status,
        catatan:     catatanCtrl.text,
      );

      // Update data lokal agar tidak perlu reload full
      final updated = PengajuanModel(
        id:               pengajuan.id,
        sellerId:         pengajuan.sellerId,
        merek:            pengajuan.merek,
        tipeModel:        pengajuan.tipeModel,
        tahun:            pengajuan.tahun,
        transmisi:        pengajuan.transmisi,
        jarakTempuh:      pengajuan.jarakTempuh,
        bahanBakar:       pengajuan.bahanBakar,
        hargaDiinginkan:  pengajuan.hargaDiinginkan,
        statusStnk:       pengajuan.statusStnk,
        deskripsiKondisi: pengajuan.deskripsiKondisi,
        fotoMobil:        pengajuan.fotoMobil,
        nomorWhatsapp:    pengajuan.nomorWhatsapp,
        statusPengajuan:  status,
        catatanAdmin:     catatanCtrl.text.trim().isEmpty
            ? null
            : catatanCtrl.text.trim(),
        dibuatPada:       pengajuan.dibuatPada,
        diupdatePada:     DateTime.now(),
      );

      // Update di list
      final index = pengajuanList.indexWhere((p) => p.id == pengajuan.id);
      if (index != -1) pengajuanList[index] = updated;

      // Update selected agar detail page ikut refresh
      selectedPengajuan.value = updated;

      Get.back(); // kembali ke daftar
      _showSuccess('Pengajuan berhasil diperbarui.');
    } catch (e) {
      _showError('Gagal menyimpan perubahan. Coba lagi.');
      debugPrint('[KelolaPengajuan] Simpan error: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────
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
}

// Helper widget kecil untuk dialog konfirmasi
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text('$label:',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}