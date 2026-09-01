import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Where a [LearningPathNode] sits relative to the learner's progress.
enum LearningPathNodeState {
  /// Finished lesson — green tile carrying a trophy.
  completed,

  /// The learner's next lesson — glowing blue tile carrying the mascot.
  current,

  /// Not unlocked yet — pale tile carrying a padlocked door.
  locked,
}

/// Palette for one isometric tile: the lit top face, the recessed inner
/// face, and the extruded side wall beneath it.
class _TilePalette {
  const _TilePalette({
    required this.top,
    required this.inner,
    required this.side,
    this.glow,
  });

  final Color top;
  final Color inner;
  final Color side;
  final Color? glow;

  static const completed = _TilePalette(
    top: Color(0xFF4ECB71),
    inner: Color(0xFF3DB75F),
    side: Color(0xFF2C8F49),
  );

  static const current = _TilePalette(
    top: Color(0xFF4E7BF0),
    inner: Color(0xFF3E66DE),
    side: Color(0xFF2A47AE),
    glow: Color(0x804E9BFF),
  );

  static const locked = _TilePalette(
    top: Color(0xFFF2F2F5),
    inner: Color(0xFFE6E6EB),
    side: Color(0xFFD2D2DA),
  );
}

/// A single diamond-shaped stop on the gamified learning path.
///
/// The tile itself is drawn so the screen is complete without art assets.
/// The Figma frames use bespoke 3D renders on top of these tiles — pass
/// [assetPath] once those PNGs are added and the illustration replaces the
/// painted glyph, keeping the same footprint.
class LearningPathNode extends StatelessWidget {
  const LearningPathNode({
    required this.state,
    this.assetPath,
    this.onTap,
    super.key,
  });

  final LearningPathNodeState state;
  final String? assetPath;
  final VoidCallback? onTap;

  /// Footprint of one node slot, in design-canvas units.
  static const width = 134.0;
  static const height = 104.0;

  /// Height of the isometric tile alone, measured from the node's bottom.
  static const tileHeight = 80.0;

  String get _semanticLabel => switch (state) {
    LearningPathNodeState.completed => 'Tugatilgan dars',
    LearningPathNodeState.current => 'Joriy dars',
    LearningPathNodeState.locked => 'Yopiq dars',
  };

  _TilePalette get _palette => switch (state) {
    LearningPathNodeState.completed => _TilePalette.completed,
    LearningPathNodeState.current => _TilePalette.current,
    LearningPathNodeState.locked => _TilePalette.locked,
  };

  IconData get _glyph => switch (state) {
    LearningPathNodeState.completed => Icons.emoji_events_rounded,
    LearningPathNodeState.current => Icons.smart_toy_rounded,
    LearningPathNodeState.locked => Icons.lock_rounded,
  };

  Color get _glyphColor => switch (state) {
    LearningPathNodeState.completed => const Color(0xFFF2B735),
    LearningPathNodeState.current => Colors.white,
    LearningPathNodeState.locked => const Color(0xFF9A9AA5),
  };

  @override
  Widget build(BuildContext context) {
    final asset = assetPath;

    return Semantics(
      button: onTap != null,
      label: _semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: height,
          child: asset != null
              ? Image.asset(asset, fit: BoxFit.contain)
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _IsometricTilePainter(palette: _palette),
                      ),
                    ),
                    Positioned(
                      bottom: tileHeight * 0.34,
                      child: Icon(_glyph, size: 40, color: _glyphColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Paints the extruded isometric diamond: a glow (when present), the side
/// wall, the lit top face, and a recessed inner face.
class _IsometricTilePainter extends CustomPainter {
  const _IsometricTilePainter({required this.palette});

  final _TilePalette palette;

  static Path _roundedPolygon(List<Offset> points, double radius) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      final previous = points[(i - 1 + points.length) % points.length];
      final next = points[(i + 1) % points.length];

      final toPrevious = previous - current;
      final toNext = next - current;
      final entry =
          current +
          toPrevious /
              toPrevious.distance *
              math.min(radius, toPrevious.distance / 2);
      final exit =
          current +
          toNext / toNext.distance * math.min(radius, toNext.distance / 2);

      if (i == 0) {
        path.moveTo(entry.dx, entry.dy);
      } else {
        path.lineTo(entry.dx, entry.dy);
      }
      path.quadraticBezierTo(current.dx, current.dy, exit.dx, exit.dy);
    }
    return path..close();
  }

  static List<Offset> _diamond(Rect rect) => [
    Offset(rect.center.dx, rect.top),
    Offset(rect.right, rect.center.dy),
    Offset(rect.center.dx, rect.bottom),
    Offset(rect.left, rect.center.dy),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const depth = 14.0;
    const faceHeight = LearningPathNode.tileHeight - depth;
    final faceRect = Rect.fromLTWH(
      0,
      size.height - LearningPathNode.tileHeight,
      size.width,
      faceHeight,
    );
    final radius = size.width * 0.13;

    final glow = palette.glow;
    if (glow != null) {
      canvas.drawPath(
        _roundedPolygon(_diamond(faceRect.inflate(6)), radius),
        Paint()
          ..color = glow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Side wall: the same diamond pushed down, unioned with the top face so
    // only the extruded band remains visible behind it.
    final topFace = _roundedPolygon(_diamond(faceRect), radius);
    final bottomFace = _roundedPolygon(
      _diamond(faceRect.shift(const Offset(0, depth))),
      radius,
    );
    canvas
      ..drawPath(
        Path.combine(PathOperation.union, topFace, bottomFace),
        Paint()..color = palette.side,
      )
      ..drawPath(topFace, Paint()..color = palette.top)
      ..drawPath(
        _roundedPolygon(
          _diamond(faceRect.deflate(faceRect.height * 0.16)),
          radius * 0.7,
        ),
        Paint()..color = palette.inner,
      );
  }

  @override
  bool shouldRepaint(covariant _IsometricTilePainter oldDelegate) =>
      oldDelegate.palette != palette;
}
