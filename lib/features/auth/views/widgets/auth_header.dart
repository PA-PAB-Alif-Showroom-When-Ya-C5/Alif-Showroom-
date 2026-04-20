import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

/// Header visual untuk halaman auth (login & register).
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon Container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Icon(
            icon ?? Icons.directions_car_rounded,
            size: 44,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(height: AppTheme.spacingMd),

        // Judul
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppTheme.spacingXs),

        // Subjudul
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}