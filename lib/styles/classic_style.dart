import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../widgets/info_row.dart';
import '../widgets/skill_bar.dart';
import '../widgets/timeline_entry.dart';
import 'cv_style.dart';

class ClassicStyle extends CvStyle {
  @override
  String get id => 'classic';

  @override
  String get name => 'Classic';

  @override
  Color get swatchColor => const Color(0xFF1976D2);

  @override
  CvStyleTokens get tokens => const CvStyleTokens(
        primaryColor: Color(0xFF1976D2),
        pdfPrimaryColor: PdfColors.blue700,
      );

  @override
  Widget buildFlutterView(BuildContext context) => const _ClassicView();

  @override
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format) async {
    final tr = AppLocalizations.of(context).translate;
    final imageBytes = await rootBundle.load('assets/images/profile.jpg');
    final profileImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
        build: (ctx) => [
          // ── Header ──────────────────────────────────────────────
          pw.Center(
            child: pw.Column(
              children: [
                pw.Container(
                  width: 72,
                  height: 72,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    image: pw.DecorationImage(
                      image: profileImage,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Gaël PERILLAT PIRATOINE',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  tr('job_title'),
                  style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 10),

          // ── Contact ─────────────────────────────────────────────
          _section(tr('contact')),
          _infoLine('gaël.perillat@gmail.com'),
          _infoLine('+33 6 51 35 71 80'),
          _infoLine('102 Quai Pierre Scize, 69005 Lyon'),
          _infoLine('github.com/TinyMiniPotato'),
          pw.SizedBox(height: 12),

          // ── Skills ──────────────────────────────────────────────
          _section(tr('skills')),
          ...cvSkills.map(_skillBar),
          pw.SizedBox(height: 12),

          // ── Experience ──────────────────────────────────────────
          _section(tr('experience')),
          ...cvExperiences.map((exp) => _experienceBlock(
                title: tr(exp.titleKey),
                company: exp.company,
                period: resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
              )),
          pw.SizedBox(height: 12),

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
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          children: [
            pw.Container(width: 3, height: 14, color: PdfColors.blue700),
            pw.SizedBox(width: 6),
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      );

  pw.Widget _infoLine(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
      );

  pw.Widget _skillBar(Skill skill) {
    final filled = (skill.level * 100).round();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(skill.label, style: const pw.TextStyle(fontSize: 9)),
              pw.Text(
                '$filled%',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            children: [
              pw.Expanded(
                flex: filled,
                child: pw.Container(
                  height: 5,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue700,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 100 - filled,
                child: pw.Container(
                  height: 5,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _experienceBlock({
    required String title,
    required String company,
    required String period,
    required String description,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 9),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text(company, style: const pw.TextStyle(fontSize: 9, color: PdfColors.blue700)),
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

class _ClassicView extends StatelessWidget {
  const _ClassicView();

  static const _color = Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context).translate(key);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gaël PERILLAT PIRATOINE',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('job_title'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact
            _sectionTitle(tr('contact'), Icons.contact_mail),
            const SizedBox(height: 12),
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
            const SizedBox(height: 24),

            // Skills
            _sectionTitle(tr('skills'), Icons.star),
            const SizedBox(height: 12),
            ...cvSkills.map((s) => SkillBar(skill: s)),
            const SizedBox(height: 24),

            // Experience
            _sectionTitle(tr('experience'), Icons.work),
            const SizedBox(height: 12),
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
            const SizedBox(height: 24),

            // Education
            _sectionTitle(tr('education'), Icons.school),
            const SizedBox(height: 12),
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

  Widget _sectionTitle(String title, IconData icon) => Row(
        children: [
          Icon(icon, color: _color),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      );
}
