import 'package:flutter/material.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String period;
  final String description;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.company,
    required this.period,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              company,
              style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(description),
            ],
          ],
        ),
      ),
    );
  }
}
