import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// The white card introducing a module section on the Learn path: category
/// label, lesson title, and its completion bar.
///
/// Figma: auto layout, padding 16, gap 15, radius 16, fill #FFFFFF, 2px
/// #131316 @10% stroke. Sections the learner has not reached render
/// [isLocked], which mutes the title and empties the bar.
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.outline, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: isLocked ? 0.4 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTypography.label.copyWith(
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTypography.sectionTitle.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            AppLinearProgressBar(
              value: isLocked ? 0 : progress,
              height: 12,
              trackColor: AppColors.outline,
              fillGradient: const LinearGradient(
                colors: [AppColors.primarySoft, AppColors.primary],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
