import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';

/// One destination in an [AppBottomNavBar].
class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.semanticLabel});

  final IconData icon;
  final String semanticLabel;
}

/// The floating 234×78 bottom navigation bar shared by the app's top-level
/// tabs. The selected brand circle slides between equal touch targets.
class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) : assert(items.length > 1);

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar>
    with SingleTickerProviderStateMixin {
  static const _itemExtent = 78.0;
  static const _selectedDiameter = 54.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(
      vsync: this,
      value: widget.currentIndex.toDouble(),
      duration: const Duration(milliseconds: 300),
      animationBehavior: AnimationBehavior.preserve,
    );
  }

  @override
  void didUpdateWidget(covariant AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex == widget.currentIndex) {
      return;
    }

    _controller.animateTo(
      widget.currentIndex.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = _itemExtent * widget.items.length;

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: _itemExtent,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.button,
            boxShadow: AppShadows.floating,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final position = _controller.value;
              return Stack(
                children: [
                  Positioned(
                    key: const ValueKey('bottom-nav-indicator'),
                    left:
                        position * _itemExtent +
                        (_itemExtent - _selectedDiameter) / 2,
                    top: (_itemExtent - _selectedDiameter) / 2,
                    width: _selectedDiameter,
                    height: _selectedDiameter,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var index = 0; index < widget.items.length; index++)
                        _AppBottomNavButton(
                          item: widget.items[index],
                          isSelected: index == widget.currentIndex,
                          selectionProgress: (1 - (position - index).abs())
                              .clamp(0.0, 1.0),
                          onTap: () => widget.onTap(index),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBottomNavButton extends StatelessWidget {
  const _AppBottomNavButton({
    required this.item,
    required this.isSelected,
    required this.selectionProgress,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
  final double selectionProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.semanticLabel,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: SizedBox.square(
          dimension: 78,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: Transform.scale(
                scale: 1 - selectionProgress * 0.08,
                child: Icon(
                  item.icon,
                  size: 24 - selectionProgress * 2,
                  color: Color.lerp(
                    AppColors.textPrimary,
                    AppColors.onPrimary,
                    selectionProgress,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
