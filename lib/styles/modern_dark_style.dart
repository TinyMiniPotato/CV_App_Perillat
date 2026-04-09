import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../viewmodels/cv_viewmodel.dart';
import 'cv_style.dart';

const _kNavy = Color(0xFF1E2A3A);
const _kTeal = Color(0xFF26C6DA);
const _kPdfNavy = PdfColor.fromInt(0xFF1E2A3A);
const _kPdfTeal = PdfColor.fromInt(0xFF26C6DA);

class ModernDarkStyle extends CvStyle {
  @override
  String get id => 'modern_dark';

  @override
  String get name => 'Dark';

  @override
  Color get swatchColor => _kNavy;

  @override
  CvStyleTokens get tokens => const CvStyleTokens(
        primaryColor: _kTeal,
        pdfPrimaryColor: _kPdfTeal,
        sidebarColor: _kNavy,
        pdfSidebarColor: _kPdfNavy,
      );

  @override
  Widget buildFlutterView(BuildContext context) => const _ModernDarkView();

  @override
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format) async {
    final tr = AppLocalizations.of(context).translate;
    final imageBytes = await rootBundle.load('assets/images/profile.jpg');
    final profileImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final pageWidth = format.width;
    final pageHeight = format.height;
    final sidebarW = pageWidth * 0.34;
    final mainW = pageWidth - sidebarW;
    const sidePad = 16.0;
    const mainPad = 20.0;

    final sidebarContent = [
      pw.Center(
        child: pw.Container(
          width: 68,
          height: 68,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: _kPdfTeal, width: 2),
            image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              'Gaël PERILLAT PIRATOINE',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              tr('job_title'),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey400),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 12),
      pw.Divider(color: _kPdfTeal, thickness: 0.5),
      pw.SizedBox(height: 8),

      // Contact
      _pdfSidebarSection(tr('contact')),
      _pdfSidebarInfo('gaël.perillat@gmail.com'),
      _pdfSidebarInfo('+33 6 51 35 71 80'),
      _pdfSidebarInfo('Lyon, 69005'),
      _pdfSidebarInfo('github.com/TinyMiniPotato'),
      pw.SizedBox(height: 10),

      // Skills — dot ratings
      _pdfSidebarSection(tr('skills')),
      pw.SizedBox(height: 4),
      ...cvSkills.map(_pdfSkillDots),
    ];

    final mainContent = [
      _pdfMainSection(tr('experience')),
      ...cvExperiences.map((exp) => _pdfExperienceCard(
            title: tr(exp.titleKey),
            company: exp.company,
            period: resolvePeriod(exp.period, tr),
            description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
          )),
      pw.SizedBox(height: 10),
      _pdfMainSection(tr('education')),
      ...cvEducation.map((edu) => _pdfExperienceCard(
            title: tr(edu.titleKey),
            company: tr(edu.company),
            period: edu.period,
            description: '',
          )),
    ];

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (ctx) => pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: sidebarW,
              height: pageHeight,
              color: _kPdfNavy,
              padding: const pw.EdgeInsets.all(sidePad),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: sidebarContent,
              ),
            ),
            pw.Container(
              width: mainW,
              height: pageHeight,
              padding: const pw.EdgeInsets.all(mainPad),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: mainContent,
              ),
            ),
          ],
        ),
      ),
    );
    return doc.save();
  }

  // ── PDF helpers ────────────────────────────────────────────────

  pw.Widget _pdfSidebarSection(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: _kPdfTeal,
            letterSpacing: 1,
          ),
        ),
      );

  pw.Widget _pdfSidebarInfo(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey300)),
      );

  pw.Widget _pdfSkillDots(Skill skill) {
    final filled = (skill.level * 5).round();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              skill.label,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey300),
            ),
          ),
          pw.Row(
            children: List.generate(5, (i) => pw.Container(
                  width: 7,
                  height: 7,
                  margin: const pw.EdgeInsets.only(left: 2),
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: i < filled ? _kPdfTeal : const PdfColor(0, 0, 0, 0),
                    border: pw.Border.all(color: _kPdfTeal, width: 0.8),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfMainSection(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const pw.BoxDecoration(color: _kPdfTeal),
              child: pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      );

  pw.Widget _pdfExperienceCard({
    required String title,
    required String company,
    required String period,
    required String description,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 9),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(width: 3, color: _kPdfTeal, margin: const pw.EdgeInsets.only(right: 8)),
            pw.Expanded(
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
            ),
          ],
        ),
      );
}

