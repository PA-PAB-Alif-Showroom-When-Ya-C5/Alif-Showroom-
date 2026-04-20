import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDestructive ? AppTheme.error : AppTheme.primary,
            minimumSize: const Size(0, 44),
          ),
          onPressed: () {
            Get.back();
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}