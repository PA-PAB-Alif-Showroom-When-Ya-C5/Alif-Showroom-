import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class WhatsappLauncher {
  WhatsappLauncher._();

  static const String _nomorAdmin = '6282250668665';

  // ── Public Methods ──────────────────────────────────────

  static Future<void> tanyaKatalog() async {
    const pesan =
        'Halo, saya ingin bertanya mengenai katalog mobil '
        'di showroom Alif Berkah Dua Bersaudara. '
        'Apakah bisa dibantu?';
    await _bukaWhatsapp(_nomorAdmin, pesan);
  }

  static Future<void> tanyaMobil(String namaMobil) async {
    final pesan =
        'Halo, saya tertarik dengan mobil $namaMobil yang ada '
        'di aplikasi showroom Alif Berkah Dua Bersaudara. '
        'Apakah unitnya masih tersedia?';
    await _bukaWhatsapp(_nomorAdmin, pesan);
  }

  static Future<void> hubungiSebagaiSeller() async {
    const pesan =
        'Halo, saya ingin menjual mobil ke showroom '
        'Alif Berkah Dua Bersaudara. '
        'Bisa dibantu informasi prosedurnya?';
    await _bukaWhatsapp(_nomorAdmin, pesan);
  }

  // ── Core Logic ───────────────────────────────────────────

  static Future<void> _bukaWhatsapp(
    String nomor,
    String pesan,
  ) async {
    final encoded = Uri.encodeComponent(pesan);
    final daftarUrl = [
      'whatsapp://send?phone=$nomor&text=$encoded',
      'https://wa.me/$nomor?text=$encoded',
      'https://api.whatsapp.com/send?phone=$nomor&text=$encoded',
    ];

    for (final urlString in daftarUrl) {
      final berhasil = await _cobaLaunch(urlString);
      if (berhasil) return;
    }
      _tampilSnackbarGagal(
        judul:   'WhatsApp Tidak Bisa Dibuka',
        pesan:   'Pastikan WhatsApp sudah terinstall '
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
      debugPrint('[WhatsappLauncher] Gagal: $urlString | Error: $e');
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
        Icons.warning_amber_rounded,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin:        const EdgeInsets.all(16),
      duration:      const Duration(seconds: 4),
    );
  }
}