import 'package:flutter/material.dart';

/// The pixel-art sky → sea → meadow scene behind the learning path.
///
/// Figma ships this as a single tall pixel-art PNG. Until that asset is in
/// the project the same scene is approximated with its colour bands, so the
/// screen reads correctly; pass [assetPath] to swap the artwork in.
class PixelSceneBackdrop extends StatelessWidget {
  const PixelSceneBackdrop({required this.child, this.assetPath, super.key});

  final Widget child;
  final String? assetPath;

  static const _bands = [
    Color(0xFF7FC0EE), // upper sky
    Color(0xFF7FC0EE), // sky holds its tone most of the way down
    Color(0xFFA9D6F2), // haze
    Color(0xFFC9E4F5), // horizon
    Color(0xFF4E86CC), // sea
    Color(0xFF3A5FAF), // deep sea
    Color(0xFF2E4E86), // shoreline
    Color(0xFF90CB7B), // meadow
    Color(0xFF669E62), // far meadow
  ];

  static const _stops = [0.0, 0.42, 0.58, 0.66, 0.70, 0.755, 0.785, 0.815, 1.0];

  @override
  Widget build(BuildContext context) {
    final asset = assetPath;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: asset == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _bands,
                stops: _stops,
              )
            : null,
        image: asset == null
            ? null
            : DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
