import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// The repeated blue gradient-and-glow backdrop used by entry flows.
class AppBrandBackdrop extends StatelessWidget {
  const AppBrandBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: RepaintBoundary(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            gradient: RadialGradient(
              center: Alignment(1.05, -0.92),
              radius: 1.75,
              colors: [Color(0x99FFFFFF), Color(0x00507EFF)],
              stops: [0, 0.72],
            ),
          ),
        ),
      ),
    );
  }
}
