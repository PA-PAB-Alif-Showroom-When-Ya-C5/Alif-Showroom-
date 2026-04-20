import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/constants/app_constants.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';

/// Halaman splash yang tampil pertama kali saat aplikasi dibuka.
/// Fungsinya: tampilkan logo, tunggu auth service, lalu navigasi.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigateAfterDelay();
  }

  void _setupAnimation() {
    _animController = AnimationController(
      vsync: this,
      duration: AppConstants.animationSlow,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    // Tunggu splash duration selesai
    await Future.delayed(AppConstants.splashDuration);

    if (!mounted) return;

    final authService = Get.find<AuthService>();

    // Arahkan berdasarkan status login dan role
    if (!authService.isLoggedIn) {
      Get.offAllNamed(AppRoutes.guestHome);
    } else if (authService.isAdmin) {
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else if (authService.isSeller) {
      Get.offAllNamed(AppRoutes.sellerDashboard);
    } else {
      // Fallback — harusnya tidak terjadi
      Get.offAllNamed(AppRoutes.guestHome);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder — ganti dengan asset logo asli
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  size: 60,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),

              const Text(
                'Showroom Mobil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              Text(
                'Temukan Mobil Impianmu',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl * 2),

              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.7),
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}