import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/models/skill.dart';
import 'package:cv_app/widgets/skill_bar.dart';

void main() {
  Widget buildSkillBar(Skill skill) {
    return MaterialApp(home: Scaffold(body: SkillBar(skill: skill)));
  }

  group('SkillBar', () {
    test('percentage rounds correctly', () {
      expect((0.75 * 100).round(), 75);
      expect((0.95 * 100).round(), 95);
    });

    testWidgets('displays label and percentage text', (tester) async {
      await tester.pumpWidget(buildSkillBar(const Skill(label: 'Flutter', level: 0.75)));
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('contains a LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(buildSkillBar(const Skill(label: 'Dart', level: 0.9)));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('animation reaches target value after settling', (tester) async {
      await tester.pumpWidget(buildSkillBar(const Skill(label: 'Git', level: 0.85)));
      await tester.pumpAndSettle();
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.85, 0.01));
    });
  });
}
