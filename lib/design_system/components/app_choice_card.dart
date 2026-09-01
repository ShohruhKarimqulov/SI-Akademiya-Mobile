import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// The selectable 56 px answer row used in the single-choice exercise.
class AppChoiceCard extends StatelessWidget {
  const AppChoiceCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primary : AppColors.outline;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? AppColors.selectedFill : AppColors.pageBackground,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.choice,
          side: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.choice,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(child: Text(label, style: AppTypography.body)),
          ),
        ),
      ),
    );
  }
}
