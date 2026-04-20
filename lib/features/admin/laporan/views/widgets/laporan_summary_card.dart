import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class LaporanSummaryCard extends StatelessWidget {
  final String   label;
  final String   value;
  final String?  subtitle;
  final IconData icon;
  final Color    color;

  const LaporanSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:       MainAxisSize.min,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingXs),
              decoration: BoxDecoration(
                color:        color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                    fontSize: 11,
                    color:    AppTheme.textSecondary,
                  ),
                  maxLines:  2,
                  overflow:  TextOverflow.ellipsis),
            ),
          ]),
          const SizedBox(height: AppTheme.spacingSm),
          Text(value,
              style: TextStyle(
                fontSize:   18,
                fontWeight: FontWeight.bold,
                color:      color,
              ),
              maxLines:  1,
              overflow:  TextOverflow.ellipsis),
          if (subtitle != null)
            Text(subtitle!,
                style: const TextStyle(
                  fontSize: 10,
                  color:    AppTheme.textHint,
                ),
                maxLines:  1,
                overflow:  TextOverflow.ellipsis),
        ],
      ),
    );
  }
}