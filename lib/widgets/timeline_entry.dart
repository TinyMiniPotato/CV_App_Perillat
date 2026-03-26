import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/cv_viewmodel.dart';

class TimelineEntry extends ConsumerWidget {
  final int index;
  final String title;
  final String company;
  final String period;
  final String description;
  final bool isLast;

  const TimelineEntry({
    super.key,
    required this.index,
    required this.title,
    required this.company,
    required this.period,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(cvProvider).expandedEntries.contains(index);
    final hasDescription = description.isNotEmpty;
    final color = Theme.of(context).colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ligne verticale + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(width: 2, color: color.withValues(alpha: 0.3)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Contenu
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: hasDescription
                        ? () => ref.read(cvProvider.notifier).toggleEntry(index)
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                company,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                period,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasDescription)
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              description,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
