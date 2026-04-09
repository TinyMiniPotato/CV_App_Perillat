import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../viewmodels/cv_viewmodel.dart';
import 'cv_style.dart';

const _kCharcoal = Color(0xFF263238);
const _kPdfCharcoal = PdfColor.fromInt(0xFF263238);
const _kPdfAccent = PdfColor.fromInt(0xFF37474F);

class MinimalStyle extends CvStyle {
  @override
  String get id => 'minimal';

  @override
  String get name => 'Minimal';

  @override
  Color get swatchColor => _kCharcoal;

  @override
  CvStyleTokens get tokens => const CvStyleTokens(
        primaryColor: _kCharcoal,
        pdfPrimaryColor: _kPdfCharcoal,
      );

  @override
  Widget buildFlutterView(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _kCharcoal),
        ),
        child: const _MinimalView(),
      );

  @override
  Future<Uint8List> buildPdf(BuildContext context, PdfPageFormat format) async {
    final tr = AppLocalizations.of(context).translate;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        build: (ctx) => [
          // ── Header ──────────────────────────────────────────────
          pw.Text(
            'Gaël PERILLAT PIRATOINE',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: _kPdfCharcoal),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            tr('job_title'),
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'gaël.perillat@gmail.com  ·  +33 6 51 35 71 80  ·  Lyon  ·  github.com/TinyMiniPotato',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 12),
          pw.Divider(color: _kPdfCharcoal, thickness: 0.5),
          pw.SizedBox(height: 10),

          // ── Skills ──────────────────────────────────────────────
          _pdfSection(tr('skills')),
          pw.SizedBox(height: 4),
          pw.Text(
            cvSkills.map((s) => s.label).join('  ·  '),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 12),
          pw.Divider(color: PdfColors.grey300, thickness: 0.3),
          pw.SizedBox(height: 10),

          // ── Experience ──────────────────────────────────────────
          _pdfSection(tr('experience')),
          ...cvExperiences.map((exp) => _pdfExperienceBlock(
                title: tr(exp.titleKey),
                company: exp.company,
                period: resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
              )),
          pw.SizedBox(height: 10),
          pw.Divider(color: PdfColors.grey300, thickness: 0.3),
          pw.SizedBox(height: 10),

          // ── Education ───────────────────────────────────────────
          _pdfSection(tr('education')),
          ...cvEducation.map((edu) => _pdfExperienceBlock(
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

  pw.Widget _pdfSection(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          children: [
            pw.Container(width: 2, height: 12, color: _kPdfCharcoal),
            pw.SizedBox(width: 6),
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _kPdfCharcoal,
                letterSpacing: 1.5,
              ),
            ),
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
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text(period, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Text(company, style: const pw.TextStyle(fontSize: 9, color: _kPdfAccent)),
            if (description.isNotEmpty) ...[
              pw.SizedBox(height: 4),
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

class _MinimalView extends StatelessWidget {
  const _MinimalView();

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context).translate(key);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — left aligned, no photo
            const Text(
              'Gaël PERILLAT PIRATOINE',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _kCharcoal),
            ),
            const SizedBox(height: 6),
            Text(tr('job_title'), style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            // Contact inline
            const Wrap(
              spacing: 6,
              children: [
                Text('gaël.perillat@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('·', style: TextStyle(color: Colors.grey)),
                Text('+33 6 51 35 71 80', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('·', style: TextStyle(color: Colors.grey)),
                Text('Lyon', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('·', style: TextStyle(color: Colors.grey)),
                Text('github.com/TinyMiniPotato',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: _kCharcoal, thickness: 0.5),
            const SizedBox(height: 16),

            // Skills — comma-separated text
            _sectionTitle(tr('skills')),
            const SizedBox(height: 10),
            Text(
              cvSkills.map((s) => s.label).join('  ·  '),
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black12),
            const SizedBox(height: 16),

            // Experience
            _sectionTitle(tr('experience')),
            const SizedBox(height: 12),
            ...List.generate(cvExperiences.length, (i) {
              final exp = cvExperiences[i];
              return _MinimalExperienceBlock(
                index: i,
                title: tr(exp.titleKey),
                company: exp.company,
                period: resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
              );
            }),
            const SizedBox(height: 16),
            const Divider(color: Colors.black12),
            const SizedBox(height: 16),

            // Education
            _sectionTitle(tr('education')),
            const SizedBox(height: 12),
            ...List.generate(cvEducation.length, (i) {
              final edu = cvEducation[i];
              return _MinimalExperienceBlock(
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
    );
  }

  Widget _sectionTitle(String title) => Row(
        children: [
          Container(width: 3, height: 20, color: _kCharcoal),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _kCharcoal,
              letterSpacing: 1.5,
            ),
          ),
        ],
      );
}

// ── Minimal experience block with expand/collapse ─────────────────────────────

class _MinimalExperienceBlock extends ConsumerWidget {
  final int index;
  final String title;
  final String company;
  final String period;
  final String description;

  const _MinimalExperienceBlock({
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
      behavior: hasDescription ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      onTap: hasDescription ? () => ref.read(cvProvider.notifier).toggleEntry(index) : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (hasDescription) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(company, style: const TextStyle(fontSize: 13, color: _kCharcoal)),
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
                                          style: TextStyle(fontSize: 13, color: _kCharcoal)),
                                      Expanded(
                                        child: Text(s,
                                            style: const TextStyle(fontSize: 13, height: 1.4)),
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
    );
  }
}
