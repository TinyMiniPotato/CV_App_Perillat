import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? url;

  /// When true, uses smaller icon/text suitable for sidebar layouts.
  final bool compact;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.url,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 16.0 : 20.0;
    final fontSize = compact ? 12.0 : 16.0;
    final verticalPad = compact ? 2.0 : 4.0;

    final content = Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPad),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Colors.grey),
          SizedBox(width: compact ? 8 : 12),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: url != null ? Theme.of(context).colorScheme.primary : null,
                decoration: url != null ? TextDecoration.underline : null,
              ),
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
