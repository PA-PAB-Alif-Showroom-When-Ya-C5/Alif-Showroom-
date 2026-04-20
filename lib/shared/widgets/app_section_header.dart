import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: AppTheme.spacingMd),
          action!,
        ],
      ],
    );
  }
}