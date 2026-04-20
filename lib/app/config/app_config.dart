import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppConfig {
  AppConfig._();


  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    assert(value != null && value.isNotEmpty, 'SUPABASE_URL tidak ditemukan di .env');
    return value!;
  }

  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    assert(value != null && value.isNotEmpty, 'SUPABASE_ANON_KEY tidak ditemukan di .env');
    return value!;
  }


  static String get whatsappShowroom {
    final value = dotenv.env['WHATSAPP_SHOWROOM'];
    assert(value != null && value.isNotEmpty, 'WHATSAPP_SHOWROOM tidak ditemukan di .env');
    return value!;
  }

  static double get mapsLatitude {
    final value = dotenv.env['MAPS_LATITUDE'];
    assert(value != null && value.isNotEmpty, 'MAPS_LATITUDE tidak ditemukan di .env');
    return double.parse(value!);
  }

  static double get mapsLongitude {
    final value = dotenv.env['MAPS_LONGITUDE'];
    assert(value != null && value.isNotEmpty, 'MAPS_LONGITUDE tidak ditemukan di .env');
    return double.parse(value!);
  }

  static String get mapsLabel {
    final value = dotenv.env['MAPS_LABEL'];
    assert(value != null && value.isNotEmpty, 'MAPS_LABEL tidak ditemukan di .env');
    return value!;
  }
}