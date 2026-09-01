import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';

/// A rounded fractional-fill progress track, shared by any screen that
/// shows completion as a single continuous bar (profile setup, lesson
/// modules, ...). Provide either [fillColor] or [fillGradient].
class AppLinearProgressBar extends StatelessWidget {
  const AppLinearProgressBar({
    required this.value,
    this.fillColor,
    this.fillGradient,
    this.height = 10,
    this.trackColor = AppColors.mutedSurface,
    this.borderRadius = AppRadius.button,
    this.animationDuration = const Duration(milliseconds: 360),
    this.trackKey,
    this.fillKey,
    super.key,
  }) : assert(
         fillColor != null || fillGradient != null,
         'Provide a fillColor or a fillGradient.',
       );

  final double value;
  final Color? fillColor;
  final Gradient? fillGradient;
  final double height;
  final Color trackColor;
  final BorderRadiusGeometry borderRadius;
  final Duration animationDuration;
  final Key? trackKey;
  final Key? fillKey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        key: trackKey,
        // Fill the available width even under loose constraints, otherwise
        // the Stack would collapse around its zero-size track child.
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: BoxDecoration(color: trackColor)),
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                key: fillKey,
                duration: animationDuration,
                curve: Curves.easeInOutCubic,
                widthFactor: value.clamp(0.0, 1.0),
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fillColor,
                    gradient: fillGradient,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
