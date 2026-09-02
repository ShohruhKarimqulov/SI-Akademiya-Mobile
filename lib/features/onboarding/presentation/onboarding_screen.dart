import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({this.initialPage = 0, this.onFinished, super.key})
    : assert(initialPage >= 0 && initialPage < _pageCount);

  final int initialPage;
  final VoidCallback? onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const _transitionDuration = Duration(milliseconds: 900);
  static const _entranceDuration = Duration(milliseconds: 1050);

  late final AnimationController _entranceController;
  late final AnimationController _transitionController;
  late final Listenable _animations;
  late int _currentPage;
  int? _previousPage;
  bool _isMovingForward = true;
  bool _didPrecacheMascots = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _entranceController = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );
    _transitionController = AnimationController(
      vsync: this,
      duration: _transitionDuration,
    );
    _animations = Listenable.merge([
      _entranceController,
      _transitionController,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheMascots) {
      return;
    }

    _didPrecacheMascots = true;
    Future.wait([
      for (final page in _pages)
        precacheImage(
          ResizeImage(AssetImage(page.assetPath), width: 600),
          context,
        ),
      precacheImage(
        const AssetImage('assets/icons/actions/arrow-right-light@4x.png'),
        context,
      ),
    ]).then((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_transitionController.isAnimating) {
      return;
    }

    if (_currentPage == _pages.length - 1) {
      widget.onFinished?.call();
      return;
    }

    _changePage(_currentPage + 1);
  }

  void _goToPreviousPage(int page) {
    if (page >= _currentPage) {
      return;
    }

    _changePage(page);
  }

  void _changePage(int page) {
    if (_transitionController.isAnimating ||
        page < 0 ||
        page >= _pages.length ||
        page == _currentPage) {
      return;
    }

    if (_entranceController.isAnimating) {
      _entranceController.value = 1;
    }

    setState(() {
      _previousPage = _currentPage;
      _isMovingForward = page > _currentPage;
      _currentPage = page;
    });

    _transitionController.forward(from: 0).whenComplete(() {
      if (mounted) {
        setState(() => _previousPage = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: AppDesignCanvas(
        child: AnimatedBuilder(
          animation: _animations,
          builder: (context, child) => _OnboardingPage(
            data: _pages[_currentPage],
            outgoingData: _previousPage == null ? null : _pages[_previousPage!],
            pageIndex: _currentPage,
            entranceProgress: _entranceController.value,
            mascotTransitionProgress: _transitionController.value,
            isMovingForward: _isMovingForward,
            onContinue: _continue,
            onPreviousStepPressed: _goToPreviousPage,
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.outgoingData,
    required this.pageIndex,
    required this.entranceProgress,
    required this.mascotTransitionProgress,
    required this.isMovingForward,
    required this.onContinue,
    required this.onPreviousStepPressed,
  });

  final _OnboardingPageData data;
  final _OnboardingPageData? outgoingData;
  final int pageIndex;
  final double entranceProgress;
  final double mascotTransitionProgress;
  final bool isMovingForward;
  final VoidCallback onContinue;
  final ValueChanged<int> onPreviousStepPressed;

  @override
  Widget build(BuildContext context) {
    final isChangingPage = outgoingData != null;
    final isEnteringOnboarding = !isChangingPage && entranceProgress < 1;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        const AppBrandBackdrop(),
        if (isChangingPage)
          _MovingMascot(
            data: data,
            progress: mascotTransitionProgress,
            isEntering: true,
            horizontalDirection: isMovingForward ? 1 : -1,
          )
        else if (isEnteringOnboarding)
          _MovingMascot(
            data: data,
            progress: _intervalProgress(entranceProgress, 0.08, 0.82),
            isEntering: true,
            horizontalDirection: null,
          )
        else if (!data.illustrationAboveSheet)
          _OnboardingIllustration(data: data),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 428,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.sheetTop,
              boxShadow: AppShadows.elevatedCard,
            ),
          ),
        ),
        if (!isChangingPage &&
            !isEnteringOnboarding &&
            data.illustrationAboveSheet)
          _OnboardingIllustration(data: data),
        if (isChangingPage)
          _MovingMascot(
            data: outgoingData!,
            progress: mascotTransitionProgress,
            isEntering: false,
            horizontalDirection: isMovingForward ? 1 : -1,
          ),
        Positioned(
          left: 20,
          top: 544,
          width: 390,
          child: isChangingPage
              ? _ChangingOnboardingCopy(
                  incomingData: data,
                  outgoingData: outgoingData!,
                  progress: mascotTransitionProgress,
                )
              : _OnboardingCopy(
                  data: data,
                  titleProgress: _intervalProgress(
                    entranceProgress,
                    0.12,
                    0.44,
                  ),
                  descriptionProgress: _intervalProgress(
                    entranceProgress,
                    0.24,
                    0.58,
                  ),
                ),
        ),
        Positioned(
          left: 125,
          top: 816,
          width: 180,
          child: IgnorePointer(
            ignoring: entranceProgress < 0.72,
            child: _EntranceReveal(
              progress: _intervalProgress(entranceProgress, 0.42, 0.76),
              offsetY: 32,
              child: AppButton(
                label: data.actionLabel,
                onPressed: onContinue,
                height: 56,
                borderRadius: AppRadius.choice,
                trailing: Image.asset(
                  'assets/icons/actions/arrow-right-light@4x.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 30,
          top: 83,
          width: 370,
          child: _EntranceReveal(
            progress: _intervalProgress(entranceProgress, 0, 0.3),
            offsetY: -10,
            clip: false,
            child: AppStepProgressIndicator(
              stepCount: _pages.length,
              currentStep: pageIndex,
              onPreviousStepPressed: onPreviousStepPressed,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({
    required this.data,
    required this.titleProgress,
    required this.descriptionProgress,
    this.isExiting = false,
    this.offsetY = 0,
  });

  final _OnboardingPageData data;
  final double titleProgress;
  final double descriptionProgress;
  final bool isExiting;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Column(
        children: [
          _StaggeredText(
            text: data.title,
            textAlign: TextAlign.center,
            style: AppTypography.display,
            progress: titleProgress,
            isExiting: isExiting,
          ),
          const SizedBox(height: AppSpacing.compact),
          SizedBox(
            width: data.descriptionWidth,
            child: _StaggeredText(
              text: data.description,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                height: 30 / 16,
                color: AppColors.textSecondary,
              ),
              progress: descriptionProgress,
              isExiting: isExiting,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangingOnboardingCopy extends StatelessWidget {
  const _ChangingOnboardingCopy({
    required this.incomingData,
    required this.outgoingData,
    required this.progress,
  });

  final _OnboardingPageData incomingData;
  final _OnboardingPageData outgoingData;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final motionProgress = Curves.easeInOutCubic.transform(progress);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _OnboardingCopy(
          data: outgoingData,
          titleProgress: _linearIntervalProgress(progress, 0, 0.48),
          descriptionProgress: _linearIntervalProgress(progress, 0.08, 0.58),
          isExiting: true,
          offsetY: -12 * motionProgress,
        ),
        _OnboardingCopy(
          data: incomingData,
          titleProgress: _linearIntervalProgress(progress, 0.18, 0.88),
          descriptionProgress: _linearIntervalProgress(progress, 0.36, 1),
          offsetY: 14 * (1 - motionProgress),
        ),
      ],
    );
  }
}

class _StaggeredText extends StatelessWidget {
  const _StaggeredText({
    required this.text,
    required this.textAlign,
    required this.style,
    required this.progress,
    required this.isExiting,
  });

  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final double progress;
  final bool isExiting;

  @override
  Widget build(BuildContext context) {
    final tokens = RegExp(r'\S+|\s+').allMatches(text).map((match) {
      return match.group(0)!;
    }).toList();
    final wordCount = tokens.where((token) => token.trim().isNotEmpty).length;
    final baseColor = style.color ?? DefaultTextStyle.of(context).style.color!;
    var wordIndex = 0;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          for (final token in tokens)
            if (token.trim().isEmpty)
              TextSpan(text: token)
            else
              TextSpan(
                text: token,
                style: style.copyWith(
                  color: baseColor.withValues(
                    alpha: _wordOpacity(wordIndex++, wordCount),
                  ),
                ),
              ),
        ],
      ),
      textAlign: textAlign,
    );
  }

  double _wordOpacity(int index, int wordCount) {
    if (wordCount <= 1) {
      return isExiting ? 1 - progress : progress;
    }

    const staggerShare = 0.44;
    final start = (index / (wordCount - 1)) * staggerShare;
    final reveal = Curves.easeInOutCubic.transform(
      _linearIntervalProgress(progress, start, start + (1 - staggerShare)),
    );
    return isExiting ? 1 - reveal : reveal;
  }
}

class _EntranceReveal extends StatelessWidget {
  const _EntranceReveal({
    required this.progress,
    required this.child,
    this.offsetY = 24,
    this.clip = true,
  });

  final double progress;
  final double offsetY;
  final bool clip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reveal = Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, offsetY * (1 - progress)),
        child: child,
      ),
    );

    return clip ? ClipRect(child: reveal) : reveal;
  }
}

class _MovingMascot extends StatelessWidget {
  const _MovingMascot({
    required this.data,
    required this.progress,
    required this.isEntering,
    required this.horizontalDirection,
  });

  final _OnboardingPageData data;
  final double progress;
  final bool isEntering;
  final double? horizontalDirection;

  @override
  Widget build(BuildContext context) {
    final motionProgress = Curves.easeInOutCubic.transform(progress);
    final isHorizontal = horizontalDirection != null;
    final opacity = isHorizontal
        ? isEntering
              ? _intervalProgress(progress, 0.02, 0.42)
              : 1 - _intervalProgress(progress, 0.58, 0.96)
        : isEntering
        ? _intervalProgress(progress, 0.06, 0.62)
        : 1 - _intervalProgress(progress, 0.34, 0.88);
    final offset = isHorizontal
        ? Offset(
            isEntering
                ? 430 * horizontalDirection! * (1 - motionProgress)
                : -430 * horizontalDirection! * motionProgress,
            0,
          )
        : Offset(
            0,
            isEntering ? 430 * (1 - motionProgress) : -520 * motionProgress,
          );

    return Positioned.fill(
      child: ClipPath(
        clipper: const _MascotViewportClipper(),
        child: Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset,
            child: _OnboardingIllustration(data: data),
          ),
        ),
      ),
    );
  }
}

class _MascotViewportClipper extends CustomClipper<Path> {
  const _MascotViewportClipper();

  @override
  Path getClip(Size size) =>
      Path()..addRect(Rect.fromLTRB(0, 83, size.width, 535));

  @override
  bool shouldReclip(_MascotViewportClipper oldClipper) => false;
}

double _intervalProgress(double value, double begin, double end) {
  final normalized = _linearIntervalProgress(value, begin, end);
  return Curves.easeOutCubic.transform(normalized);
}

double _linearIntervalProgress(double value, double begin, double end) {
  return ((value - begin) / (end - begin)).clamp(0.0, 1.0);
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: data.frameTop,
            width: 430,
            height: data.frameHeight,
            child: ExcludeSemantics(
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fromRect(
                      rect: data.imageRect,
                      child: Image.asset(
                        data.assetPath,
                        fit: BoxFit.fill,
                        cacheWidth: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.assetPath,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.frameTop,
    required this.frameHeight,
    required this.imageRect,
    required this.illustrationAboveSheet,
    this.descriptionWidth = 390,
  });

  final String assetPath;
  final String title;
  final String description;
  final String actionLabel;
  final double frameTop;
  final double frameHeight;
  final Rect imageRect;
  final bool illustrationAboveSheet;
  final double descriptionWidth;
}

const _pages = [
  _OnboardingPageData(
    assetPath: 'assets/images/onboarding/learn.png',
    title: "Kelajak bilimlarini\noson o'zlashtiring!",
    description:
        "Murakkab sun'iy intellekt va dasturlash sirlarini kunlik qisqa, "
        "qiziqarli va tushunarli darslar orqali noldan o'rganing.",
    actionLabel: 'Keyingisi',
    frameTop: 91,
    frameHeight: 444,
    imageRect: Rect.fromLTWH(-55.169, -28.016, 480.31, 472.016),
    illustrationAboveSheet: true,
  ),
  _OnboardingPageData(
    assetPath: 'assets/images/onboarding/assistant.png',
    title: 'Sizning shaxsiy AI yordamchingiz',
    description:
        "O'qish jarayonida qiyinchilikka uchradingizmi? Bizning aqlli "
        "yordamchimiz sizga har qadamda to'g'ri yo'l ko'rsatishga va "
        'savollaringizga javob berishga tayyor.',
    actionLabel: 'Keyingisi',
    frameTop: 91,
    frameHeight: 443,
    imageRect: Rect.fromLTWH(15.007, -14.043, 399.986, 496.09),
    illustrationAboveSheet: true,
  ),
  _OnboardingPageData(
    assetPath: 'assets/images/onboarding/practice.png',
    title: 'Amaliyot qiling va darajangizni oshiring',
    description:
        "O'zlashtirgan bilimlaringizni amaliy topshiriqlarda sinab ko'ring, "
        "ballar yig'ing va o'z yutuqlaringiz bilan bo'lishing. Boshlashga "
        'tayyormisiz?',
    actionLabel: 'Boshlash',
    frameTop: 101,
    frameHeight: 490,
    imageRect: Rect.fromLTWH(0, -44.198, 430, 534.345),
    illustrationAboveSheet: false,
    descriptionWidth: 370,
  ),
];

const _pageCount = 3;
