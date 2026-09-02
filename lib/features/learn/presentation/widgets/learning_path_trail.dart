import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import 'learning_path_node.dart';

/// One stop on the [LearningPathTrail].
class LearningPathStep {
  const LearningPathStep({
    required this.state,
    required this.left,
    required this.top,
  });

  final LearningPathNodeState state;
  final double left;
  final double top;
}

/// The Figma map's right-angle connector paths, painted below the exported
/// node illustrations.
class LearningPathTrail extends StatelessWidget {
  const LearningPathTrail({
    required this.steps,
    required this.height,
    this.onStepTap,
    super.key,
  });

  final List<LearningPathStep> steps;
  final double height;
  final ValueChanged<int>? onStepTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _TrailPainter(steps: steps),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                for (var index = 0; index < steps.length; index++)
                  Positioned(
                    left: steps[index].left,
                    top: steps[index].top,
                    width: LearningPathNode.width,
                    height: LearningPathNode.height,
                    child: LearningPathNode(
                      state: steps[index].state,
                      onTap:
                          onStepTap == null ||
                              steps[index].state == LearningPathNodeState.locked
                          ? null
                          : () => onStepTap!(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
    );
  }
}

class _TrailPainter extends CustomPainter {
  const _TrailPainter({required this.steps});

  final List<LearningPathStep> steps;

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < steps.length - 1; index++) {
      final from = steps[index];
      final to = steps[index + 1];
      final movesLeft = to.left < from.left;
      final movesRight = to.left > from.left;
      final start = movesLeft
          ? Offset(from.left + 12, from.top + LearningPathNode.height - 28)
          : movesRight
          ? Offset(
              from.left + LearningPathNode.width - 12,
              from.top + LearningPathNode.height - 28,
            )
          : Offset(
              from.left + LearningPathNode.width / 2,
              from.top + LearningPathNode.height - 13,
            );
      final end = Offset(to.left + LearningPathNode.width / 2, to.top + 16);

      final paint = Paint()
        ..color = _segmentColor(from.state, to.state)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      const corner = 20.0;
      final horizontalLength = (end.dx - start.dx).abs();
      final verticalLength = (end.dy - start.dy).abs();
      final horizontalDirection = end.dx >= start.dx ? 1.0 : -1.0;
      final verticalDirection = end.dy >= start.dy ? 1.0 : -1.0;
      final usableCorner = [
        corner,
        verticalLength / 2,
        horizontalLength / 2,
      ].reduce((smallest, value) => smallest < value ? smallest : value);
      final path = Path()..moveTo(start.dx, start.dy);

      if ((end.dx - start.dx).abs() < 1) {
        path.lineTo(end.dx, end.dy);
      } else {
        path
          ..lineTo(end.dx - usableCorner * horizontalDirection, start.dy)
          ..quadraticBezierTo(
            end.dx,
            start.dy,
            end.dx,
            start.dy + usableCorner * verticalDirection,
          )
          ..lineTo(end.dx, end.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) =>
      !listEquals(oldDelegate.steps, steps);

  Color _segmentColor(LearningPathNodeState from, LearningPathNodeState to) {
    if (from == LearningPathNodeState.completed &&
        to == LearningPathNodeState.completed) {
      return AppColors.success;
    }
    if (from == LearningPathNodeState.current ||
        to == LearningPathNodeState.current) {
      return AppColors.primary;
    }
    return AppColors.surface.withValues(alpha: 0.9);
  }
}
