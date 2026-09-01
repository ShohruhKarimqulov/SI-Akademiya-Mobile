import 'package:flutter/material.dart';

/// Elevation presets repeated across the audited mobile Figma frames.
abstract final class AppShadows {
  /// Upward shadow used where a sheet rises over a backdrop.
  static const elevatedCard = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, -8), blurRadius: 20),
  ];

  /// Soft drop shadow for content cards resting on a page background.
  static const card = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 16),
  ];

  /// Stronger shadow for elements floating above scrolling content.
  static const floating = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 6), blurRadius: 24),
  ];
}
