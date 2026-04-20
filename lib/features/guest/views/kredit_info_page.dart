import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/core/utils/whatsapp_launcher.dart';

class KreditInfoPage extends StatelessWidget {
  const KreditInfoPage({super.key});

  static const _imagePath = 'assets/images/kredit_info.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:           const Text('Info Pengajuan Kredit'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon:      const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [

          TextButton.icon(
            onPressed: WhatsappLauncher.tanyaKatalog,
            icon:  const Icon(Icons.chat_outlined,
                color: Colors.white, size: 18),
            label: const Text('Tanya',
                style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
      body: InteractiveViewer(

        minScale:   0.8,
        maxScale:   4.0,
        child: SingleChildScrollView(
          child: Column(
            children: [


              Image.asset(
                _imagePath,
                width:     double.infinity,
                fit:       BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => _GambarError(),
              ),


              Container(
                width:   double.infinity,
                color:   Colors.white,
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: ElevatedButton.icon(
                  onPressed: WhatsappLauncher.tanyaKatalog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingMd),
                  ),
                  icon:  const Icon(Icons.chat_outlined),
                  label: const Text(
                    'Tanya Info Kredit via WhatsApp',
                    style: TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GambarError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      height:  400,
      color:   AppTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined,
              size:  64,
              color: AppTheme.textHint.withOpacity(0.5)),
          const SizedBox(height: AppTheme.spacingMd),
          const Text(
            'Gambar tidak tersedia',
            style: TextStyle(color: AppTheme.textHint),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          const Text(
            'Pastikan file kredit_info.jpg\nada di assets/images/',
            style: TextStyle(
                fontSize: 12, color: AppTheme.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}