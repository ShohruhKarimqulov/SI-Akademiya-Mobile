import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../design_system/design_system.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    this.onLogin,
    this.onGoogleLogin,
    this.onRegister,
    super.key,
  });

  final VoidCallback? onLogin;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: AppDesignCanvas(
        keyboardBehavior: AppDesignCanvasKeyboardBehavior.overlay,
        child: AppKeyboardScrollView(
          key: const ValueKey('login-page-scroll'),
          child: SizedBox(
            height: 932,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                const AppBrandBackdrop(),
                const _LoginMascot(),
                const _GreetingBubble(),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 460,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.sheetTop,
                      boxShadow: AppShadows.elevatedCard,
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.screenHorizontal,
                  top: 492,
                  width: 390,
                  child: Column(
                    children: [
                      const _LoginHeading(),
                      const SizedBox(height: AppSpacing.section),
                      _LoginForm(
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: AppSpacing.section),
                      AppButton(
                        label: 'Kirish',
                        onPressed: widget.onLogin ?? () {},
                      ),
                      const SizedBox(height: AppSpacing.section),
                      const _AuthDivider(),
                      const SizedBox(height: AppSpacing.section),
                      AppButton(
                        label: 'Google orqali',
                        onPressed: widget.onGoogleLogin ?? () {},
                        variant: AppButtonVariant.outlined,
                        contentGap: 12,
                        leading: SvgPicture.asset(
                          'assets/icons/auth/google.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.section),
                      _RegisterPrompt(onPressed: widget.onRegister),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginMascot extends StatelessWidget {
  const _LoginMascot();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 39.82,
      top: 104,
      width: 350.4,
      height: 368,
      child: ExcludeSemantics(
        child: Image.asset(
          'assets/images/auth/login_mascot.png',
          fit: BoxFit.fill,
          cacheWidth: 600,
        ),
      ),
    );
  }
}

class _GreetingBubble extends StatelessWidget {
  const _GreetingBubble();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 286.5,
          top: 173,
          width: 25.51,
          height: 20.5,
          child: SvgPicture.asset(
            'assets/icons/auth/speech_tail.svg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 293,
          top: 128,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lessonCard,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Salom!',
                style: AppTypography.headline.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 30 / 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginHeading extends StatelessWidget {
  const _LoginHeading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Xush kelibsiz! 👋',
          textAlign: TextAlign.center,
          style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.compact),
        SizedBox(
          width: 272,
          child: Text(
            'Davom etish uchun profilingizga kiring',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: SvgPicture.asset('assets/icons/auth/email.svg'),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          hintText: 'Parol',
          obscureText: obscurePassword,
          prefixIcon: SvgPicture.asset('assets/icons/auth/password.svg'),
          suffixIcon: obscurePassword
              ? SvgPicture.asset(
                  'assets/icons/auth/visibility.svg',
                  key: const ValueKey('password-visibility-show'),
                )
              : Image.asset(
                  'assets/icons/auth/hide-password.png',
                  key: const ValueKey('password-visibility-hide'),
                ),
          onSuffixPressed: onTogglePassword,
        ),
      ],
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.outline, height: 1)),
        const SizedBox(width: AppSpacing.controlGap),
        Text(
          'yoki',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.controlGap),
        const Expanded(child: Divider(color: AppColors.outline, height: 1)),
      ],
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Profilingiz yo’qmi?',
          style: AppTypography.caption.copyWith(
            color: const Color(0x66131316),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.micro),
        Semantics(
          button: true,
          child: GestureDetector(
            onTap: onPressed,
            child: Text(
              'Ro’yxatdan o’tish',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
