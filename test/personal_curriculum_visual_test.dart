import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:si_akademiyasi_mobile/features/curriculum/presentation/personal_curriculum_screen.dart';

void main() {
  testWidgets('renders personal curriculum reference frame', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: PersonalCurriculumScreen()),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PersonalCurriculumScreen),
      matchesGoldenFile('goldens/personal_curriculum.png'),
    );
  });
}
