import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'free_input_lesson_screen.dart';
import 'lesson_feedback_screen.dart';
import 'widgets/lesson_exercise_scaffold.dart';

class TrueOrderLessonScreen extends StatefulWidget {
  const TrueOrderLessonScreen({super.key});

  @override
  State<TrueOrderLessonScreen> createState() => _TrueOrderLessonScreenState();
}

class _TrueOrderLessonScreenState extends State<TrueOrderLessonScreen> {
  static const _correctOrder = ['print', '(', '“Hello”', ')'];

  final List<String> _placedTokens = ['print'];
  final List<String> _availableTokens = ['(', ')', '“Hello”'];

  void _placeToken(String token) {
    setState(() {
      _availableTokens.remove(token);
      _placedTokens.add(token);
    });
  }

  void _removeToken(String token) {
    if (token == 'print') {
      return;
    }
    setState(() {
      _placedTokens.remove(token);
      _availableTokens.add(token);
    });
  }

  void _undo() {
    if (_placedTokens.length == 1) {
      return;
    }
    _removeToken(_placedTokens.last);
  }

  void _movePlacedToken(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }
    setState(() {
      final token = _placedTokens.removeAt(fromIndex);
      _placedTokens.insert(toIndex, token);
    });
  }

  Future<void> _checkAnswer() async {
    final isCorrect =
        _placedTokens.length == _correctOrder.length &&
        List.generate(
          _correctOrder.length,
          (index) => _placedTokens[index] == _correctOrder[index],
        ).every((matches) => matches);

    final action = await showLessonFeedbackSheet(context, isCorrect: isCorrect);
    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case LessonFeedbackAction.continueLesson:
      case LessonFeedbackAction.skip:
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => const FreeInputLessonScreen(),
          ),
        );
        return;
      case LessonFeedbackAction.retry:
        setState(() {
          _placedTokens
            ..clear()
            ..add('print');
          _availableTokens
            ..clear()
            ..addAll(['(', ')', '“Hello”']);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LessonExerciseScaffold(
      question: 'To’g’ri ketma-ketlikda\njoylashtiring.',
      body: Stack(
        children: [
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 186,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < _placedTokens.length; index++) ...[
                  DragTarget<int>(
                    key: ValueKey('order-drop-target-$index'),
                    onWillAcceptWithDetails: (details) => details.data != index,
                    onAcceptWithDetails: (details) =>
                        _movePlacedToken(details.data, index),
                    builder: (context, candidateData, rejectedData) {
                      final token = _placedTokens[index];
                      return AnimatedScale(
                        scale: candidateData.isNotEmpty ? 1.06 : 1,
                        duration: const Duration(milliseconds: 140),
                        child: Draggable<int>(
                          data: index,
                          feedback: Material(
                            color: Colors.transparent,
                            child: LessonTokenChip(label: token),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.35,
                            child: LessonTokenChip(label: token),
                          ),
                          child: LessonTokenChip(
                            key: ValueKey('placed-$token'),
                            label: token,
                            onTap: () => _removeToken(token),
                          ),
                        ),
                      );
                    },
                  ),
                  if (index < _placedTokens.length - 1)
                    const SizedBox(width: AppSpacing.small),
                ],
              ],
            ),
          ),
          Positioned(
            right: AppSpacing.screenHorizontal,
            top: 643,
            child: Material(
              color: AppColors.pageBackground,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.input,
                side: BorderSide(color: AppColors.outline),
              ),
              child: IconButton(
                key: const ValueKey('order-undo'),
                onPressed: _placedTokens.length > 1 ? _undo : null,
                icon: const Icon(Icons.undo_rounded),
                iconSize: 22,
                color: AppColors.textSecondary,
                tooltip: 'Bekor qilish',
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 734,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final token in _availableTokens)
                  LessonTokenChip(
                    key: ValueKey('available-$token'),
                    label: token,
                    onTap: () => _placeToken(token),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomAction: AppButton(
        label: 'Javobni Tekshirish',
        onPressed: _checkAnswer,
      ),
    );
  }
}
