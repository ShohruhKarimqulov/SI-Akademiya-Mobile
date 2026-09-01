import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../design_system/design_system.dart';

class CreateProfileFlow extends StatefulWidget {
  const CreateProfileFlow({
    required this.onLogin,
    required this.onProfileCreated,
    super.key,
  });

  final VoidCallback onLogin;
  final VoidCallback onProfileCreated;

  @override
  State<CreateProfileFlow> createState() => _CreateProfileFlowState();
}

class _CreateProfileFlowState extends State<CreateProfileFlow> {
  static const _questionStepCount = 7;

  int _currentStep = 0;
  int? _profileType;
  int? _learningReason;
  double? _experienceLevel = 1;
  int? _course;
  int? _dailyTime;

  void _continue() {
    if (_currentStep >= 7) {
      return;
    }
    setState(() => _currentStep += 1);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      child: AppDesignCanvas(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final offset = Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offset, child: child),
                  );
                },
                child: switch (_currentStep) {
                  0 => _WelcomeStep(
                    key: const ValueKey('create-profile-step-1'),
                    onContinue: _continue,
                  ),
                  1 => _ChoiceStep(
                    key: const ValueKey('create-profile-step-2'),
                    title: 'Bulardan qaysi biri sizni eng\nyaxshi ta’riflaydi?',
                    choices: const [
                      _ProfileChoice('🎒', 'Maktab o’quvchisi'),
                      _ProfileChoice('🎓', 'Talaba'),
                      _ProfileChoice('🧑🏽‍💼', 'Xodim'),
                      _ProfileChoice('💻', 'O’z-o’zini band qilgan shaxs'),
                      _ProfileChoice('🎨', 'Hech biri'),
                    ],
                    selectedIndex: _profileType,
                    onSelected: (value) => setState(() => _profileType = value),
                    onContinue: _continue,
                  ),
                  2 => _ChoiceStep(
                    key: const ValueKey('create-profile-step-3'),
                    title: 'Nimaga Sun’iy intellektni\no’rganmoqchisiz?',
                    choices: const [
                      _ProfileChoice('🧑‍🤝‍🧑', 'O’z loyihamni qurish uchun'),
                      _ProfileChoice('🧑‍💻', 'Shu sohada ishlash uchun'),
                      _ProfileChoice('🚀', 'Chunki, hozir bu zamonaviy kasb'),
                      _ProfileChoice('🎨', 'Shunchaki'),
                    ],
                    selectedIndex: _learningReason,
                    onSelected: (value) =>
                        setState(() => _learningReason = value),
                    onContinue: _continue,
                  ),
                  3 => _ExperienceStep(
                    key: const ValueKey('create-profile-step-4'),
                    value: _experienceLevel,
                    onChanged: (value) =>
                        setState(() => _experienceLevel = value),
                    onContinue: _continue,
                  ),
                  4 => _CourseStep(
                    key: const ValueKey('create-profile-step-5'),
                    selectedIndex: _course,
                    onSelected: (value) => setState(() => _course = value),
                    onContinue: _continue,
                  ),
                  5 => _DailyTimeStep(
                    key: const ValueKey('create-profile-step-6'),
                    selectedIndex: _dailyTime,
                    onSelected: (value) => setState(() => _dailyTime = value),
                    onContinue: _continue,
                  ),
                  6 => _PreparingStep(
                    key: const ValueKey('create-profile-step-7'),
                    onContinue: _continue,
                  ),
                  _ => _RegistrationStep(
                    key: const ValueKey('create-profile-step-8'),
                    onLogin: widget.onLogin,
                    onProfileCreated: widget.onProfileCreated,
                  ),
                },
              ),
            ),
            if (_currentStep < _questionStepCount)
              Positioned(
                left: AppSpacing.screenHorizontal,
                top: 83,
                width: 390,
                child: _ProfileProgressIndicator(
                  step: _currentStep + 1,
                  stepCount: _questionStepCount,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold({
    required this.body,
    required this.actionLabel,
    required this.onContinue,
  });

  final Widget body;
  final String actionLabel;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBackground,
      child: Stack(
        children: [
          Positioned.fill(child: body),
          Positioned(
            left: AppSpacing.screenHorizontal,
            top: 816,
            width: 390,
            child: AppButton(label: actionLabel, onPressed: onContinue),
          ),
        ],
      ),
    );
  }
}

