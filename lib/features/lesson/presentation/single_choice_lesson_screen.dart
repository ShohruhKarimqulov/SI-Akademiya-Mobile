import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'fill_blank_lesson_screen.dart';
import 'widgets/lesson_exercise_scaffold.dart';

/// The first exercise opened from the Course Open confirmation.
class SingleChoiceLessonScreen extends StatefulWidget {
  const SingleChoiceLessonScreen({this.onSubmit, super.key});

  final VoidCallback? onSubmit;

  @override
  State<SingleChoiceLessonScreen> createState() =>
      _SingleChoiceLessonScreenState();
}

class _SingleChoiceLessonScreenState extends State<SingleChoiceLessonScreen> {
  static const _answers = ['ChatGPT', 'Calculator', 'Excel'];

  int _selectedAnswer = 0;

  void _submit() {
    final onSubmit = widget.onSubmit;
    if (onSubmit != null) {
      onSubmit();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const FillBlankLessonScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LessonExerciseScaffold(
      question: 'Qaysi biri Generative AI ga\nmisol?',
      body: Stack(
        children: [
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 188,
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
      bottomAction: AppButton(label: 'Javobni Tekshirish', onPressed: _submit),
    );
  }
}
