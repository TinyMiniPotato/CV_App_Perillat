import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/models/skill.dart';

void main() {
  group('Skill model', () {
    test('all cvSkills have level between 0.0 and 1.0', () {
      for (final skill in cvSkills) {
        expect(
          skill.level,
          inInclusiveRange(0.0, 1.0),
          reason: '${skill.label} has invalid level ${skill.level}',
        );
      }
    });

    test('all cvSkills have a non-empty label', () {
      for (final skill in cvSkills) {
        expect(skill.label, isNotEmpty);
      }
    });

    test('cvSkills is not empty', () {
      expect(cvSkills, isNotEmpty);
    });
  });
}
