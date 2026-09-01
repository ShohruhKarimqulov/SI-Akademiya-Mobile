import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// The white card introducing a module section on the Learn path: category
/// label, lesson title, and its completion bar.
///
/// Sections the learner has not reached yet render [isLocked], which greys
/// the copy and empties the bar, matching the second card in the Figma frame.
class LessonSectionHeaderCard extends StatelessWidget {
  const LessonSectionHeaderCard({
    required this.category,
    required this.title,
    required this.progress,
    this.isLocked = false,
    super.key,
  });

  final String category;
  final String title;

  /// 0..1 completion fraction.
  final double progress;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lessonCard,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: AppTypography.bodySmall.copyWith(
              height: 1.2,
              color: isLocked
                  ? AppColors.textDisabled
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.sectionTitle.copyWith(
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: isLocked ? AppColors.textDisabled : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          AppLinearProgressBar(
            value: isLocked ? 0 : progress,
            height: 14,
            fillGradient: const LinearGradient(
              colors: [AppColors.primarySoft, AppColors.primary],
            ),
          ),
        ],
      ),
    );
  }
}
