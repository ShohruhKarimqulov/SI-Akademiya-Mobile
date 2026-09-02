import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'true_order_lesson_screen.dart';
import 'widgets/lesson_exercise_scaffold.dart';

class FillBlankLessonScreen extends StatefulWidget {
  const FillBlankLessonScreen({this.onSubmit, super.key});

  final VoidCallback? onSubmit;

  @override
  State<FillBlankLessonScreen> createState() => _FillBlankLessonScreenState();
}

class _FillBlankLessonScreenState extends State<FillBlankLessonScreen> {
  static const _answers = ['ChatGPT', 'Calculator', 'Excel'];

  int? _selectedAnswer;

  String get _sentenceAnswer =>
      _selectedAnswer == null ? '....' : _answers[_selectedAnswer!];

  void _submit() {
    final onSubmit = widget.onSubmit;
    if (onSubmit != null) {
      onSubmit();
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
      question: 'To’ldiring.',
      body: Stack(
        children: [
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 161,
            height: 117,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lessonCard,
                border: Border.all(color: AppColors.outline),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Model javobi sifatini oshirish\nuchun promptga\n',
                      ),
                      if (_selectedAnswer == null)
                        TextSpan(text: _sentenceAnswer)
                      else
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: Container(
                            key: const ValueKey('fill-blank-answer-underline'),
                            padding: const EdgeInsets.only(bottom: 2),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            child: Text(
                              _sentenceAnswer,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      const TextSpan(text: ' kiritish kerak'),
                    ],
                  ),
                  key: ValueKey(_sentenceAnswer),
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.9,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 303,
            child: Column(
              children: [
                for (var index = 0; index < _answers.length; index++) ...[
                  AppChoiceCard(
                    label: _answers[index],
                    isSelected: index == _selectedAnswer,
                    onTap: () => setState(() => _selectedAnswer = index),
                  ),
                  if (index < _answers.length - 1)
                    const SizedBox(height: AppSpacing.controlGap),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomAction: AppButton(
        label: 'Javobni Tekshirish',
        onPressed: _selectedAnswer == null ? null : _submit,
      ),
    );
  }
}