class _ProfileProgressIndicator extends StatelessWidget {
  const _ProfileProgressIndicator({
    required this.step,
    required this.stepCount,
  });

  final int step;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return AppLinearProgressBar(
      value: step / stepCount,
      fillColor: AppColors.primary,
      trackKey: const ValueKey('profile-progress-track'),
      fillKey: const ValueKey('profile-progress-fill'),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Boshlash',
      onContinue: onContinue,
      body: Stack(
        children: [
          const Positioned(
            left: 95,
            top: 210,
            width: 240,
            height: 250,
            child: _ProfileIllustration(
              assetPath: 'assets/images/profile/meditation_mascot.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 20,
            top: 473,
            width: 390,
            child: Column(
              children: [
                Text(
                  'Xush kelibsiz!',
                  textAlign: TextAlign.center,
                  style: AppTypography.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                SizedBox(
                  width: 330,
                  child: Text(
                    'Sizning shaxsiy o’quv dasturingizni qurish\nuchun sizga bir nechta savollar beramiz.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.title,
    required this.choices,
    required this.selectedIndex,
    required this.onSelected,
    required this.onContinue,
    super.key,
  });

  final String title;
  final List<_ProfileChoice> choices;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Keyingisi',
      onContinue: selectedIndex == null ? null : onContinue,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 145,
            width: 390,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(height: 1.35),
            ),
          ),
          Positioned(
            left: 20,
            top: 220,
            width: 390,
            child: Column(
              children: [
                for (var index = 0; index < choices.length; index++) ...[
                  _ProfileChoiceCard(
                    choice: choices[index],
                    isSelected: selectedIndex == index,
                    onTap: () => onSelected(index),
                  ),
                  if (index < choices.length - 1)
                    const SizedBox(height: AppSpacing.medium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileChoice {
  const _ProfileChoice(this.emoji, this.label);

  final String emoji;
  final String label;
}

class _ProfileChoiceCard extends StatelessWidget {
  const _ProfileChoiceCard({
    required this.choice,
    required this.isSelected,
    required this.onTap,
  });

  final _ProfileChoice choice;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.input,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.subtleOutline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.input,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                const SizedBox(width: 16),
                SizedBox(
                  width: 28,
                  child: Text(
                    choice.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(choice.label, style: AppTypography.label)),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  const _ExperienceStep({
    required this.value,
    required this.onChanged,
    required this.onContinue,
    super.key,
  });

  final double? value;
  final ValueChanged<double> onChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Keyingisi',
      onContinue: value == null ? null : onContinue,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 145,
            width: 390,
            child: Text(
              'Bu sohada qay darajada\ntajribangiz bor?',
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(height: 1.35),
            ),
          ),
          const Positioned(
            left: 100,
            top: 250,
            width: 230,
            height: 220,
            child: _ProfileIllustration(
              assetPath: 'assets/images/profile/experience_mascot.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 20,
            top: 489,
            width: 390,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Yo’q', style: _sliderLabelStyle(value == 0)),
                    Text('Biroz', style: _sliderLabelStyle(value == 1)),
                    Text('Ko’p', style: _sliderLabelStyle(value == 2)),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: value == null
                        ? AppColors.mutedSurface
                        : AppColors.primary,
                    inactiveTrackColor: AppColors.mutedSurface,
                    thumbColor: AppColors.surface,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: value == null
                        ? SliderComponentShape.noThumb
                        : const _OutlinedSliderThumbShape(),
                  ),
                  child: Slider(
                    value: value ?? 1,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _sliderLabelStyle(bool selected) => AppTypography.caption.copyWith(
    color: selected ? AppColors.primary : AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );
}

class _OutlinedSliderThumbShape extends SliderComponentShape {
  const _OutlinedSliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.square(18);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    context.canvas.drawCircle(
      center,
      7,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill,
    );
    context.canvas.drawCircle(
      center,
      7,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }
}

class _CourseStep extends StatelessWidget {
  const _CourseStep({
    required this.selectedIndex,
    required this.onSelected,
    required this.onContinue,
    super.key,
  });

  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Davom etish',
      onContinue: selectedIndex == null ? null : onContinue,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 135,
            width: 390,
            child: Column(
              children: [
                const Text(
                  'Nima o’rganishni xohlaysiz?',
                  textAlign: TextAlign.center,
                  style: AppTypography.title,
                ),
                const SizedBox(height: AppSpacing.compact),
                Text(
                  'Keyinchalik o’zgartirishingiz mumkin.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 213,
            width: 390,
            bottom: 128,
            child: Scrollbar(
              child: ListView.separated(
                key: const ValueKey('profile-course-list'),
                padding: const EdgeInsets.only(bottom: 12),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: 2,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.medium),
                itemBuilder: (context, index) => _CourseCard(
                  isSelected: selectedIndex == index,
                  onTap: () => onSelected(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.subtleOutline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.infinity,
                height: 160,
                child: _PythonCourseArtwork(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Python Developer',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    for (final feature in const [
                      'Learn a fun, all-purpose language',
                      'Top choice for data science',
                      'Complete portfolio projects',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          '✓  $feature',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PythonCourseArtwork extends StatelessWidget {
  const _PythonCourseArtwork();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset(
        'assets/images/profile/python_course.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class _DailyTimeStep extends StatelessWidget {
  const _DailyTimeStep({
    required this.selectedIndex,
    required this.onSelected,
    required this.onContinue,
    super.key,
  });

  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Davom etish',
      onContinue: selectedIndex == null ? null : onContinue,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 145,
            width: 390,
            child: Column(
              children: [
                Text(
                  'Kuniga qancha vaqt sarflay\nolasiz?',
                  textAlign: TextAlign.center,
                  style: AppTypography.title.copyWith(height: 1.35),
                ),
                const SizedBox(height: AppSpacing.compact),
                Text(
                  'Keyinchalik o’zgartira olasiz',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 105,
            top: 300,
            width: 220,
            height: 230,
            child: _ProfileIllustration(
              assetPath: 'assets/images/profile/study_mascot.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 20,
            top: 586,
            width: 390,
            child: _DailyTimeCard(
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyTimeCard extends StatelessWidget {
  const _DailyTimeCard({required this.selectedIndex, required this.onSelected});

  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  static const _options = [
    ('Oddiy', '5 daq'),
    ('Doimiy', '10 daq'),
    ('Jiddiy', '20 daq'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.input,
        side: BorderSide(color: AppColors.subtleOutline),
      ),
      child: Column(
        children: [
          for (var index = 0; index < _options.length; index++) ...[
            InkWell(
              onTap: () => onSelected(index),
              child: SizedBox(
                height: 53,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    _RadioMark(isSelected: selectedIndex == index),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _options[index].$1,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                    Text(
                      _options[index].$2,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            if (index < _options.length - 1)
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.subtleOutline,
              ),
          ],
        ],
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : AppColors.surface,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outline,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
            )
          : null,
    );
  }
}

class _PreparingStep extends StatelessWidget {
  const _PreparingStep({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _ProfileScaffold(
      actionLabel: 'Shaxsiy dasturimni ko’rish',
      onContinue: onContinue,
      body: Stack(
        children: [
          const Positioned(
            left: 100,
            top: 315,
            width: 230,
            height: 230,
            child: _ProfileIllustration(
              assetPath: 'assets/images/profile/meditation_mascot.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 55,
            top: 570,
            width: 320,
            child: Text(
              'Biroz kuting, biz sizning o’quv\ndasturingizni tuzyapmiz...',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIllustration extends StatelessWidget {
  const _ProfileIllustration({required this.assetPath, required this.fit});

  final String assetPath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(child: Image.asset(assetPath, fit: fit));
  }
}

class _RegistrationStep extends StatefulWidget {
  const _RegistrationStep({
    required this.onLogin,
    required this.onProfileCreated,
    super.key,
  });

  final VoidCallback onLogin;
  final VoidCallback onProfileCreated;

  @override
  State<_RegistrationStep> createState() => _RegistrationStepState();
}

class _RegistrationStepState extends State<_RegistrationStep> {
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        const AppBrandBackdrop(),
        const Positioned(
          left: 39.82,
          top: 52,
          width: 350.4,
          height: 345,
          child: Image(
            image: AssetImage('assets/images/auth/login_mascot.png'),
            fit: BoxFit.contain,
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 575,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.sheetTop,
              boxShadow: AppShadows.elevatedCard,
            ),
          ),
        ),
        const Positioned(
          left: 286.5,
          top: 138,
          width: 25.51,
          height: 20.5,
          child: _SpeechTail(),
        ),
        Positioned(
          left: 293,
          top: 94,
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
        Positioned(
          left: 20,
          top: 382,
          width: 390,
          child: Column(
            children: [
              Text(
                'Xush kelibsiz! 👋',
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                'Davom etish uchun ro’yxatdan o’ting',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              const AppTextField(
                hintText: 'Ismingiz',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              AppTextField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: SvgPicture.asset('assets/icons/auth/email.svg'),
              ),
              const SizedBox(height: AppSpacing.medium),
              AppTextField(
                hintText: 'Parol',
                obscureText: _obscurePassword,
                prefixIcon: SvgPicture.asset('assets/icons/auth/password.svg'),
                suffixIcon: _PasswordVisibilityIcon(obscure: _obscurePassword),
                onSuffixPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: AppSpacing.medium),
              AppTextField(
                hintText: 'Parolni qayta tering',
                obscureText: _obscureConfirmation,
                prefixIcon: SvgPicture.asset('assets/icons/auth/password.svg'),
                suffixIcon: _PasswordVisibilityIcon(
                  obscure: _obscureConfirmation,
                ),
                onSuffixPressed: () => setState(
                  () => _obscureConfirmation = !_obscureConfirmation,
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              AppButton(
                label: 'Ro’yxatdan o’tish',
                onPressed: widget.onProfileCreated,
              ),
              const SizedBox(height: AppSpacing.section),
              const _RegistrationDivider(),
              const SizedBox(height: AppSpacing.section),
              AppButton(
                label: 'Google orqali',
                onPressed: widget.onProfileCreated,
                variant: AppButtonVariant.outlined,
                contentGap: 12,
                leading: SvgPicture.asset(
                  'assets/icons/auth/google.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              _LoginPrompt(onPressed: widget.onLogin),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpeechTail extends StatelessWidget {
  const _SpeechTail();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/auth/speech_tail.svg',
      fit: BoxFit.fill,
    );
  }
}

class _PasswordVisibilityIcon extends StatelessWidget {
  const _PasswordVisibilityIcon({required this.obscure});

  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return obscure
        ? SvgPicture.asset('assets/icons/auth/visibility.svg')
        : Image.asset('assets/icons/auth/hide-password.png');
  }
}

class _RegistrationDivider extends StatelessWidget {
  const _RegistrationDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.outline, height: 1)),
        const SizedBox(width: AppSpacing.controlGap),
        Text(
          'yoki',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.controlGap),
        const Expanded(child: Divider(color: AppColors.outline, height: 1)),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Profilingiz bormi?',
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
              'Profilga kirish',
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
