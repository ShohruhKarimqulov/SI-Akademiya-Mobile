import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'learning_path_node.dart';

/// One stop on the [LearningPathTrail].
class LearningPathStep {
  const LearningPathStep({required this.state, this.assetPath});

  final LearningPathNodeState state;
  final String? assetPath;
}

/// Lays the learning path out as the snaking column of isometric tiles from
/// the Figma frames: nodes step centre → right → centre → left and repeat,
/// joined by rounded elbow connectors painted behind the tiles.
class LearningPathTrail extends StatelessWidget {
  const LearningPathTrail({required this.steps, super.key});

  final List<LearningPathStep> steps;

  /// Vertical distance between consecutive node centres.
  static const _stride = 100.0;

  /// Horizontal centre of each column, as a fraction of the trail width.
  static const _columns = [0.5, 0.81, 0.5, 0.19];

  static double _columnFraction(int index) => _columns[index % _columns.length];

  double get _height => (steps.length - 1) * _stride + LearningPathNode.height;

  /// A connector is only "lit" once the learner has reached the node it
  /// leads into; everything past the current lesson stays muted.
  static Color _connectorColor(LearningPathStep from, LearningPathStep to) =>
      switch (to.state) {
        LearningPathNodeState.completed => const Color(0xFF4ECB71),
        LearningPathNodeState.current => const Color(0xFF5A7BEA),
        LearningPathNodeState.locked => const Color(0xFFD8DCE2),
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final centers = [
          for (var index = 0; index < steps.length; index++)
            Offset(
              width * _columnFraction(index),
              index * _stride +
                  LearningPathNode.height -
                  LearningPathNode.tileHeight / 2,
            ),
        ];

        return SizedBox(
          width: width,
          height: _height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrailConnectorPainter(
                    centers: centers,
                    colors: [
                      for (var index = 1; index < steps.length; index++)
                        _connectorColor(steps[index - 1], steps[index]),
                    ],
                  ),
                ),
              ),
              for (var index = 0; index < steps.length; index++)
                Positioned(
                  left: centers[index].dx - LearningPathNode.width / 2,
                  top: index * _stride,
                  child: LearningPathNode(
                    state: steps[index].state,
                    assetPath: steps[index].assetPath,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TrailConnectorPainter extends CustomPainter {
  const _TrailConnectorPainter({required this.centers, required this.colors});

  final List<Offset> centers;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    const corner = 20.0;

    for (var index = 1; index < centers.length; index++) {
      final start = centers[index - 1];
      final end = centers[index];
      final paint = Paint()
        ..color = colors[index - 1]
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(start.dx, start.dy);
      if ((end.dx - start.dx).abs() < 1) {
        path.lineTo(end.dx, end.dy);
      } else {
        final direction = end.dx > start.dx ? 1.0 : -1.0;
        final midY = (start.dy + end.dy) / 2;
        path
          ..lineTo(start.dx, midY - corner)
          ..quadraticBezierTo(
            start.dx,
            midY,
            start.dx + corner * direction,
            midY,
          )
          ..lineTo(end.dx - corner * direction, midY)
          ..quadraticBezierTo(end.dx, midY, end.dx, midY + corner)
          ..lineTo(end.dx, end.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrailConnectorPainter oldDelegate) =>
      !listEquals(oldDelegate.centers, centers) ||
      !listEquals(oldDelegate.colors, colors);
}
