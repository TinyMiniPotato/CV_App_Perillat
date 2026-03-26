import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../widgets/info_row.dart';
import '../widgets/skill_bar.dart';
import '../widgets/timeline_entry.dart';

class CVTab extends ConsumerWidget {
  const CVTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String tr(String key) => AppLocalizations.of(context).translate(key);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gaël PERILLAT PIRATOINE',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('job_title'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact
            _buildSectionTitle(tr('contact'), Icons.contact_mail),
            const SizedBox(height: 12),
            const InfoRow(
              icon: Icons.email,
              text: 'gaël.perillat@gmail.com',
              url: 'mailto:gaël.perillat@gmail.com',
            ),
            const InfoRow(
              icon: Icons.phone,
              text: '+33 6 51 35 71 80',
              url: 'tel:+33651357180',
            ),
            const InfoRow(
              icon: Icons.location_on,
              text: '102 Quai Pierre Scize, 69005 Lyon',
            ),
            const InfoRow(
              icon: Icons.code,
              text: 'github.com/TinyMiniPotato',
              url: 'https://github.com/TinyMiniPotato',
            ),
            const SizedBox(height: 24),

            // Compétences
            _buildSectionTitle(tr('skills'), Icons.star),
            const SizedBox(height: 12),
            ...cvSkills.map((skill) => SkillBar(skill: skill)),
            const SizedBox(height: 24),

            // Expérience
            _buildSectionTitle(tr('experience'), Icons.work),
            const SizedBox(height: 12),
            ...List.generate(cvExperiences.length, (i) {
              final exp = cvExperiences[i];
              return TimelineEntry(
                index: i,
                title: tr(exp.titleKey),
                company: exp.company,
                period: _resolvePeriod(exp.period, tr),
                description: exp.descriptionKey.isNotEmpty ? tr(exp.descriptionKey) : '',
                isLast: i == cvExperiences.length - 1,
              );
            }),
            const SizedBox(height: 24),

            // Formation
            _buildSectionTitle(tr('education'), Icons.school),
            const SizedBox(height: 12),
            ...List.generate(cvEducation.length, (i) {
              final edu = cvEducation[i];
              final globalIndex = cvExperiences.length + i;
              return TimelineEntry(
                index: globalIndex,
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
    );
  }

  String _resolvePeriod(String period, String Function(String) tr) {
    if (period.contains(' ') || period.length <= 4) return period;
    final translated = tr(period);
    return translated != period ? translated : period;
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
