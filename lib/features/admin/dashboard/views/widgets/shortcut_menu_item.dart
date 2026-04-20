import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

class ShortcutMenuItem extends StatelessWidget {
  final String       label;
  final IconData     icon;
  final Color        color;
  final VoidCallback onTap;
  final int?         badgeCount;

  const ShortcutMenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Icon dengan badge opsional
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width:  52,
                  height: 52,
                  decoration: BoxDecoration(
                    color:        color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),

                // Badge notifikasi
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top:   -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20, minHeight: 20,
                      ),
                      child: Text(
                        badgeCount! > 99 ? '99+' : '$badgeCount',
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Label
            Text(
              label,
              style: const TextStyle(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines:  2,
            ),
          ],
        ),
      ),
    );
  }
}