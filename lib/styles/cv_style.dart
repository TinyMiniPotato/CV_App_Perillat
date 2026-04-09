import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

/// Shared design tokens consumed by both Flutter and PDF renderers.
class CvStyleTokens {
  final Color primaryColor;
  final PdfColor pdfPrimaryColor;
  final Color? sidebarColor;
  final PdfColor? pdfSidebarColor;

  const CvStyleTokens({
    required this.primaryColor,
    required this.pdfPrimaryColor,
    this.sidebarColor,
    this.pdfSidebarColor,
  });
}

/// Resolves a period string that may be a translation key.
String resolvePeriod(String period, String Function(String) tr) {
  if (period.contains(' ') || period.length <= 4) return period;
  final translated = tr(period);
  return translated != period ? translated : period;
}

abstract class CvStyle {
  String get id;
  String get name;

  /// Color shown in the style selector card swatch.
  Color get swatchColor;

  CvStyleTokens get tokens;

  /// Returns the Flutter widget for this CV style.
  Widget buildFlutterView(BuildContext context);

  /// Renders this style to PDF bytes.
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format);
}
