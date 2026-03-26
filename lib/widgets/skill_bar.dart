import 'package:flutter/material.dart';

import '../models/skill.dart';

class SkillBar extends StatelessWidget {
  final Skill skill;

  const SkillBar({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final percentage = '${(skill.level * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.label, style: const TextStyle(fontSize: 14)),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: skill.level),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ],
      ),
    );
  }
}
