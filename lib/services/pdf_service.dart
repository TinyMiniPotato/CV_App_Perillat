import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

import '../styles/cv_style.dart';

class PdfService {
  static Future<Uint8List> buildPdf(
    BuildContext context,
    PdfPageFormat format,
    CvStyle style,
  ) {
    return style.buildPdf(context, format);
  }
}
