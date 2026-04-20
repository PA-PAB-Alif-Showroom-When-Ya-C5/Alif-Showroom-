import 'package:url_launcher/url_launcher.dart';

class MapsLauncher {
  MapsLauncher._();

  static const String showroomQuery = 'Showroom Mobil Alif Berkah Dua Bersaudara';

  static Future<bool> openLocation({
    required String query,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
    );

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> bukaLokasiShowroom() async {
    return openLocation(query: showroomQuery);
  }
}