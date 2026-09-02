import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// A glass pill showing an icon and a value, used for the gamification
/// counters (coins, keys, streaks, ...) that float over the Learn scene.
///
/// Figma "Glass": fill #131316 @5%, 1px #FFFFFF @20% rim, radius 30,
/// height 56, over a background blur.
class AppStatPill extends StatelessWidget {
  const AppStatPill({
    required this.icon,
    required this.value,
    this.height = 56,
    super.key,
  });

  final Widget icon;
  final String value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: value,
      child: ClipRRect(
        borderRadius: AppRadius.choice,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: AppRadius.choice,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20, height: 20, child: Center(child: icon)),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: AppTypography.label.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
