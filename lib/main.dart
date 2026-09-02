import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'design_system/design_system.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/curriculum/presentation/personal_curriculum_screen.dart';
import 'features/learn/presentation/learn_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/profile/presentation/create_profile_flow.dart';
import 'features/splash/presentation/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Keep Flutter Inspector paint helpers from leaking into app screenshots.
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: const [SystemUiOverlay.top],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SiAcademiyasiApp());
}

class SiAcademiyasiApp extends StatelessWidget {
  const SiAcademiyasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SI Akademiyasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.primary,
      ),
      home: const _LaunchFlow(),
    );
  }
}

class _LaunchFlow extends StatefulWidget {
  const _LaunchFlow();

  @override
  State<_LaunchFlow> createState() => _LaunchFlowState();
}

class _LaunchFlowState extends State<_LaunchFlow> {
  static const _splashDuration = Duration(milliseconds: 1800);
  late final Timer _splashTimer;
  bool _showSplash = true;
  bool _showLogin = false;
  bool _showCreateProfile = false;
  bool _showPersonalCurriculum = false;
  bool _showLearn = false;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(_splashDuration, () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  void dispose() {
    _splashTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : _showLearn
          ? const LearnScreen(key: ValueKey('learn'))
          : _showPersonalCurriculum
          ? PersonalCurriculumScreen(
              key: const ValueKey('personal-curriculum'),
              onStartLearning: () {
                setState(() {
                  _showPersonalCurriculum = false;
                  _showLearn = true;
                });
              },
            )
          : _showCreateProfile
          ? CreateProfileFlow(
              key: const ValueKey('create-profile'),
              onLogin: () {
                setState(() {
                  _showCreateProfile = false;
                  _showLogin = true;
                });
              },
              onProfileCreated: () {
                setState(() {
                  _showCreateProfile = false;
                  _showPersonalCurriculum = true;
                });
              },
            )
          : _showLogin
          ? LoginScreen(
              key: const ValueKey('login'),
              onRegister: () => setState(() => _showCreateProfile = true),
              onLogin: () {
                setState(() {
                  _showLogin = false;
                  _showLearn = true;
                });
              },
            )
          : OnboardingScreen(
              key: const ValueKey('onboarding'),
              onFinished: () => setState(() => _showLogin = true),
            ),
    );
  }
}