// ── Flutter view ───────────────────────────────────────────────────────────────

class _ModernDarkView extends StatelessWidget {
  const _ModernDarkView();

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context).translate(key);

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sidebarWidth = constraints.maxWidth * 0.34;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Dark sidebar ─────────────────────────────────
                Container(
                  width: sidebarWidth,
                  color: _kNavy,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _kTeal, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 38,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Gaël PERILLAT PIRATOINE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr('job_title'),
                        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: _kTeal, thickness: 0.6),
                      const SizedBox(height: 8),

                      // Contact
                      _sidebarSection(tr('contact')),
                      const SizedBox(height: 6),
                      _sidebarInfo(Icons.email, 'gaël.perillat@gmail.com'),
                      _sidebarInfo(Icons.phone, '+33 6 51 35 71 80'),
                      _sidebarInfo(Icons.location_on, 'Lyon, 69005'),
                      _sidebarInfo(Icons.code, 'github.com/TinyMiniPotato'),
                      const SizedBox(height: 12),

                      // Skills — dot ratings
                      _sidebarSection(tr('skills')),
                      const SizedBox(height: 6),
                      ...cvSkills.map(_skillDotRow),
                    ],
                  ),
                ),

                // ── White main content ────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _mainSection(tr('experience')),
                        const SizedBox(height: 10),
                        ...List.generate(cvExperiences.length, (i) {
                          final exp = cvExperiences[i];
                          return _ExperienceCard(
                            index: i,
                            title: tr(exp.titleKey),
                            company: exp.company,
                            period: resolvePeriod(exp.period, tr),
                            description:
                                exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
                          );
                        }),
                        const SizedBox(height: 16),
                        _mainSection(tr('education')),
                        const SizedBox(height: 10),
                        ...List.generate(cvEducation.length, (i) {
                          final edu = cvEducation[i];
                          return _ExperienceCard(
                            index: cvExperiences.length + i,
                            title: tr(edu.titleKey),
                            company: tr(edu.company),
                            period: edu.period,
                            description: '',
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sidebarSection(String title) => Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _kTeal,
          letterSpacing: 1,
        ),
      );

  Widget _sidebarInfo(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white54),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ),
          ],
        ),
      );

  Widget _skillDotRow(Skill skill) {
    final filled = (skill.level * 5).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              skill.label,
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < filled ? Icons.circle : Icons.circle_outlined,
                size: 10,
                color: _kTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainSection(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: _kTeal,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ── Experience card with left accent border + expand/collapse ──────────────────

class _ExperienceCard extends ConsumerWidget {
  final int index;
  final String title;
  final String company;
  final String period;
  final String description;

  const _ExperienceCard({
    required this.index,
    required this.title,
    required this.company,
    required this.period,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(cvProvider).expandedEntries.contains(index);
    final hasDescription = description.isNotEmpty;

    return GestureDetector(
      onTap: hasDescription ? () => ref.read(cvProvider.notifier).toggleEntry(index) : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 3, color: _kTeal, margin: const EdgeInsets.only(right: 10, top: 2)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      if (hasDescription)
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(company, style: const TextStyle(fontSize: 12, color: _kTeal)),
                  Text(period, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: description
                                  .split('•')
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .map((s) => Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('• ',
                                                style: TextStyle(fontSize: 13, color: _kTeal)),
                                            Expanded(
                                              child: Text(s,
                                                  style: const TextStyle(
                                                      fontSize: 13, height: 1.4)),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
