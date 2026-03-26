import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/viewmodels/cv_viewmodel.dart';

void main() {
  group('CvNotifier', () {
    test('initial expandedEntries is empty', () {
      final notifier = CvNotifier();
      expect(notifier.state.expandedEntries, isEmpty);
    });

    test('toggleEntry adds an index when not present', () {
      final notifier = CvNotifier();
      notifier.toggleEntry(0);
      expect(notifier.state.expandedEntries, contains(0));
    });

    test('toggleEntry removes an index when already present', () {
      final notifier = CvNotifier();
      notifier.toggleEntry(0);
      notifier.toggleEntry(0);
      expect(notifier.state.expandedEntries, isEmpty);
    });

    test('multiple indices can be expanded independently', () {
      final notifier = CvNotifier();
      notifier.toggleEntry(0);
      notifier.toggleEntry(2);
      expect(notifier.state.expandedEntries, containsAll([0, 2]));
    });

    test('closing one index does not affect others', () {
      final notifier = CvNotifier();
      notifier.toggleEntry(0);
      notifier.toggleEntry(2);
      notifier.toggleEntry(0);
      expect(notifier.state.expandedEntries, isNot(contains(0)));
      expect(notifier.state.expandedEntries, contains(2));
    });
  });
}
