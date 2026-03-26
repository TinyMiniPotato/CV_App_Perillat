import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? url;

  const InfoRow({super.key, required this.icon, required this.text, this.url});

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: url != null ? Theme.of(context).colorScheme.primary : null,
              decoration: url != null ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );

    if (url == null) return content;

    return InkWell(
      onTap: () => launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication),
      borderRadius: BorderRadius.circular(4),
      child: content,
    );
  }
}
