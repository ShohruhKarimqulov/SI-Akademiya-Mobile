import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'widgets/lesson_exercise_scaffold.dart';

class FreeInputLessonScreen extends StatefulWidget {
  const FreeInputLessonScreen({this.onSubmit, super.key});

  final ValueChanged<String>? onSubmit;

  @override
  State<FreeInputLessonScreen> createState() => _FreeInputLessonScreenState();
}

class _FreeInputLessonScreenState extends State<FreeInputLessonScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final answer = _controller.text.trim();
    final onSubmit = widget.onSubmit;
    if (onSubmit != null) {
      onSubmit(answer);
      return;
    }
    FocusScope.of(context).unfocus();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return LessonExerciseScaffold(
      question: 'Formula natijasini kiriting.',
      keyboardBehavior: AppDesignCanvasKeyboardBehavior.overlay,
      body: Stack(
        children: [
          Positioned(
            left: AppSpacing.screenHorizontal,
            right: AppSpacing.screenHorizontal,
            top: 163,
            height: 98,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _focusNode.requestFocus,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.lessonCard,
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'label = “Posts:” + “13”',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('print(', style: AppTypography.bodySmall),
                        AnimatedContainer(
                          key: const ValueKey('free-input-field-surface'),
                          duration: const Duration(milliseconds: 120),
                          width: 68,
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: AppColors.mutedSurface,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Center(
                            child: TextField(
                              key: const ValueKey('free-input-answer'),
                              controller: _controller,
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.done,
                              textAlignVertical: TextAlignVertical.center,
                              onSubmitted: (_) => _dismissKeyboard(),
                              style: AppTypography.bodySmall.copyWith(
                                height: 1,
                              ),
                              cursorColor: AppColors.primary,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                hintText: '...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                        const Text(')', style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (keyboardVisible)
            Positioned(
              right: AppSpacing.screenHorizontal,
              top: 521,
              child: SizedBox.square(
                dimension: 51,
                child: FilledButton(
                  key: const ValueKey('free-input-dismiss-keyboard'),
                  onPressed: _dismissKeyboard,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.primary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.input,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 25,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomAction: keyboardVisible
          ? null
          : AppButton(label: 'Javobni Tekshirish', onPressed: _checkAnswer),
    );
  }
}
