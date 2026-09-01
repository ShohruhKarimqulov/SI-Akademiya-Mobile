import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// The repeated blue gradient-and-glow backdrop used by entry flows.
class AppBrandBackdrop extends StatelessWidget {
  const AppBrandBackdrop({super.key});

  static const _rotation = -34.3 * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: AppColors.primary)),
        _DecorativeGlow(
          assetPath: 'assets/images/splash/highlight.png',
          center: Offset(487.238, 0),
          size: Size(1185.622, 1091),
          angle: _rotation,
          blurSigma: 150,
        ),
        _DecorativeGlow(
          assetPath: 'assets/images/splash/shade.png',
          center: Offset(122.238, 893.818),
          size: Size(1085.622, 991),
          angle: _rotation,
          blurSigma: 125,
        ),
      ],
    );
  }
}

class _DecorativeGlow extends StatelessWidget {
  const _DecorativeGlow({
    required this.assetPath,
    required this.center,
    required this.size,
    required this.angle,
    required this.blurSigma,
  });

  final String assetPath;
  final Offset center;
  final Size size;
  final double angle;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: center.dx - size.width / 2,
      top: center.dy - size.height / 2,
      width: size.width,
      height: size.height,
      child: ExcludeSemantics(
        child: Transform.rotate(
          angle: angle,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
            ),
            child: Image.asset(assetPath, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
