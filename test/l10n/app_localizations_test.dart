import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/l10n/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    test('translates a known key in French', () {
      final l10n = AppLocalizations(const Locale('fr'));
      expect(l10n.translate('cv_tab'), 'CV');
      expect(l10n.translate('dark_mode'), 'Mode Sombre');
    });

    test('translates a known key in English', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.translate('cv_tab'), 'CV');
      expect(l10n.translate('dark_mode'), 'Dark Mode');
    });

    test('job_title differs between French and English', () {
      final fr = AppLocalizations(const Locale('fr'));
      final en = AppLocalizations(const Locale('en'));
      expect(fr.translate('job_title'), isNot(equals(en.translate('job_title'))));
    });

    test('unknown key returns the key itself as fallback', () {
      final l10n = AppLocalizations(const Locale('fr'));
      expect(l10n.translate('nonexistent_key'), 'nonexistent_key');
    });
  });
}
