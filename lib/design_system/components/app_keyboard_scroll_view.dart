import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Makes a fixed-canvas page scrollable when the software keyboard covers its
/// lower content. Put the complete 430 × 932 page inside this widget so the
/// hero and form travel together and focused fields can request visibility.
class AppKeyboardScrollView extends StatefulWidget {
  const AppKeyboardScrollView({
    required this.child,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  State<AppKeyboardScrollView> createState() => _AppKeyboardScrollViewState();
}

class _AppKeyboardScrollViewState extends State<AppKeyboardScrollView>
    with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();
  double _canvasScale = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChanged);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() => _revealFocusedField();

  void _handleFocusChanged() {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) {
      _revealFocusedField();
    }
  }

  void _revealFocusedField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final focusContext = FocusManager.instance.primaryFocus?.context;
      final renderBox = focusContext?.findRenderObject();
      if (renderBox is! RenderBox || !_controller.hasClients) {
        return;
      }

      final mediaQuery = MediaQuery.of(context);
      final visibleBottom =
          mediaQuery.size.height - mediaQuery.viewInsets.bottom;
      final fieldBottom = renderBox
          .localToGlobal(Offset(0, renderBox.size.height))
          .dy;
      final overlap = fieldBottom + 24 - visibleBottom;
      if (overlap <= 0) {
        return;
      }

      final target = (_controller.offset + overlap / _canvasScale).clamp(
        0.0,
        _controller.position.maxScrollExtent,
      );
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _canvasScale = math.max(
      mediaQuery.size.width / 430,
      mediaQuery.size.height / 932,
    );
    final keyboardInset = mediaQuery.viewInsets.bottom / _canvasScale;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        padding: widget.padding.copyWith(
          bottom:
              widget.padding.bottom +
              keyboardInset +
              (keyboardInset > 0 ? 24 : 0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: constraints.maxWidth),
          child: widget.child,
        ),
      ),
    );
  }
}
