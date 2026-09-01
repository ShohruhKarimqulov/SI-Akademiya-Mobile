import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// The 46 px outlined field used by the authentication form.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onSuffixPressed,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onSuffixPressed;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        style: AppTypography.bodySmall,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: SizedBox.square(dimension: 20, child: prefixIcon),
                ),
          suffixIcon: suffixIcon == null
              ? null
              : Semantics(
                  button: onSuffixPressed != null,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onSuffixPressed,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 16),
                      child: SizedBox.square(dimension: 20, child: suffixIcon),
                    ),
                  ),
                ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 46,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 46,
          ),
          filled: true,
          fillColor: AppColors.subtleFill,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 11,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: AppColors.subtleOutline),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          border: const OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: AppColors.subtleOutline),
          ),
        ),
      ),
    );
  }
}
