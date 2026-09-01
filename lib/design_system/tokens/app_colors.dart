import 'package:flutter/material.dart';

/// Colors repeated across the audited mobile Figma frames.
abstract final class AppColors {
  static const primary = Color(0xFF507EFF);
  static const primaryDark = Color(0xFF1E52E3);
  static const primarySoft = Color(0xFF8E9BFF);

  /// Marks a completed step in gamified progress UI (learning path nodes,
  /// streak/reward accents).
  static const success = Color(0xFF3FBE72);

  static const surface = Color(0xFFFFFFFF);
  static const pageBackground = Color(0xFFF9FBFF);
  static const mutedSurface = Color(0xFFF4F6FA);
  static const subtleFill = Color(0x05131316);
  static const selectedFill = Color(0x1A507EFF);

  static const textPrimary = Color(0xFF131316);
  static const textSecondary = Color(0x80131316);
  static const textTertiary = Color(0xB3131316);

  /// Copy belonging to content the learner has not unlocked yet.
  static const textDisabled = Color(0x40131316);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryMuted = Color(0x4DFFFFFF);

  static const outline = Color(0x1A131316);
  static const subtleOutline = Color(0x0D131316);
}
