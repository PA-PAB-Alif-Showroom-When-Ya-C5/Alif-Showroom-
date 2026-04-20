import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/admin/laporan/repositories/laporan_repository.dart';
import 'package:showroom_mobil/shared/models/laporan_model.dart';

class LaporanController extends GetxController {
  final _repo = LaporanRepository();

  // ── Filter State ──────────────────────────────────────────
  final tahunList      = <int>[].obs;
  final selectedTahun  = DateTime.now().year.obs;
  final selectedBulan  = Rxn<int>();   // null = semua bulan

  // ── Data State ────────────────────────────────────────────
  final laporanBulanan  = <LaporanBulananModel>[].obs;
  final merekTerlaris   = <MerekTerlaris>[].obs;
  final isLoading       = false.obs;
  final isExporting     = false.obs;
  final errorMessage    = ''.obs;

  // ── Computed Summary ──────────────────────────────────────
  int    get totalTransaksi     => laporanBulanan.fold(0,
      (s, e) => s + e.jumlahTransaksi);
  int    get totalMobilTerjual  => laporanBulanan.fold(0,
      (s, e) => s + e.jumlahMobilTerjual);
  double get totalPenjualan     => laporanBulanan.fold(0.0,
      (s, e) => s + e.totalPenjualan);
  double get totalProfit        => laporanBulanan.fold(0.0,
      (s, e) => s + e.totalProfit);

  // ── Nama bulan yang dipilih untuk label ──────────────────
  static const _namaBulan = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  String get labelPeriode {
    final b = selectedBulan.value;
    final t = selectedTahun.value;
    if (b == null) return 'Semua Bulan $t';
    return '${_namaBulan[b]} $t';
  }

  @override
  void onInit() {
    super.onInit();
    _initTahun();
  }

  // ── Inisialisasi: load tahun dulu, baru load data ────────
  Future<void> _initTahun() async {
    try {
      final list = await _repo.getTahunTersedia();
      tahunList.assignAll(list);
      if (list.isNotEmpty) selectedTahun.value = list.first;
    } catch (_) {
      tahunList.assignAll([DateTime.now().year]);
    }
    await loadLaporan();
  }

  // ── Load Data Laporan ─────────────────────────────────────
  Future<void> loadLaporan() async {
    isLoading.value    = true;
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _repo.getLaporanBulanan(
          tahun: selectedTahun.value,
          bulan: selectedBulan.value,
        ),
        _repo.getMerekTerlaris(
          tahun: selectedTahun.value,
          bulan: selectedBulan.value,
        ),
      ]);

      laporanBulanan.assignAll(
          results[0] as List<LaporanBulananModel>);
      merekTerlaris.assignAll(
          results[1] as List<MerekTerlaris>);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data laporan.';
      debugPrint('[Laporan] $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => loadLaporan();

  // ── Set Filter Tahun ──────────────────────────────────────
  Future<void> setTahun(int tahun) async {
    selectedTahun.value = tahun;
    await loadLaporan();
  }

  // ── Set Filter Bulan ──────────────────────────────────────
  Future<void> setBulan(int? bulan) async {
    selectedBulan.value = bulan;
    await loadLaporan();
  }

  // ── Export ke Excel ───────────────────────────────────────
  Future<void> exportExcel() async {
    if (laporanBulanan.isEmpty) {
      Get.snackbar('Tidak Ada Data',
          'Tidak ada data untuk diekspor pada periode ini.',
          snackPosition: SnackPosition.BOTTOM,
          margin:        const EdgeInsets.all(AppTheme.spacingMd));
      return;
    }

    isExporting.value = true;
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Laporan Penjualan'];

      // Hapus sheet default
      excel.delete('Sheet1');

      // ── Header ─────────────────────────────────────────
      final headers = [
        'Tahun', 'Bulan', 'Jumlah Transaksi',
        'Mobil Terjual', 'Total Penjualan (Rp)', 'Total Profit (Rp)',
      ];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(bold: true);
      }

      // ── Data ───────────────────────────────────────────
      for (var r = 0; r < laporanBulanan.length; r++) {
        final item = laporanBulanan[r];
        final values = [
          IntCellValue(item.tahun),
          TextCellValue(_namaBulan[item.bulan]),
          IntCellValue(item.jumlahTransaksi),
          IntCellValue(item.jumlahMobilTerjual),
          DoubleCellValue(item.totalPenjualan),
          DoubleCellValue(item.totalProfit),
        ];
        for (var c = 0; c < values.length; c++) {
          sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: c, rowIndex: r + 1))
            .value = values[c];
        }
      }

      // ── Total row ──────────────────────────────────────
      final totalRow = laporanBulanan.length + 1;
      sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: 0, rowIndex: totalRow))
        .value = TextCellValue('TOTAL');
      sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: 2, rowIndex: totalRow))
        .value = IntCellValue(totalTransaksi);
      sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: 3, rowIndex: totalRow))
        .value = IntCellValue(totalMobilTerjual);
      sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: 4, rowIndex: totalRow))
        .value = DoubleCellValue(totalPenjualan);
      sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: 5, rowIndex: totalRow))
        .value = DoubleCellValue(totalProfit);

      // ── Simpan dan share ───────────────────────────────
      final dir      = await getTemporaryDirectory();
      final fileName =
          'laporan_${selectedTahun.value}'
          '${selectedBulan.value != null
              ? '_bulan${selectedBulan.value}'
              : ''}.xlsx';
      final filePath = '${dir.path}/$fileName';
      final bytes    = excel.encode()!;
      await File(filePath).writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Laporan Penjualan $labelPeriode',
        text: 'Laporan Penjualan $labelPeriode',
      );
      Get.snackbar(
        'Berhasil',
        'File Excel berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(AppTheme.spacingMd),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Export',
        'Tidak dapat membuat file Excel.',
        backgroundColor: AppTheme.error,
        colorText:       Colors.white,
        snackPosition:   SnackPosition.BOTTOM,
        margin:          const EdgeInsets.all(AppTheme.spacingMd),
      );
      debugPrint('[Laporan] Export error: $e');
    } finally {
      isExporting.value = false;
    }
  }
}