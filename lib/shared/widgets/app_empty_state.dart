import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_rounded,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: AppTheme.textHint,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: AppTheme.spacingLg),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}