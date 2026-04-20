import 'package:url_launcher/url_launcher.dart';

class WhatsappLauncher {
  WhatsappLauncher._();

  static const String adminPhoneNumber = '6282250668665';

  static Future<bool> openChat({
    required String phoneNumber,
    required String message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse(
      'https://wa.me/$phoneNumber?text=$encodedMessage',
    );

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> tanyaKatalog() async {
    return openChat(
      phoneNumber: adminPhoneNumber,
      message:
          'Halo, saya ingin bertanya mengenai katalog mobil di showroom. Apakah bisa dibantu?',
    );
  }

  static Future<bool> tanyaMobil({
    required String namaMobil,
  }) async {
    return openChat(
      phoneNumber: adminPhoneNumber,
      message:
          'Halo, saya tertarik dengan mobil $namaMobil yang ada di aplikasi showroom. Apakah unitnya masih tersedia?',
    );
  }
}