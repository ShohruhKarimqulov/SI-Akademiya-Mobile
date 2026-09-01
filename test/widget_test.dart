import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:si_akademiyasi_mobile/features/auth/presentation/login_screen.dart';
import 'package:si_akademiyasi_mobile/features/curriculum/presentation/personal_curriculum_screen.dart';
import 'package:si_akademiyasi_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:si_akademiyasi_mobile/features/profile/presentation/create_profile_flow.dart';
import 'package:si_akademiyasi_mobile/main.dart';

void main() {
  setUpAll(() async {
    final fontLoader = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Poppins/Poppins-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Poppins/Poppins-Bold.ttf'));
    await fontLoader.load();
  });

  testWidgets('shows splash before onboarding', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SiAcademiyasiApp());

    expect(find.text('SI AKADEMIYASI'), findsOneWidget);
    expect(find.text('Keyingisi'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    expect(find.text('SI AKADEMIYASI'), findsNothing);
    expect(find.text('Keyingisi'), findsOneWidget);
  });

  testWidgets('changes onboarding content without replacing the page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsNothing);
    expect(
      find.text("Kelajak bilimlarini\noson o'zlashtiring!"),
      findsOneWidget,
    );

    await tester.tap(find.text('Keyingisi'));
    await tester.pump();

    expect(find.text('Sizning shaxsiy AI yordamchingiz'), findsOneWidget);
    expect(
      find.text("Kelajak bilimlarini\noson o'zlashtiring!"),
      findsOneWidget,
    );

    await tester.pumpAndSettle();
    expect(find.text("Kelajak bilimlarini\noson o'zlashtiring!"), findsNothing);

    await tester.tap(find.byKey(const ValueKey('step-indicator-0')));
    await tester.pump();

    expect(
      find.text("Kelajak bilimlarini\noson o'zlashtiring!"),
      findsOneWidget,
    );
    await tester.pumpAndSettle();
  });

  testWidgets('opens login after completing onboarding', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SiAcademiyasiApp());
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Xush kelibsiz! 👋'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
  });

  testWidgets('toggles login password visibility', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    TextField passwordField() =>
        tester.widgetList<TextField>(find.byType(TextField)).last;

    expect(passwordField().obscureText, isTrue);
    await tester.tap(find.byKey(const ValueKey('password-visibility-show')));
    await tester.pump();
    expect(passwordField().obscureText, isFalse);
    expect(
      find.byKey(const ValueKey('password-visibility-hide')),
      findsOneWidget,
    );
    expect(find.text('Parolni unutdingizmi?'), findsNothing);
  });

  testWidgets('opens profile creation and returns to login from step 8', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SiAcademiyasiApp());
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ro’yxatdan o’tish'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateProfileFlow), findsOneWidget);

    expect(
      tester
          .getSize(find.byKey(const ValueKey('profile-progress-track')))
          .height,
      10,
    );
    final firstStepProgressWidth = tester
        .getSize(find.byKey(const ValueKey('profile-progress-fill')))
        .width;
    final progressPosition = tester.getTopLeft(
      find.byKey(const ValueKey('profile-progress-track')),
    );

    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('profile-progress-track'))),
      progressPosition,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('profile-progress-fill'))).width,
      greaterThan(firstStepProgressWidth),
    );

    FilledButton currentButton(String label) =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, label));

    expect(currentButton('Keyingisi').onPressed, isNull);
    await tester.tap(find.text('Maktab o’quvchisi'));
    await tester.pump();
    expect(currentButton('Keyingisi').onPressed, isNotNull);
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();

    expect(currentButton('Keyingisi').onPressed, isNull);
    await tester.tap(find.text('O’z loyihamni qurish uchun'));
    await tester.pump();
    expect(currentButton('Keyingisi').onPressed, isNotNull);
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();

    expect(currentButton('Keyingisi').onPressed, isNotNull);
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();

    expect(currentButton('Davom etish').onPressed, isNull);
    final secondCourseBeforeScroll = tester
        .getTopLeft(find.text('Python Developer').last)
        .dy;
    await tester.drag(
      find.byKey(const ValueKey('profile-course-list')),
      const Offset(0, -60),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Python Developer').last).dy,
      lessThan(secondCourseBeforeScroll),
    );
    await tester.tap(find.text('Python Developer').first);
    await tester.pump();
    expect(currentButton('Davom etish').onPressed, isNotNull);
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();

    expect(currentButton('Davom etish').onPressed, isNull);
    await tester.tap(find.text('Oddiy'));
    await tester.pump();
    expect(currentButton('Davom etish').onPressed, isNotNull);
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Shaxsiy dasturimni ko’rish'));
    await tester.pumpAndSettle();

    expect(find.text('Ismingiz'), findsOneWidget);
    expect(find.text('Profilga kirish'), findsOneWidget);

    await tester.tap(find.text('Profilga kirish'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
  });

  testWidgets('opens personal curriculum after profile registration', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SiAcademiyasiApp());
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ro’yxatdan o’tish'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Boshlash'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maktab o’quvchisi'));
    await tester.pump();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O’z loyihamni qurish uchun'));
    await tester.pump();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keyingisi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Python Developer').first);
    await tester.pump();
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oddiy'));
    await tester.pump();
    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shaxsiy dasturimni ko’rish'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ro’yxatdan o’tish'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonalCurriculumScreen), findsOneWidget);
    expect(find.text('Kurs'), findsOneWidget);
    expect(find.text('Python Developer'), findsOneWidget);
    expect(find.text('1. Pythonga kirish'), findsNWidgets(3));
    expect(find.text('O’rganishni boshlash'), findsOneWidget);

    final lastModuleBeforeScroll = tester
        .getTopLeft(find.text('1. Pythonga kirish').last)
        .dy;
    await tester.drag(
      find.byKey(const ValueKey('personal-curriculum-list')),
      const Offset(0, -80),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('1. Pythonga kirish').last).dy,
      lessThan(lastModuleBeforeScroll),
    );
  });
}
