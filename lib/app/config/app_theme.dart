import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary      = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color accent       = Color(0xFFFF6F00);
  static const Color success      = Color(0xFF2E7D32);
  static const Color error        = Color(0xFFC62828);
  static const Color warning      = Color(0xFFF57F17);
  static const Color info         = Color(0xFF0277BD);
  static const Color background   = Color(0xFFF5F5F5);
  static const Color surface      = Colors.white;
  static const Color textPrimary  = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint     = Color(0xFFBDBDBD);
  static const Color divider      = Color(0xFFEEEEEE);


  static const Color statusMenunggu  = Color(0xFFF57F17);
  static const Color statusDiproses  = Color(0xFF0277BD);
  static const Color statusDiterima  = Color(0xFF2E7D32);
  static const Color statusDitolak   = Color(0xFFC62828);
  static const Color statusTersedia  = Color(0xFF2E7D32);
  static const Color statusTerjual   = Color(0xFF757575);


  static const double spacingXs  = 4.0;
  static const double spacingSm  = 8.0;
  static const double spacingMd  = 16.0;
  static const double spacingLg  = 24.0;
  static const double spacingXl  = 32.0;


  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 16.0;
  static const double radiusFull = 100.0;


  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;


  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        surface: surface,
        background: background,
        error: error,
      ),


      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),


      scaffoldBackgroundColor: background,


      cardTheme: CardThemeData(
        elevation: elevationSm,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm,
        ),
      ),


      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),


      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),


      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textHint),
        errorStyle: const TextStyle(color: error),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: background,
        selectedColor: primary.withOpacity(0.15),
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: elevationMd,
      ),

      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
    );
  }
}