import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// The pixel-art sky, sea and meadow scene exported from the Learn frame.
/// Figma softens the scroll area with a 20% primary overlay and a 5px
/// background blur beginning at y=118.
class PixelSceneBackdrop extends StatelessWidget {
  const PixelSceneBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/learn/map_background.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
          cacheWidth: 468,
        ),
        Positioned(
          top: 118,
          left: 0,
          right: 0,
          bottom: 8,
          child: ColoredBox(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child,
      ],
    );
  }
}
