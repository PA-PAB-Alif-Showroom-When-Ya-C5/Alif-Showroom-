import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/features/guest/repositories/guest_repository.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';

class GuestController extends GetxController {
  final _repo = GuestRepository();


  final _semuaMobil    = <MobilModel>[].obs;


  final mobilTerbaru   = <MobilModel>[].obs;


  final mobilFiltered  = <MobilModel>[].obs;


  final isLoadingHome  = false.obs;
  final isLoadingKatalog = false.obs;
  final errorHome      = ''.obs;
  final errorKatalog   = ''.obs;


  final searchQuery    = ''.obs;
  final filterTahunMin = Rxn<int>();
  final filterTahunMax = Rxn<int>();
  final filterHargaMin = Rxn<double>();
  final filterHargaMax = Rxn<double>();


  final searchCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadMobilTerbaru();


    debounce(
      searchQuery,
      (_) => _applyFilter(),
      time: AppConstants.searchDebounce,
    );
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }


  Future<void> loadMobilTerbaru() async {
    isLoadingHome.value = true;
    errorHome.value     = '';
    try {
      final list = await _repo.getMobilTerbaru();
      mobilTerbaru.assignAll(list);
    } catch (e) {
      errorHome.value = 'Gagal memuat data.';
      debugPrint('[Guest] loadMobilTerbaru: $e');
    } finally {
      isLoadingHome.value = false;
    }
  }


  Future<void> loadKatalog() async {
    isLoadingKatalog.value = true;
    errorKatalog.value     = '';
    try {
      final list = await _repo.getMobilTersedia();
      _semuaMobil.assignAll(list);
      _applyFilter();
    } catch (e) {
      errorKatalog.value = 'Gagal memuat katalog.';
      debugPrint('[Guest] loadKatalog: $e');
    } finally {
      isLoadingKatalog.value = false;
    }
  }


  void _applyFilter() {
    var result = _semuaMobil.toList();


    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((m) =>
          m.merek.toLowerCase().contains(q) ||
          m.tipeModel.toLowerCase().contains(q)).toList();
    }


    final tMin = filterTahunMin.value;
    final tMax = filterTahunMax.value;
    if (tMin != null) result = result.where((m) => m.tahun >= tMin).toList();
    if (tMax != null) result = result.where((m) => m.tahun <= tMax).toList();


    final hMin = filterHargaMin.value;
    final hMax = filterHargaMax.value;
    if (hMin != null) result = result.where((m) => m.harga >= hMin).toList();
    if (hMax != null) result = result.where((m) => m.harga <= hMax).toList();

    mobilFiltered.assignAll(result);
  }


  void setSearch(String query) => searchQuery.value = query;

  void setFilterTahun({int? min, int? max}) {
    filterTahunMin.value = min;
    filterTahunMax.value = max;
    _applyFilter();
  }

  void setFilterHarga({double? min, double? max}) {
    filterHargaMin.value = min;
    filterHargaMax.value = max;
    _applyFilter();
  }

  void resetFilter() {
    searchQuery.value    = '';
    filterTahunMin.value = null;
    filterTahunMax.value = null;
    filterHargaMin.value = null;
    filterHargaMax.value = null;
    searchCtrl.clear();
    _applyFilter();
  }

  bool get hasActiveFilter =>
      searchQuery.value.isNotEmpty       ||
      filterTahunMin.value != null       ||
      filterTahunMax.value != null       ||
      filterHargaMin.value != null       ||
      filterHargaMax.value != null;

  Future<void> refreshKatalog() => loadKatalog();
  Future<void> refreshBeranda() => loadMobilTerbaru();
}