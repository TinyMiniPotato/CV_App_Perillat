import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../services/pdf_service.dart';
import '../viewmodels/style_viewmodel.dart';

class PdfPreviewPage extends ConsumerWidget {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(styleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('CV — ${style.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share PDF',
            onPressed: () async {
              final bytes = await PdfService.buildPdf(context, PdfPageFormat.a4, style);
              await Printing.sharePdf(
                bytes: bytes,
                filename: 'cv_${style.id}.pdf',
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => PdfService.buildPdf(context, format, style),
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }
}
