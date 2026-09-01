import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: AppColors.primary,
      child: AppDesignCanvas(child: _SplashCanvas()),
    );
  }
}

class _SplashCanvas extends StatelessWidget {
  const _SplashCanvas();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        AppBrandBackdrop(),
        Positioned.fill(child: Center(child: _SplashContent())),
      ],
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/splash/robot.png',
          width: 255,
          height: 200,
          fit: BoxFit.cover,
          semanticLabel: 'SI Akademiyasi robot',
        ),
        const SizedBox(height: AppSpacing.screenHorizontal),
        const Text(
          'SI AKADEMIYASI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.28,
            color: AppColors.onPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.micro),
        SizedBox(
          width: 390,
          child: Text(
            'Sun’iy intellektni o’rgan. Kelajakni yarat.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              height: 30 / 16,
              color: const Color(0x99FFFFFF),
            ),
          ),
        ),
      ],
    );
  }
}
