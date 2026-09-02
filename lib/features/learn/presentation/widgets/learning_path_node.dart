import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// Where a [LearningPathNode] sits relative to the learner's progress.
enum LearningPathNodeState {
  /// Finished lesson — green tile carrying a trophy.
  completed,

  /// The learner's next lesson — glowing blue tile carrying the mascot.
  current,

  /// Not unlocked yet — pale tile carrying a padlock.
  locked,
}

/// A single stop on the gamified learning path.
///
/// Each state renders the illustration exported straight out of Figma —
/// the PNG already is the finished isometric tile, so nothing is redrawn
/// here. [_NodeFallback] only appears if an asset is missing.
class LearningPathNode extends StatelessWidget {
  const LearningPathNode({required this.state, this.onTap, super.key});

  final LearningPathNodeState state;
  final VoidCallback? onTap;

  /// Figma exports every path stop at 120px wide. Their transparent image
  /// bounds vary slightly in height, so the shared footprint remains 120×110.
  static const width = 120.0;
  static const height = 110.0;

  double get _imageHeight => switch (state) {
    LearningPathNodeState.completed => 109,
    LearningPathNodeState.current => 110,
    LearningPathNodeState.locked => 104,
  };

  String get _asset => switch (state) {
    LearningPathNodeState.completed =>
      'assets/images/curriculum/node_trophy.png',
    LearningPathNodeState.current => 'assets/images/curriculum/node_robot.png',
    LearningPathNodeState.locked => 'assets/images/curriculum/node_locked.png',
  };

  String get _semanticLabel => switch (state) {
    LearningPathNodeState.completed => 'Tugatilgan dars',
    LearningPathNodeState.current => 'Joriy dars',
    LearningPathNodeState.locked => 'Yopiq dars',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: _semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Image.asset(
              _asset,
              width: width,
              height: _imageHeight,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              cacheWidth: 360,
              errorBuilder: (context, error, stackTrace) =>
                  _NodeFallback(state: state),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown only when a node illustration is missing from the bundle, so the
/// path still reads instead of throwing.
class _NodeFallback extends StatelessWidget {
  const _NodeFallback({required this.state});

  final LearningPathNodeState state;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (state) {
      LearningPathNodeState.completed => (
        Icons.emoji_events_rounded,
        AppColors.success,
      ),
      LearningPathNodeState.current => (
        Icons.smart_toy_rounded,
        AppColors.primary,
      ),
      LearningPathNodeState.locked => (Icons.lock_rounded, AppColors.outline),
    };

    return SizedBox.square(
      dimension: LearningPathNode.height,
      child: Center(
        child: Transform.rotate(
          angle: 0.7853981633974483, // 45°, giving the isometric diamond
          child: Container(
            width: LearningPathNode.height * 0.62,
            height: LearningPathNode.height * 0.62,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Transform.rotate(
              angle: -0.7853981633974483,
              child: Icon(
                icon,
                color: AppColors.onPrimary,
                size: LearningPathNode.height * 0.32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
