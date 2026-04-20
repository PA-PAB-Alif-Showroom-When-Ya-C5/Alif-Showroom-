import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/app/bindings/initial_binding.dart';
import 'package:showroom_mobil/app/config/app_config.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_pages.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: false,
  );

  runApp(const ShowroomMobilApp());
}

class ShowroomMobilApp extends StatelessWidget {
  const ShowroomMobilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Showroom Mobil',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),

      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,

      defaultTransition: Transition.fadeIn,
      transitionDuration: AppConstants.animationNormal,

      locale: const Locale('id', 'ID'),
      fallbackLocale: const Locale('id', 'ID'),
    );
  }
}