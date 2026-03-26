import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/models/experience.dart';

void main() {
  group('Experience model', () {
    test('all cvExperiences have non-empty titleKey, company and period', () {
      for (final exp in cvExperiences) {
        expect(exp.titleKey, isNotEmpty, reason: 'titleKey is empty');
        expect(exp.company, isNotEmpty, reason: 'company is empty');
        expect(exp.period, isNotEmpty, reason: 'period is empty');
      }
    });

    test('all cvExperiences have a non-empty descriptionKey', () {
      for (final exp in cvExperiences) {
        expect(exp.descriptionKey, isNotEmpty);
      }
    });

    test('all cvEducation entries are marked as isEducation', () {
      for (final edu in cvEducation) {
        expect(edu.isEducation, isTrue);
      }
    });

    test('cvExperiences entries are not marked as isEducation', () {
      for (final exp in cvExperiences) {
        expect(exp.isEducation, isFalse);
      }
    });
  });
}
