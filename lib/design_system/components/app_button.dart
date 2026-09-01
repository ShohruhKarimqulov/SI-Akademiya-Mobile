import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

enum AppButtonVariant { primary, outlined }

/// The shared 46 px primary action used by authentication, profile, and quiz flows.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.height = 46,
    this.borderRadius = AppRadius.button,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.trailing,
    this.contentGap = 10,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final AppButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final double contentGap;

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == AppButtonVariant.outlined;

    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isOutlined ? AppColors.surface : AppColors.primary,
          foregroundColor: isOutlined
              ? AppColors.textPrimary
              : AppColors.onPrimary,
          disabledBackgroundColor: AppColors.mutedSurface,
          disabledForegroundColor: AppColors.textSecondary,
          side: isOutlined
              ? const BorderSide(color: AppColors.outline)
              : BorderSide.none,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: AppTypography.button,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: contentGap)],
            Text(label),
            if (trailing != null) ...[SizedBox(width: contentGap), trailing!],
          ],
        ),
      ),
    );
  }
}
