import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';

/// Shared 430 × 932 lesson chrome used by every exercise type.
class LessonExerciseScaffold extends StatelessWidget {
  const LessonExerciseScaffold({
    required this.question,
    required this.body,
    this.bottomAction,
    this.footer,
    this.onClose,
    this.progress = 0.1,
    this.progressLabel = '2/20',
    this.keyboardBehavior = AppDesignCanvasKeyboardBehavior.resize,
    super.key,
  });

  final String question;
  final Widget body;
  final Widget? bottomAction;
  final Widget? footer;
  final VoidCallback? onClose;
  final double progress;
  final String progressLabel;
  final AppDesignCanvasKeyboardBehavior keyboardBehavior;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      child: AppDesignCanvas(
        keyboardBehavior: keyboardBehavior,
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 59,
              child: IconButton(
                key: const ValueKey('lesson-close'),
                onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
                iconSize: 27,
                color: AppColors.textPrimary,
                tooltip: 'Yopish',
              ),
            ),
            Positioned(
              left: 74,
              top: 73,
              width: 269,
              child: AppLinearProgressBar(
                value: progress,
                height: 14,
                fillColor: AppColors.primary,
                trackColor: AppColors.mutedSurface,
              ),
            ),
            Positioned(
              right: AppSpacing.screenHorizontal,
              top: 66,
              child: Text(
                progressLabel,
                style: AppTypography.body.copyWith(height: 1.5),
              ),
            ),
            Positioned(
              left: AppSpacing.screenHorizontal,
              right: AppSpacing.screenHorizontal,
              top: 119,
              child: Text(
                question,
                style: AppTypography.sectionTitle.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
            Positioned.fill(child: body),
            if (bottomAction != null)
              Positioned(
                left: AppSpacing.screenHorizontal,
                right: AppSpacing.screenHorizontal,
                bottom: AppSpacing.screenHorizontal,
                child: bottomAction!,
              ),
            if (footer != null)
              Positioned(left: 0, right: 0, bottom: 0, child: footer!),
          ],
        ),
      ),
    );
  }
}

/// The 56 px rounded code/token pill repeated by ordering exercises.
class LessonTokenChip extends StatelessWidget {
  const LessonTokenChip({
    required this.label,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.selectedFill : AppColors.pageBackground,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.choice,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.choice,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 76, minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(child: Text(label, style: AppTypography.body)),
          ),
        ),
      ),
    );
  }
}
