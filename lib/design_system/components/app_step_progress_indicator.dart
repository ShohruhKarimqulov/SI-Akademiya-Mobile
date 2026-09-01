import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// A segmented indicator with one active step.
class AppStepProgressIndicator extends StatelessWidget {
  const AppStepProgressIndicator({
    required this.stepCount,
    required this.currentStep,
    this.onPreviousStepPressed,
    super.key,
  }) : assert(stepCount > 0),
       assert(currentStep >= 0 && currentStep < stepCount);

  final int stepCount;
  final int currentStep;

  /// Enables navigation only to steps completed before [currentStep].
  final ValueChanged<int>? onPreviousStepPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < stepCount; index++) ...[
          Expanded(
            child: Builder(
              builder: (context) {
                final canGoBack =
                    onPreviousStepPressed != null && index < currentStep;

                return Semantics(
                  selected: index == currentStep,
                  button: canGoBack,
                  enabled: canGoBack,
                  child: GestureDetector(
                    key: ValueKey('step-indicator-$index'),
                    behavior: HitTestBehavior.opaque,
                    onTap: canGoBack
                        ? () => onPreviousStepPressed!(index)
                        : null,
                    child: SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeInOutCubic,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == currentStep
                                ? AppColors.onPrimary
                                : AppColors.onPrimaryMuted,
                            borderRadius: AppRadius.button,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (index < stepCount - 1)
            const SizedBox(width: AppSpacing.controlGap),
        ],
      ],
    );
  }
}
