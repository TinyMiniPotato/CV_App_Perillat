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

const _kIndigo = Color(0xFF3949AB);
const _kSidebar = Color(0xFFEEF0F8);
const _kPdfIndigo = PdfColors.indigo700;
const _kPdfSidebar = PdfColor.fromInt(0xFFEEF0F8);

class ModernStyle extends CvStyle {
  @override
  String get id => 'modern';

  @override
  String get name => 'Modern';

  @override
  Color get swatchColor => _kIndigo;

  @override
  CvStyleTokens get tokens => const CvStyleTokens(
        primaryColor: _kIndigo,
        pdfPrimaryColor: _kPdfIndigo,
        sidebarColor: _kSidebar,
        pdfSidebarColor: _kPdfSidebar,
      );

  @override
  Widget buildFlutterView(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _kIndigo),
        ),
        child: const _ModernView(),
      );

  @override
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format) async {
    final tr = AppLocalizations.of(context).translate;
    final imageBytes = await rootBundle.load('assets/images/profile.jpg');
    final profileImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final pageWidth = format.width;
    final pageHeight = format.height;
    final sidebarW = pageWidth * 0.34;
    final mainW = pageWidth - sidebarW;
    const pad = 18.0;

    // Build sidebar widgets
    final sidebarContent = [
      pw.Center(
        child: pw.Container(
          width: 70,
          height: 70,
          decoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
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
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _kPdfIndigo),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              tr('job_title'),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 12),
      pw.Divider(color: _kPdfIndigo, thickness: 0.5),
      pw.SizedBox(height: 8),
      _pdfSidebarSection(tr('contact')),
      _pdfSidebarInfo('gaël.perillat@gmail.com'),
      _pdfSidebarInfo('+33 6 51 35 71 80'),
      _pdfSidebarInfo('Lyon, 69005'),
      _pdfSidebarInfo('github.com/TinyMiniPotato'),
      pw.SizedBox(height: 10),
      _pdfSidebarSection(tr('skills')),
      pw.SizedBox(height: 4),
      pw.Wrap(
        spacing: 3,
        runSpacing: 3,
        children: cvSkills
            .map((s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const pw.BoxDecoration(
                    color: _kPdfIndigo,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Text(s.label,
                      style: const pw.TextStyle(fontSize: 7, color: PdfColors.white)),
                ))
            .toList(),
      ),
    ];

    // Build main content
    final mainContent = [
      _pdfMainSection(tr('experience')),
      ...cvExperiences.map((exp) => _pdfExperienceBlock(
            title: tr(exp.titleKey),
            company: exp.company,
            period: resolvePeriod(exp.period, tr),
            description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
          )),
      pw.SizedBox(height: 10),
      _pdfMainSection(tr('education')),
      ...cvEducation.map((edu) => _pdfExperienceBlock(
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
            // Sidebar
            pw.Container(
              width: sidebarW,
              height: pageHeight,
              color: _kPdfSidebar,
              padding: const pw.EdgeInsets.all(pad),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: sidebarContent,
              ),
            ),
            // Main
            pw.Container(
              width: mainW,
              height: pageHeight,
              padding: const pw.EdgeInsets.all(pad),
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
            color: _kPdfIndigo,
            letterSpacing: 1,
          ),
        ),
      );

  pw.Widget _pdfSidebarInfo(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
      );

  pw.Widget _pdfMainSection(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: _kPdfIndigo,
                letterSpacing: 0.8,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Divider(color: _kPdfIndigo, thickness: 0.5),
          ],
        ),
      );

  pw.Widget _pdfExperienceBlock({
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
            pw.Text(company, style: const pw.TextStyle(fontSize: 9, color: _kPdfIndigo)),
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

class _ModernView extends StatelessWidget {
  const _ModernView();

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context).translate(key);
    final color = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sidebarWidth = constraints.maxWidth * 0.34;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Sidebar ─────────────────────────────────────
                Container(
                  width: sidebarWidth,
                  color: _kSidebar,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/profile.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Gaël PERILLAT PIRATOINE',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr('job_title'),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Divider(color: color.withValues(alpha: 0.4)),
                      const SizedBox(height: 8),
                      _sidebarSection(tr('contact'), color),
                      const SizedBox(height: 6),
                      const InfoRow(
                        icon: Icons.email,
                        text: 'gaël.perillat@gmail.com',
                        url: 'mailto:gaël.perillat@gmail.com',
                        compact: true,
                      ),
                      const InfoRow(
                        icon: Icons.phone,
                        text: '+33 6 51 35 71 80',
                        url: 'tel:+33651357180',
                        compact: true,
                      ),
                      const InfoRow(
                        icon: Icons.location_on,
                        text: 'Lyon, 69005',
                        compact: true,
                      ),
                      const InfoRow(
                        icon: Icons.code,
                        text: 'github.com/TinyMiniPotato',
                        url: 'https://github.com/TinyMiniPotato',
                        compact: true,
                      ),
                      const SizedBox(height: 12),
                      _sidebarSection(tr('skills'), color),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: cvSkills
                            .map((s) => Chip(
                                  label: Text(s.label, style: const TextStyle(fontSize: 10)),
                                  backgroundColor: color,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // ── Main content ─────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _mainSection(tr('experience'), color),
                        const SizedBox(height: 10),
                        ...List.generate(cvExperiences.length, (i) {
                          final exp = cvExperiences[i];
                          return TimelineEntry(
                            index: i,
                            title: tr(exp.titleKey),
                            company: exp.company,
                            period: resolvePeriod(exp.period, tr),
                            description:
                                exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
                            isLast: i == cvExperiences.length - 1,
                          );
                        }),
                        const SizedBox(height: 20),
                        _mainSection(tr('education'), color),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sidebarSection(String title, Color color) => Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1,
        ),
      );

  Widget _mainSection(String title, Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Divider(color: color.withValues(alpha: 0.5), thickness: 0.8),
        ],
      );
}
