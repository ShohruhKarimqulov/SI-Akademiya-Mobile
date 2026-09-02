import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:si_akademiyasi_mobile/design_system/design_system.dart';
import 'package:si_akademiyasi_mobile/features/auth/presentation/login_screen.dart';
import 'package:si_akademiyasi_mobile/features/curriculum/presentation/personal_curriculum_screen.dart';
import 'package:si_akademiyasi_mobile/features/learn/presentation/learn_screen.dart';
import 'package:si_akademiyasi_mobile/features/learn/presentation/widgets/pixel_scene_backdrop.dart';
import 'package:si_akademiyasi_mobile/features/lesson/presentation/fill_blank_lesson_screen.dart';
import 'package:si_akademiyasi_mobile/features/lesson/presentation/free_input_lesson_screen.dart';
import 'package:si_akademiyasi_mobile/features/lesson/presentation/single_choice_lesson_screen.dart';
import 'package:si_akademiyasi_mobile/features/lesson/presentation/true_order_lesson_screen.dart';
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

  testWidgets('scrolls the complete login page above the keyboard', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();

    final pageScroll = find.byKey(const ValueKey('login-page-scroll'));
    final mascotBefore = tester.getTopLeft(find.byType(Image).first);
    await tester.tap(find.byType(TextField).last);
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();

    expect(pageScroll, findsOneWidget);
    expect(
      tester.getBottomRight(find.byType(TextField).last).dy,
      lessThanOrEqualTo(612),
    );
    expect(
      tester.getTopLeft(find.byType(Image).first).dy,
      lessThan(mascotBefore.dy),
    );
  });

  testWidgets('opens profile creation and returns to login from step 8', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetViewInsets);

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

    await tester.ensureVisible(find.text('Ro’yxatdan o’tish'));
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
    expect(
      find.byKey(const ValueKey('registration-page-scroll')),
      findsOneWidget,
    );

    await tester.tap(find.byType(TextField).last);
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();
    expect(
      tester.getBottomRight(find.byType(TextField).last).dy,
      lessThanOrEqualTo(612),
    );
    tester.view.resetViewInsets();
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Profilga kirish'));
    await tester.pumpAndSettle();
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
    await tester.ensureVisible(find.text('Ro’yxatdan o’tish'));
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

    await tester.ensureVisible(find.text('Ro’yxatdan o’tish'));
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

    await tester.tap(find.text('O’rganishni boshlash'));
    await tester.pumpAndSettle();

    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.text('1. Prompt Engineeringga kirish'), findsOneWidget);
    expect(find.text('220'), findsOneWidget);
  });

  testWidgets('learn map matches the fixed Figma chrome and scrolls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('1. Prompt Engineeringga kirish')),
      const Offset(36, 193),
    );

    final nav = find.byType(AppBottomNavBar);
    expect(tester.getSize(nav), const Size(234, 78));
    expect(tester.getTopLeft(nav), const Offset(98, 820));

    final projectBeforeScroll = tester.getTopLeft(find.text('Bot')).dy;
    await tester.drag(
      find.byKey(const ValueKey('learn-path-scroll')),
      const Offset(0, -430),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Bot')).dy,
      lessThan(projectBeforeScroll),
    );
    expect(
      tester.getTopLeft(find.text('1. Prompt Engineeringga kirish')),
      const Offset(36, 193),
    );
  });

  testWidgets('keeps the scene fixed and makes later section titles sticky', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.pumpAndSettle();

    final scene = find.byType(PixelSceneBackdrop);
    expect(scene, findsOneWidget);
    expect(tester.getTopLeft(scene), Offset.zero);

    await tester.drag(
      find.byKey(const ValueKey('learn-path-scroll')),
      const Offset(0, -1400),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(scene), Offset.zero);
    expect(find.byKey(const ValueKey('second-section-header')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('second-section-header'))),
      const Offset(20, 148),
    );
  });

  testWidgets('keeps the course card exclusive to the learn tab', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('learn-course-section')), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Yutuqlar'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('learn-course-section')), findsNothing);

    await tester.tap(find.bySemanticsLabel('Profil'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('learn-course-section')), findsNothing);
  });

  testWidgets('animates the bottom navigation through every tab pair', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.pumpAndSettle();

    Future<void> verifyMove(String label) async {
      final indicator = find.byKey(const ValueKey('bottom-nav-indicator'));
      final start = tester.getCenter(indicator).dx;
      await tester.tap(find.bySemanticsLabel(label));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isTrue);
      await tester.pumpAndSettle();
      final end = tester.getCenter(indicator).dx;

      expect(end, isNot(start));
    }

    await verifyMove('Profil');
    await verifyMove('Yutuqlar');
    await verifyMove('O’qish');
    await verifyMove('Yutuqlar');
    await verifyMove('Profil');
    await verifyMove('O’qish');
  });

  testWidgets('runs view, change and open course modal flow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var continueCount = 0;
    await tester.pumpWidget(
      MaterialApp(home: LearnScreen(onContinueCourse: () => continueCount++)),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('learn-course-section')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('course-overview-list')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('course-overview-redo')));
    await tester.pumpAndSettle();
    expect(find.text('Kursni tanlang'), findsOneWidget);

    final closeButton = find.byKey(const ValueKey('change-course-close'));
    final modalTitle = find.text('Kursni tanlang');
    expect(tester.getTopLeft(closeButton).dx, lessThan(20));
    expect(
      tester.getTopRight(closeButton).dx,
      lessThan(tester.getTopLeft(modalTitle).dx),
    );
    expect(tester.getCenter(modalTitle).dx, 215);

    await tester.tap(find.byKey(const ValueKey('course-selection-1')));
    await tester.pumpAndSettle();
    expect(find.text('Kursni tanlang'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Joriy dars'));
    await tester.pumpAndSettle();
    expect(find.text('Davom ettirish'), findsOneWidget);
    expect(find.text('Prompt Engineering'), findsOneWidget);

    await tester.tap(find.text('Davom ettirish'));
    await tester.pumpAndSettle();
    expect(continueCount, 1);

    await tester.tap(find.byKey(const ValueKey('learn-course-section')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('course-progress-item-0')));
    await tester.pumpAndSettle();
    expect(find.text('Davom ettirish'), findsOneWidget);

    await tester.tap(find.text('Davom ettirish'));
    await tester.pumpAndSettle();
    expect(continueCount, 2);
  });

  testWidgets('continues from course confirmation into the lesson', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: LearnScreen()));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Joriy dars'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Davom ettirish'));
    await tester.pumpAndSettle();

    expect(find.byType(SingleChoiceLessonScreen), findsOneWidget);
    expect(find.text('Qaysi biri Generative AI ga\nmisol?'), findsOneWidget);
  });

  testWidgets('moves through fill blank, ordering and the true answer state', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: SingleChoiceLessonScreen()),
    );

    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();
    expect(find.byType(FillBlankLessonScreen), findsOneWidget);
    expect(find.text('To’ldiring.'), findsOneWidget);

    final fillBlankButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Javobni Tekshirish'),
    );
    expect(fillBlankButton.onPressed, isNull);
    await tester.tap(find.text('Excel'));
    await tester.pumpAndSettle();
    final underline = tester.widget<Container>(
      find.byKey(const ValueKey('fill-blank-answer-underline')),
    );
    expect(underline.padding, const EdgeInsets.only(bottom: 2));
    final underlineDecoration = underline.decoration! as BoxDecoration;
    expect(
      underlineDecoration.border,
      const Border(bottom: BorderSide(color: AppColors.textPrimary)),
    );

    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();
    expect(find.byType(TrueOrderLessonScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('available-(')));
    await tester.tap(find.byKey(const ValueKey('available-“Hello”')));
    await tester.tap(find.byKey(const ValueKey('available-)')));
    final questionPosition = tester.getTopLeft(
      find.text('To’g’ri ketma-ketlikda\njoylashtiring.'),
    );
    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();

    expect(find.byType(TrueOrderLessonScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('true-answer-panel')), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('To’g’ri ketma-ketlikda\njoylashtiring.')),
      questionPosition,
    );

    await tester.tap(find.text('Davom etish'));
    await tester.pumpAndSettle();
    expect(find.byType(FreeInputLessonScreen), findsOneWidget);
    expect(find.text('Formula natijasini kiriting.'), findsOneWidget);
  });

  testWidgets('allows placed ordering tokens to be dragged into a new order', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: TrueOrderLessonScreen()));

    await tester.tap(find.byKey(const ValueKey('available-)')));
    await tester.tap(find.byKey(const ValueKey('available-“Hello”')));
    await tester.tap(find.byKey(const ValueKey('available-(')));
    await tester.pump();

    Future<void> moveToken(String token, int targetIndex) async {
      final start = tester.getCenter(find.byKey(ValueKey('placed-$token')));
      final destination = tester.getCenter(
        find.byKey(ValueKey('order-drop-target-$targetIndex')),
      );
      await tester.dragFrom(start, destination - start);
      await tester.pumpAndSettle();
    }

    await moveToken('(', 1);
    await moveToken('“Hello”', 2);
    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();

    expect(find.byType(TrueOrderLessonScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('true-answer-panel')), findsOneWidget);
  });

  testWidgets('free input swaps its submit controls with the keyboard', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const MaterialApp(home: FreeInputLessonScreen()));
    await tester.pumpAndSettle();

    final surface = find.byKey(const ValueKey('free-input-field-surface'));
    final unfocusedSurface = tester.widget<AnimatedContainer>(surface);
    final unfocusedDecoration = unfocusedSurface.decoration! as BoxDecoration;
    expect(unfocusedDecoration.color, AppColors.mutedSurface);

    await tester.tap(find.byKey(const ValueKey('free-input-answer')));
    await tester.pump();
    final focusedSurface = tester.widget<AnimatedContainer>(surface);
    final focusedDecoration = focusedSurface.decoration! as BoxDecoration;
    expect(focusedDecoration.color, AppColors.mutedSurface);
    expect(focusedDecoration.border, isNull);
    expect(focusedSurface.constraints?.maxWidth, 68);
    expect(
      tester.getCenter(find.byKey(const ValueKey('free-input-answer'))).dy,
      closeTo(tester.getCenter(surface).dy, 0.1),
    );

    expect(find.text('Javobni Tekshirish'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('free-input-dismiss-keyboard')),
      findsNothing,
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    expect(find.text('Javobni Tekshirish'), findsNothing);
    expect(
      find.byKey(const ValueKey('free-input-dismiss-keyboard')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('free-input-dismiss-keyboard')));
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();

    expect(find.byType(FreeInputLessonScreen), findsOneWidget);
    expect(find.text('Javobni Tekshirish'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('free-input-dismiss-keyboard')),
      findsNothing,
    );
  });

  testWidgets('shows and handles the false answer state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: TrueOrderLessonScreen()));

    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();
    expect(find.byType(TrueOrderLessonScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('false-answer-panel')), findsOneWidget);

    await tester.tap(find.text('Qayta urinish'));
    await tester.pumpAndSettle();
    expect(find.byType(TrueOrderLessonScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('false-answer-panel')), findsNothing);

    await tester.tap(find.text('Javobni Tekshirish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O’tkazib yuborish'));
    await tester.pumpAndSettle();
    expect(find.byType(FreeInputLessonScreen), findsOneWidget);
  });
}
