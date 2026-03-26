import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/viewmodels/locale_viewmodel.dart';

void main() {
  group('LocaleNotifier', () {
    test('initial locale is French', () {
      final notifier = LocaleNotifier();
      expect(notifier.state, const Locale('fr'));
    });

    test('setLocale changes to the given locale', () {
      final notifier = LocaleNotifier();
      notifier.setLocale(const Locale('en'));
      expect(notifier.state, const Locale('en'));
    });

    test('setLocale can switch back to French', () {
      final notifier = LocaleNotifier();
      notifier.setLocale(const Locale('en'));
      notifier.setLocale(const Locale('fr'));
      expect(notifier.state, const Locale('fr'));
    });
  });
}
