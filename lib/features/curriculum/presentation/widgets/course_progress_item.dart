import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/lesson_project_preview_card.dart';

/// Data rendered by a curriculum timeline item.
class CourseModuleData {
  const CourseModuleData({
    this.isCurrent = false,
    this.title = '1. Pythonga kirish',
    this.description =
        'Create variables storing numbers,\nstrings and booleans',
    this.projectLabel = 'Bo’lim loyihasi',
    this.projectTitle = 'Bot',
    this.projectImagePath = 'assets/images/curriculum/bot_project.png',
  });

  final bool isCurrent;
  final String title;
  final String description;
  final String projectLabel;
  final String projectTitle;
  final String projectImagePath;
}

/// A reusable course module card with its progress/lock timeline node.
/// Shared by Personal Curriculum and the View Course bottom sheet.
class CourseProgressItem extends StatelessWidget {
  const CourseProgressItem({
    required this.module,
    required this.showConnector,
    this.onTap,
    super.key,
  });

  final CourseModuleData module;
  final bool showConnector;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            height: 235,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                if (showConnector)
                  Positioned(
                    top: 44,
                    bottom: -AppSpacing.controlGap,
                    width: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: module.isCurrent
                            ? AppColors.primary
                            : AppColors.outline,
                        borderRadius: AppRadius.button,
                      ),
                    ),
                  ),
                _CourseTimelineNode(isCurrent: module.isCurrent),
              ],
            ),
          ),
          Expanded(
            child: _CourseModuleCard(module: module, onTap: onTap),
          ),
        ],
      ),
    );
  }
}

class _CourseTimelineNode extends StatelessWidget {
  const _CourseTimelineNode({required this.isCurrent});

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.mutedSurface,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isCurrent
          ? Text(
              '0%',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : const Icon(
              Icons.lock_outline_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
    );
  }
}

class _CourseModuleCard extends StatelessWidget {
  const _CourseModuleCard({required this.module, this.onTap});

  final CourseModuleData module;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: 235,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lessonCard,
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module.title,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              height: 22 / 16,
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            module.description,
            style: AppTypography.bodySmall.copyWith(height: 22 / 14),
          ),
          const SizedBox(height: AppSpacing.controlGap),
          Expanded(
            child: LessonProjectPreviewCard(
              label: module.projectLabel,
              title: module.projectTitle,
              imagePath: module.projectImagePath,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return Semantics(
      button: true,
      label: module.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: card,
      ),
    );
  }
}
