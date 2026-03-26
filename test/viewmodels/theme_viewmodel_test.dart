import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/viewmodels/theme_viewmodel.dart';

void main() {
  group('ThemeNotifier', () {
    test('initial state is false (light mode)', () {
      final notifier = ThemeNotifier();
      expect(notifier.state, false);
    });

    test('toggle once switches to dark mode', () {
      final notifier = ThemeNotifier();
      notifier.toggle();
      expect(notifier.state, true);
    });

    test('toggle twice returns to light mode', () {
      final notifier = ThemeNotifier();
      notifier.toggle();
      notifier.toggle();
      expect(notifier.state, false);
    });
  });
}
