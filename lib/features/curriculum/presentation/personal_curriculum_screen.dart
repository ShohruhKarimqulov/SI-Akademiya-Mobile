import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'widgets/course_progress_item.dart';

class PersonalCurriculumScreen extends StatelessWidget {
  const PersonalCurriculumScreen({this.onStartLearning, super.key});

  final VoidCallback? onStartLearning;

  static const _modules = [
    CourseModuleData(isCurrent: true),
    CourseModuleData(),
    CourseModuleData(),
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
                  itemBuilder: (context, index) => CourseProgressItem(
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
              child: RepaintBoundary(
                child: IgnorePointer(child: _BottomFade()),
              ),
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
