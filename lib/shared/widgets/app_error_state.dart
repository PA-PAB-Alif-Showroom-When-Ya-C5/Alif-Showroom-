import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Terjadi Kesalahan',
    required this.message,
    this.buttonText = 'Coba Lagi',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppTheme.error,
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
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingLg),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: Text(buttonText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}