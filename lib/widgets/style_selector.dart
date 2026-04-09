import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/style_viewmodel.dart';
import '../views/pdf_preview_page.dart';
import 'style_picker_sheet.dart';

class StyleSelector extends ConsumerWidget {
  const StyleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStyle = ref.watch(styleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          // Style picker trigger — pill button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => showStylePicker(context),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: currentStyle.swatchColor.withValues(alpha: 0.10),
                  border: Border.all(
                    color: currentStyle.swatchColor.withValues(alpha: 0.7),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.palette_outlined, size: 16, color: currentStyle.swatchColor),
                    const SizedBox(width: 6),
                    Text(
                      currentStyle.name,
                      style: TextStyle(
                        color: currentStyle.swatchColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: currentStyle.swatchColor),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // PDF export — right side
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PdfPreviewPage()),
            ),
            icon: const Icon(Icons.picture_as_pdf, size: 18),
            label: const Text('PDF', style: TextStyle(fontSize: 13)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
