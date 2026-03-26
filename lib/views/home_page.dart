import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../viewmodels/locale_viewmodel.dart';
import 'pdf_preview_page.dart';
import '../viewmodels/theme_viewmodel.dart';
import 'cv_tab.dart';
import 'widgets_tab.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);

    String tr(String key) => AppLocalizations.of(context).translate(key);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr('app_title')),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: tr('export_pdf'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PdfPreviewPage()),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                if (value == 'theme') {
                  ref.read(themeProvider.notifier).toggle();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      const SizedBox(width: 12),
                      Text(tr('dark_mode')),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: PopupMenuButton<String>(
                    offset: const Offset(-150, 0),
                    onSelected: (lang) {
                      ref.read(localeProvider.notifier).setLocale(Locale(lang));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 12),
                        Text(tr('language')),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'fr',
                        child: Row(
                          children: [
                            if (currentLocale.languageCode == 'fr') ...[
                              const Icon(Icons.check, size: 20, color: Colors.blue),
                              const SizedBox(width: 8),
                            ],
                            const Text('Français'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            if (currentLocale.languageCode == 'en') ...[
                              const Icon(Icons.check, size: 20, color: Colors.blue),
                              const SizedBox(width: 8),
                            ],
                            const Text('English'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [CVTab(), WidgetsTab()],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.person), text: tr('cv_tab')),
              Tab(icon: const Icon(Icons.widgets), text: tr('widgets_tab')),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicator: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue, width: 2)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          ),
        ),
      ),
    );
  }
}
