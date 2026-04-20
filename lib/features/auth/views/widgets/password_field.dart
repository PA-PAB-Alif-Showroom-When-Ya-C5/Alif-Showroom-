import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';

/// TextField password dengan toggle visibilitas.
/// [isVisible] adalah RxBool dari controller — widget rebuild otomatis.
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isVisible;
  final VoidCallback onToggleVisibility;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final VoidCallback? onFieldSubmitted;

  const PasswordField({
    super.key,
    required this.controller,
    required this.isVisible,
    required this.onToggleVisibility,
    this.label = 'Password',
    this.hint,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextFormField(
        controller: controller,
        obscureText: !isVisible.value,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) => onFieldSubmitted?.call(),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint ?? 'Masukkan $label',
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppTheme.textSecondary,
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              isVisible.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    });
  }
}