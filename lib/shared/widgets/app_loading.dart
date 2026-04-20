import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final double size;
  final bool expanded;

  const AppLoading({
    super.key,
    this.message,
    this.size = 28,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppTheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );

    if (!expanded) return Center(child: content);

    return Expanded(
      child: Center(child: content),
    );
  }
}