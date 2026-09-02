import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'free_input_lesson_screen.dart';
import 'true_order_lesson_screen.dart';
import 'widgets/lesson_exercise_scaffold.dart';

enum LessonFeedbackAction { continueLesson, retry, skip }

Future<LessonFeedbackAction?> showLessonFeedbackSheet(
  BuildContext context, {
  required bool isCorrect,
}) {
  return showModalBottomSheet<LessonFeedbackAction>(
    context: context,
    useSafeArea: false,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.08),
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _LessonFeedbackPanel(
      isCorrect: isCorrect,
      onContinue: () =>
          Navigator.of(sheetContext).pop(LessonFeedbackAction.continueLesson),
      onSkip: () => Navigator.of(sheetContext).pop(LessonFeedbackAction.skip),
      onRetry: () => Navigator.of(sheetContext).pop(LessonFeedbackAction.retry),
    ),
  );
}

class TrueAnswerScreen extends StatelessWidget {
  const TrueAnswerScreen({this.onContinue, super.key});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return _LessonFeedbackScreen(isCorrect: true, onContinue: onContinue);
  }
}

class FalseAnswerScreen extends StatelessWidget {
  const FalseAnswerScreen({this.onSkip, this.onRetry, super.key});

  final VoidCallback? onSkip;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _LessonFeedbackScreen(
      isCorrect: false,
      onSkip: onSkip,
      onRetry: onRetry,
    );
  }
}

class _LessonFeedbackScreen extends StatelessWidget {
  const _LessonFeedbackScreen({
    required this.isCorrect,
    this.onContinue,
    this.onSkip,
    this.onRetry,
  });

  final bool isCorrect;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final VoidCallback? onRetry;

  void _openFreeInput(BuildContext context, VoidCallback? override) {
    if (override != null) {
      override();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const FreeInputLessonScreen(),
      ),
    );
  }

  void _retry(BuildContext context) {
    if (onRetry != null) {
      onRetry!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const TrueOrderLessonScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LessonExerciseScaffold(
      question: 'To’g’ri ketma-ketlikda\njoylashtiring.',
      body: const Stack(
        children: [
          Positioned(
            left: AppSpacing.screenHorizontal,
            top: 186,
            child: LessonTokenChip(label: 'print'),
          ),
        ],
      ),
      footer: _LessonFeedbackPanel(
        isCorrect: isCorrect,
        onContinue: () => _openFreeInput(context, onContinue),
        onSkip: () => _openFreeInput(context, onSkip),
        onRetry: () => _retry(context),
      ),
    );
  }
}

class _LessonFeedbackPanel extends StatelessWidget {
  const _LessonFeedbackPanel({
    required this.isCorrect,
    required this.onContinue,
    required this.onSkip,
    required this.onRetry,
  });

  final bool isCorrect;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final resultColor = isCorrect ? AppColors.success : AppColors.error;

    return Container(
      key: ValueKey(isCorrect ? 'true-answer-panel' : 'false-answer-panel'),
      height: 238,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.sheetTop,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _FeedbackMascot(isCorrect: isCorrect),
              const SizedBox(width: AppSpacing.small),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.input,
                  border: Border.all(color: AppColors.outline),
                ),
                child: Text(
                  isCorrect ? 'To’g’ri javob' : 'Noto’g’ri javob',
                  style: AppTypography.body.copyWith(
                    color: resultColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isCorrect)
            AppButton(label: 'Davom etish', onPressed: onContinue)
          else
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'O’tkazib yuborish',
                    onPressed: onSkip,
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.controlGap),
                Expanded(
                  child: AppButton(label: 'Qayta urinish', onPressed: onRetry),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FeedbackMascot extends StatelessWidget {
  const _FeedbackMascot({required this.isCorrect});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isCorrect
          ? 'assets/images/lesson/true_mascot.png'
          : 'assets/images/lesson/false_mascot.png',
      width: 64,
      height: 80,
      fit: BoxFit.contain,
    );
  }
}
