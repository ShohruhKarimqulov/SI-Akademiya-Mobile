import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_spacing.dart';

/// One destination in an [AppBottomNavBar].
class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.semanticLabel});

  final IconData icon;
  final String semanticLabel;
}

/// The floating, fully-rounded bottom navigation bar shared by the app's
/// top-level tabs. The selected destination is highlighted with a filled
/// circle; the rest render as plain outline icons.
class AppBottomNavBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.button,
        boxShadow: AppShadows.elevatedCard,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var index = 0; index < items.length; index++)
              _AppBottomNavButton(
                item: items[index],
                isSelected: index == currentIndex,
                onTap: () => onTap(index),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppBottomNavButton extends StatelessWidget {
  const _AppBottomNavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
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
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 24,
              color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
