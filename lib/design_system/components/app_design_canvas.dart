import 'package:flutter/material.dart';

enum AppDesignCanvasKeyboardBehavior {
  /// Reserves the keyboard inset for form layouts such as authentication.
  resize,

  /// Keeps the 430 × 932 composition fixed while the keyboard overlays it.
  overlay,
}

/// Scales the 430 × 932 reference canvas used by the mobile Figma screens.
class AppDesignCanvas extends StatelessWidget {
  const AppDesignCanvas({
    required this.child,
    this.keyboardBehavior = AppDesignCanvasKeyboardBehavior.resize,
    super.key,
  });

  final Widget child;
  final AppDesignCanvasKeyboardBehavior keyboardBehavior;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final reservesKeyboard =
        keyboardBehavior == AppDesignCanvasKeyboardBehavior.resize;
    final keyboardOpen = keyboardInset > 0 && reservesKeyboard;

    // Form screens reserve the inset and align their fixed canvas above the
    // keyboard. Exercises can deliberately opt into [overlay] so their
    // question chrome keeps its Figma position while text input is active.
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
      child: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: reservesKeyboard ? keyboardInset : 0,
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: keyboardOpen ? Alignment.bottomCenter : Alignment.center,
            child: SizedBox(width: 430, height: 932, child: child),
          ),
        ),
      ),
    );
  }
}
