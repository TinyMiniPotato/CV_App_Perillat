import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../widgets/info_row.dart';
import '../widgets/timeline_entry.dart';
import 'cv_style.dart';

const _kTeal = Color(0xFF00897B);
const _kPdfTeal = PdfColors.teal700;

class ClassicCompactStyle extends CvStyle {
  @override
  String get id => 'classic_compact';

  @override
  String get name => 'Compact';

  @override
  Color get swatchColor => _kTeal;

  @override
  CvStyleTokens get tokens => const CvStyleTokens(
        primaryColor: _kTeal,
        pdfPrimaryColor: _kPdfTeal,
      );

  @override
  Widget buildFlutterView(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _kTeal),
        ),
        child: const _CompactView(),
      );

  @override
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format) async {
    final tr = AppLocalizations.of(context).translate;
    final imageBytes = await rootBundle.load('assets/images/profile.jpg');
    final profileImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 28),
        build: (ctx) => [
          // ── Header ──────────────────────────────────────────────
          pw.Center(
            child: pw.Column(
              children: [
                pw.Container(
                  width: 56,
                  height: 56,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
                    border: pw.Border.all(color: _kPdfTeal, width: 2),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Gaël PERILLAT PIRATOINE',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  tr('job_title'),
                  style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: _kPdfTeal, thickness: 0.5),
          pw.SizedBox(height: 8),

          // ── Contact ─────────────────────────────────────────────
          _section(tr('contact')),
          _infoLine('gaël.perillat@gmail.com'),
          _infoLine('+33 6 51 35 71 80'),
          _infoLine('102 Quai Pierre Scize, 69005 Lyon'),
          _infoLine('github.com/TinyMiniPotato'),
          pw.SizedBox(height: 10),

          // ── Skills ──────────────────────────────────────────────
          _section(tr('skills')),
          pw.SizedBox(height: 4),
          pw.Wrap(
            spacing: 4,
            runSpacing: 4,
            children: cvSkills
                .map((s) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: _kPdfTeal, width: 0.6),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                      ),
                      child: pw.Text(
                        s.label,
                        style: const pw.TextStyle(fontSize: 8, color: _kPdfTeal),
                      ),
                    ))
                .toList(),
          ),
          pw.SizedBox(height: 10),

          // ── Experience ──────────────────────────────────────────
          _section(tr('experience')),
          ...cvExperiences.map((exp) => _experienceBlock(
                title: tr(exp.titleKey),
                company: exp.company,
                period: resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
              )),
          pw.SizedBox(height: 10),

          // ── Education ───────────────────────────────────────────
          _section(tr('education')),
          ...cvEducation.map((edu) => _experienceBlock(
                title: tr(edu.titleKey),
                company: tr(edu.company),
                period: edu.period,
                description: '',
              )),
        ],
      ),
    );
    return doc.save();
  }

  // ── PDF helpers ────────────────────────────────────────────────

  pw.Widget _section(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Row(
          children: [
            pw.Container(width: 3, height: 12, color: _kPdfTeal),
            pw.SizedBox(width: 6),
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      );

  pw.Widget _infoLine(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
      );

  pw.Widget _experienceBlock({
    required String title,
    required String company,
    required String period,
    required String description,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text(company, style: const pw.TextStyle(fontSize: 9, color: _kPdfTeal)),
            pw.Text(period, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            if (description.isNotEmpty) ...[
              pw.SizedBox(height: 3),
              ...description
                  .split('•')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .map((s) => pw.Bullet(text: s, style: const pw.TextStyle(fontSize: 8))),
            ],
          ],
        ),
      );
}

// ── Flutter view ───────────────────────────────────────────────────────────────

class _CompactView extends StatelessWidget {
  const _CompactView();

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context).translate(key);
    final color = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — smaller photo + teal border
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2.5),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Gaël PERILLAT PIRATOINE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(tr('job_title'), style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: color, thickness: 0.8),
            const SizedBox(height: 16),

            // Contact
            _sectionTitle(tr('contact'), color),
            const SizedBox(height: 10),
            const InfoRow(
              icon: Icons.email,
              text: 'gaël.perillat@gmail.com',
              url: 'mailto:gaël.perillat@gmail.com',
            ),
            const InfoRow(
              icon: Icons.phone,
              text: '+33 6 51 35 71 80',
              url: 'tel:+33651357180',
            ),
            const InfoRow(icon: Icons.location_on, text: '102 Quai Pierre Scize, 69005 Lyon'),
            const InfoRow(
              icon: Icons.code,
              text: 'github.com/TinyMiniPotato',
              url: 'https://github.com/TinyMiniPotato',
            ),
            const SizedBox(height: 20),

            // Skills — chips instead of bars
            _sectionTitle(tr('skills'), color),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: cvSkills
                  .map((s) => Chip(
                        label: Text(s.label, style: const TextStyle(fontSize: 11)),
                        backgroundColor: color.withValues(alpha: 0.08),
                        side: BorderSide(color: color.withValues(alpha: 0.6)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Experience
            _sectionTitle(tr('experience'), color),
            const SizedBox(height: 10),
            ...List.generate(cvExperiences.length, (i) {
              final exp = cvExperiences[i];
              return TimelineEntry(
                index: i,
                title: tr(exp.titleKey),
                company: exp.company,
                period: resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
                isLast: i == cvExperiences.length - 1,
              );
            }),
            const SizedBox(height: 20),

            // Education
            _sectionTitle(tr('education'), color),
            const SizedBox(height: 10),
            ...List.generate(cvEducation.length, (i) {
              final edu = cvEducation[i];
              return TimelineEntry(
                index: cvExperiences.length + i,
                title: tr(edu.titleKey),
                company: tr(edu.company),
                period: edu.period,
                description: '',
                isLast: i == cvEducation.length - 1,
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) => Row(
        children: [
          Container(width: 3, height: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ],
      );
}
