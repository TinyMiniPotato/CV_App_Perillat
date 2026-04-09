import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles/classic_compact_style.dart';
import '../styles/classic_style.dart';
import '../styles/cv_style.dart';
import '../styles/minimal_style.dart';
import '../styles/modern_dark_style.dart';
import '../styles/modern_style.dart';

final allCvStyles = <CvStyle>[
  ClassicStyle(),
  ClassicCompactStyle(),
  ModernStyle(),
  ModernDarkStyle(),
  MinimalStyle(),
];

final styleProvider = StateNotifierProvider<StyleNotifier, CvStyle>((ref) {
  return StyleNotifier();
});

class StyleNotifier extends StateNotifier<CvStyle> {
  StyleNotifier() : super(ClassicStyle());

  void setStyle(CvStyle style) => state = style;
}
