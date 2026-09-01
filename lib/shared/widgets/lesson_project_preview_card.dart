import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

/// The small "section project" preview strip (label + title + thumbnail)
/// reused across the curriculum and learning-path screens.
class LessonProjectPreviewCard extends StatelessWidget {
  const LessonProjectPreviewCard({
    required this.label,
    required this.title,
    required this.imagePath,
    super.key,
  });

  final String label;
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.input,
      child: ColoredBox(
        color: AppColors.pageBackground,
        child: Stack(
          children: [
            Positioned(
              left: AppSpacing.medium,
              top: AppSpacing.controlGap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.micro),
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 167,
              child: Image(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
