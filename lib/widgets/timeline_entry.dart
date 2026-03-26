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

    return Stack(
      children: [
        // Ligne verticale
        if (!isLast)
          Positioned(
            left: 5,
            top: 12,
            bottom: 0,
            width: 2,
            child: Container(color: color.withValues(alpha: 0.3)),
          ),

        // Contenu avec padding gauche pour laisser la place au dot + ligne
        Padding(
          padding: EdgeInsets.only(left: 24, bottom: isLast ? 0 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: hasDescription ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
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
                            style: TextStyle(fontSize: 14, color: color),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: description
                              .split('•')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ', style: TextStyle(fontSize: 14)),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 14, height: 1.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        // Dot
        Positioned(
          left: 0,
          top: 4,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
