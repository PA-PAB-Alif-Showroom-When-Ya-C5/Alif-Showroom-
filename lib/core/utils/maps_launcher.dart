import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class MapsLauncher {
  MapsLauncher._();

  // Koordinat showroom Alif Berkah Dua Bersaudara
  static const double _latitude  = -0.48936850015611866;
  static const double _longitude = 117.1653145890167;
  static const String _namaShowroom = 'Alif Berkah Dua Bersaudara';

  // ── Public Method ────────────────────────────────────────

  static Future<void> bukaLokasiShowroom() async {
    await _bukaMaps(
      latitude:  _latitude,
      longitude: _longitude,
      nama:      _namaShowroom,
    );
  }

  // ── Core Logic ───────────────────────────────────────────

  static Future<void> _bukaMaps({
    required double latitude,
    required double longitude,
    required String nama,
  }) async {
    final namaEncoded = Uri.encodeComponent(nama);

    final daftarUrl = [

      'geo:$latitude,$longitude?q=$latitude,$longitude($namaEncoded)',

      'https://www.google.com/maps/search/'
      '?api=1&query=$latitude,$longitude',
    ];

    for (final urlString in daftarUrl) {
      final berhasil = await _cobaLaunch(urlString);
      if (berhasil) return;
    }

    _tampilSnackbarGagal(
      judul: 'Maps Tidak Bisa Dibuka',
      pesan: 'Pastikan Google Maps sudah terinstall '
             'atau coba lagi beberapa saat.',
    );
  }

  static Future<bool> _cobaLaunch(String urlString) async {
    try {
      final uri = Uri.parse(urlString);

      final bisaDibuka = await canLaunchUrl(uri);

      if (bisaDibuka) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return true;
    } catch (e) {
      debugPrint('[MapsLauncher] Gagal: $urlString | Error: $e');
      return false;
    }
  }

  static void _tampilSnackbarGagal({
    required String judul,
    required String pesan,
  }) {
    Get.snackbar(
      judul,
      pesan,
      backgroundColor: Colors.red.shade600,
      colorText:       Colors.white,
      icon:            const Icon(
        Icons.location_off_outlined,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin:        const EdgeInsets.all(16),
      duration:      const Duration(seconds: 4),
    );
  }
}