import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';

class PdfService {
  static Future<void> exportCv(BuildContext context) async {
    final tr = AppLocalizations.of(context).translate;
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'Gaël PERILLAT PIRATOINE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Développeur Mobile & Full-Stack',
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.SizedBox(height: 12),

          // Contact
          _buildSection(tr('contact')),
          pw.Text('gaël.perillat@gmail.com'),
          pw.Text('+33 6 51 35 71 80'),
          pw.Text('102 Quai Pierre Scize, 69005 Lyon'),
          pw.SizedBox(height: 16),

          // Skills
          _buildSection(tr('skills')),
          ...cvSkills.map((skill) => _buildSkillRow(skill)),
          pw.SizedBox(height: 16),

          // Experience
          _buildSection(tr('experience')),
          ...cvExperiences.map(
            (exp) => _buildExperienceBlock(
              title: tr(exp.titleKey),
              company: exp.company,
              period: _resolvePeriod(exp.period, tr),
              description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
            ),
          ),
          pw.SizedBox(height: 16),

          // Education
          _buildSection(tr('education')),
          ...cvEducation.map(
            (edu) => _buildExperienceBlock(
              title: tr(edu.titleKey),
              company: tr(edu.company),
              period: edu.period,
              description: '',
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'cv_gael_perillat.pdf',
    );
  }

  static String _resolvePeriod(String period, String Function(String) tr) {
    // period peut être une clé de traduction (ex: 'gca_period') ou une valeur directe
    if (period.contains(' ') || period.length <= 4) return period;
    final translated = tr(period);
    return translated != period ? translated : period;
  }

  static pw.Widget _buildSection(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget _buildSkillRow(Skill skill) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(skill.label, style: const pw.TextStyle(fontSize: 11)),
          ),
          pw.Expanded(
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: (skill.level * 100).round(),
                  child: pw.Container(
                    height: 6,
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blue,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 100 - (skill.level * 100).round(),
                  child: pw.Container(
                    height: 6,
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            '${(skill.level * 100).round()}%',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildExperienceBlock({
    required String title,
    required String company,
    required String period,
    required String description,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(company, style: const pw.TextStyle(fontSize: 11, color: PdfColors.blue700)),
          pw.Text(period, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          if (description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(description, style: const pw.TextStyle(fontSize: 10)),
          ],
        ],
      ),
    );
  }
}
