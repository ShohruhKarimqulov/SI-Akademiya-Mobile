import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../shared/widgets/lesson_project_preview_card.dart';

class PersonalCurriculumScreen extends StatelessWidget {
  const PersonalCurriculumScreen({this.onStartLearning, super.key});

  final VoidCallback? onStartLearning;

  static const _modules = [
    _CurriculumModuleData(isCurrent: true),
    _CurriculumModuleData(),
    _CurriculumModuleData(),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      child: AppDesignCanvas(
        child: Stack(
          children: [
            const Positioned(
              left: AppSpacing.screenHorizontal,
              top: 73,
              child: _CurriculumHeader(),
            ),
            Positioned(
              left: AppSpacing.screenHorizontal,
              right: AppSpacing.screenHorizontal,
              top: 152,
              bottom: 55,
              child: Scrollbar(
                child: ListView.separated(
                  key: const ValueKey('personal-curriculum-list'),
                  padding: const EdgeInsets.only(bottom: 90),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: _modules.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.controlGap),
                  itemBuilder: (context, index) => _CurriculumTimelineItem(
                    module: _modules[index],
                    showConnector: index < _modules.length - 1,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: IgnorePointer(child: _BottomFade()),
            ),
            Positioned(
              left: AppSpacing.screenHorizontal,
              top: 832,
              width: 390,
              child: AppButton(
                label: 'O’rganishni boshlash',
                onPressed: onStartLearning ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fades the list into the page background behind the fixed CTA button.
/// Wrapped in [IgnorePointer] by the caller so it never swallows scroll
/// gestures aimed at the list underneath it.
class _BottomFade extends StatelessWidget {
  const _BottomFade();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.pageBackground.withValues(alpha: 0),
            AppColors.pageBackground,
          ],
          stops: const [0, 0.55],
        ),
      ),
    );
  }
}

class _CurriculumHeader extends StatelessWidget {
  const _CurriculumHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kurs',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Python Developer',
          style: AppTypography.title.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _CurriculumModuleData {
  const _CurriculumModuleData({this.isCurrent = false});

  final bool isCurrent;
}

class _CurriculumTimelineItem extends StatelessWidget {
  const _CurriculumTimelineItem({
    required this.module,
    required this.showConnector,
  });

  final _CurriculumModuleData module;
  final bool showConnector;

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
                _CurriculumTimelineNode(isCurrent: module.isCurrent),
              ],
            ),
          ),
          const Expanded(child: _CurriculumModuleCard()),
        ],
      ),
    );
  }
}

class _CurriculumTimelineNode extends StatelessWidget {
  const _CurriculumTimelineNode({required this.isCurrent});

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

class _CurriculumModuleCard extends StatelessWidget {
  const _CurriculumModuleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '1. Pythonga kirish',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              height: 22 / 16,
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            'Create variables storing numbers,\nstrings and booleans',
            style: AppTypography.bodySmall.copyWith(height: 22 / 14),
          ),
          const SizedBox(height: AppSpacing.controlGap),
          const Expanded(
            child: LessonProjectPreviewCard(
              label: 'Bo’lim loyihasi',
              title: 'Bot',
              imagePath: 'assets/images/curriculum/bot_project.png',
            ),
          ),
        ],
      ),
    );
  }
}
