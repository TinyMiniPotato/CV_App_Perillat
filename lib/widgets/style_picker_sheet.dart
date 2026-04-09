import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles/cv_style.dart';
import '../viewmodels/style_viewmodel.dart';

/// Opens the style picker as a modal bottom sheet.
void showStylePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _StylePickerSheet(),
  );
}

class _StylePickerSheet extends ConsumerWidget {
  const _StylePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStyle = ref.watch(styleProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose a style',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // Grid of style cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: allCvStyles.length,
            itemBuilder: (context, i) {
              final style = allCvStyles[i];
              final isSelected = style.id == currentStyle.id;
              return _StyleCard(
                style: style,
                isSelected: isSelected,
                onTap: () {
                  ref.read(styleProvider.notifier).setStyle(style);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final CvStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleCard({required this.style, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? style.swatchColor.withValues(alpha: 0.06) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? style.swatchColor : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail area
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                child: StyleThumbnail(style: style),
              ),
            ),
            // Name bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: style.swatchColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    style.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? style.swatchColor : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, size: 16, color: style.swatchColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Style thumbnail dispatcher ─────────────────────────────────────────────────

class StyleThumbnail extends StatelessWidget {
  final CvStyle style;

  const StyleThumbnail({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return switch (style.id) {
      'classic' => _ClassicThumb(color: style.swatchColor),
      'classic_compact' => _CompactThumb(color: style.swatchColor),
      'modern' => _ModernThumb(color: style.swatchColor, sidebar: style.tokens.sidebarColor!),
      'modern_dark' => _DarkThumb(color: style.swatchColor, sidebar: style.tokens.sidebarColor!),
      'minimal' => _MinimalThumb(color: style.swatchColor),
      _ => const SizedBox.shrink(),
    };
  }
}

// ── Shared micro-widget helpers ────────────────────────────────────────────────

Widget _line(Color color, {double? width, double h = 4}) => Container(
      width: width,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );

Widget _circle(Color color, double size) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

Widget _dot(Color color) => Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: _circle(color, 5),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(Colors.black87, width: 52, h: 4),
                const SizedBox(height: 2),
                _line(const Color(0xFFBBBBBB), width: 36, h: 3),
              ],
            ),
          ),
        ],
      ),
    );

Widget _bar(Color color, double level) => Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Expanded(
            flex: (level * 100).round(),
            child: Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.horizontal(left: Radius.circular(2)))),
          ),
          Expanded(
            flex: 100 - (level * 100).round(),
            child: Container(height: 4, decoration: const BoxDecoration(color: Color(0xFFE8E8E8), borderRadius: BorderRadius.horizontal(right: Radius.circular(2)))),
          ),
        ],
      ),
    );

Widget _sectionHeader(Color color) => Row(
      children: [
        Container(width: 3, height: 10, color: color),
        const SizedBox(width: 4),
        _line(Colors.black87, width: 40, h: 4),
      ],
    );

Widget _chip(Color color, {bool filled = true}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.only(right: 3, bottom: 3),
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        border: filled ? null : Border.all(color: color, width: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(width: 12, height: 4, color: Colors.transparent),
    );

// ── Classic thumbnail ──────────────────────────────────────────────────────────

class _ClassicThumb extends StatelessWidget {
  final Color color;
  const _ClassicThumb({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _circle(color, 26),
          const SizedBox(height: 5),
          _line(Colors.black87, width: 64, h: 5),
          const SizedBox(height: 3),
          _line(const Color(0xFFAAAAAA), width: 44, h: 3),
          const SizedBox(height: 10),
          _sectionHeader(color),
          const SizedBox(height: 5),
          _bar(color, 0.92),
          _bar(color, 0.78),
          const SizedBox(height: 7),
          _sectionHeader(color),
          const SizedBox(height: 5),
          _dot(color),
          _dot(color),
        ],
      ),
    );
  }
}

// ── Compact thumbnail ─────────────────────────────────────────────────────────

class _CompactThumb extends StatelessWidget {
  final Color color;
  const _CompactThumb({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Smaller circle with colored border
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.25),
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(height: 5),
          _line(Colors.black87, width: 58, h: 5),
          const SizedBox(height: 3),
          _line(const Color(0xFFAAAAAA), width: 38, h: 3),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: color.withValues(alpha: 0.5)),
          ),
          // Compact section
          Row(children: [Container(width: 3, height: 10, color: color), const SizedBox(width: 4), _line(Colors.black87, width: 36, h: 4)]),
          const SizedBox(height: 6),
          // Chips instead of bars
          Wrap(
            children: [
              _chip(color, filled: false),
              _chip(color, filled: false),
              _chip(color, filled: false),
              _chip(color, filled: false),
            ],
          ),
          const SizedBox(height: 6),
          Row(children: [Container(width: 3, height: 10, color: color), const SizedBox(width: 4), _line(Colors.black87, width: 36, h: 4)]),
          const SizedBox(height: 5),
          _dot(color),
          _dot(color),
        ],
      ),
    );
  }
}

// ── Modern thumbnail ──────────────────────────────────────────────────────────

