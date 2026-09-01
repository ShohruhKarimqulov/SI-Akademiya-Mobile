import 'package:flutter/material.dart';

/// Scales the 430 × 932 reference canvas used by the mobile Figma screens.
class AppDesignCanvas extends StatelessWidget {
  const AppDesignCanvas({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final keyboardOpen = keyboardInset > 0;

    // When the keyboard opens there is no Scaffold here to shrink the
    // available height for us, so the fixed-size canvas would otherwise
    // sit under the keyboard untouched. Reserve the inset ourselves and
    // anchor the crop to the bottom so the (usually lower-half) form and
    // its submit button stay above the keyboard instead of being covered.
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
      child: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardInset),
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
