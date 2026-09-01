import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// A rounded pill showing an icon and a value, used for the gamification
/// counters (coins, keys, streaks, ...) in the Learn header.
///
/// The pill stretches to whatever width the parent gives it and centers its
/// contents, matching the evenly-divided header row in the Figma frames.
class AppStatPill extends StatelessWidget {
  const AppStatPill({
    required this.icon,
    required this.value,
    this.height = 44,
    super.key,
  });

  final Widget icon;
  final String value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: value,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: AppRadius.button,
        ),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(dimension: 26, child: icon),
              const SizedBox(width: 12),
              Text(
                value,
                style: AppTypography.label.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