class _ModernThumb extends StatelessWidget {
  final Color color;
  final Color sidebar;
  const _ModernThumb({required this.color, required this.sidebar});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sidebar
        Expanded(
          flex: 35,
          child: Container(
            color: sidebar,
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(width: 24, height: 24, color: color.withValues(alpha: 0.35)),
                  ),
                ),
                const SizedBox(height: 5),
                _line(color, h: 4),
                const SizedBox(height: 2),
                _line(const Color(0xFFAAAAAA), h: 3),
                const SizedBox(height: 6),
                _line(color, h: 3),
                const SizedBox(height: 3),
                _line(const Color(0xFFCCCCCC), h: 2),
                const SizedBox(height: 1),
                _line(const Color(0xFFCCCCCC), h: 2),
                const SizedBox(height: 5),
                _line(color, h: 3),
                const SizedBox(height: 3),
                Wrap(children: [
                  _chip(color),
                  _chip(color),
                  _chip(color),
                ]),
              ],
            ),
          ),
        ),
        // Main
        Expanded(
          flex: 65,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(color, width: 40, h: 4),
                const SizedBox(height: 2),
                Divider(height: 4, thickness: 0.6, color: color.withValues(alpha: 0.5)),
                const SizedBox(height: 5),
                _dot(color),
                _dot(color),
                const SizedBox(height: 6),
                _line(color, width: 40, h: 4),
                const SizedBox(height: 2),
                Divider(height: 4, thickness: 0.6, color: color.withValues(alpha: 0.5)),
                const SizedBox(height: 5),
                _dot(color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Dark thumbnail ────────────────────────────────────────────────────────────

class _DarkThumb extends StatelessWidget {
  final Color color; // teal accent
  final Color sidebar; // navy

  const _DarkThumb({required this.color, required this.sidebar});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dark sidebar
        Expanded(
          flex: 35,
          child: Container(
            color: sidebar,
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sidebar.withValues(alpha: 0.5),
                      border: Border.all(color: color, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                _line(Colors.white, h: 4),
                const SizedBox(height: 2),
                _line(Colors.white54, h: 3),
                Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Divider(height: 1, color: color.withValues(alpha: 0.5))),
                _line(color, width: 28, h: 3),
                const SizedBox(height: 4),
                // Dot rating skills
                _darkDotRow(color, 5),
                _darkDotRow(color, 4),
                _darkDotRow(color, 3),
              ],
            ),
          ),
        ),
        // White main
        Expanded(
          flex: 65,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  color: color,
                  child: _line(Colors.white, width: 40, h: 4),
                ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardEntry(color),
                      _cardEntry(color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _darkDotRow(Color accent, int filled) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          children: [
            Expanded(child: _line(Colors.white38, h: 3)),
            const SizedBox(width: 3),
            Row(
              children: List.generate(
                5,
                (i) => Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < filled ? accent : Colors.transparent,
                    border: Border.all(color: accent, width: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _cardEntry(Color accent) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 2, height: 22, color: accent, margin: const EdgeInsets.only(right: 4, top: 1)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(Colors.black87, h: 4),
                  const SizedBox(height: 2),
                  _line(accent, width: 36, h: 3),
                ],
              ),
            ),
          ],
        ),
      );
}

// ── Minimal thumbnail ─────────────────────────────────────────────────────────

class _MinimalThumb extends StatelessWidget {
  final Color color;
  const _MinimalThumb({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bold name (no photo)
          _line(Colors.black87, h: 6),
          const SizedBox(height: 4),
          _line(Colors.black87, width: 80, h: 5),
          const SizedBox(height: 3),
          _line(const Color(0xFFAAAAAA), width: 60, h: 3),
          const SizedBox(height: 4),
          // Contact inline dots
          Row(
            children: [
              _line(const Color(0xFFCCCCCC), width: 30, h: 3),
              const SizedBox(width: 4),
              _circle(const Color(0xFFCCCCCC), 3),
              const SizedBox(width: 4),
              _line(const Color(0xFFCCCCCC), width: 22, h: 3),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, thickness: 0.8, color: color.withValues(alpha: 0.6)),
          ),
          // Section with left border
          Row(children: [Container(width: 3, height: 10, color: color), const SizedBox(width: 5), _line(Colors.black87, width: 36, h: 4)]),
          const SizedBox(height: 5),
          // Skills as text
          _line(const Color(0xFFAAAAAA), h: 3),
          const SizedBox(height: 3),
          _line(const Color(0xFFCCCCCC), width: 70, h: 3),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, thickness: 0.3, color: Color(0xFFDDDDDD)),
          ),
          // Section
          Row(children: [Container(width: 3, height: 10, color: color), const SizedBox(width: 5), _line(Colors.black87, width: 36, h: 4)]),
          const SizedBox(height: 5),
          // Experience as simple rows
          _minimalEntry(),
          _minimalEntry(),
        ],
      ),
    );
  }

  Widget _minimalEntry() => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _line(Colors.black87, width: 55, h: 4),
                _line(const Color(0xFFBBBBBB), width: 28, h: 3),
              ],
            ),
            const SizedBox(height: 2),
            _line(color, width: 40, h: 3),
          ],
        ),
      );
}
