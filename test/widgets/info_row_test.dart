import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/widgets/info_row.dart';

void main() {
  Widget buildInfoRow({required String text, String? url}) {
    return MaterialApp(
      home: Scaffold(
        body: InfoRow(icon: Icons.email, text: text, url: url),
      ),
    );
  }

  group('InfoRow', () {
    testWidgets('displays the text', (tester) async {
      await tester.pumpWidget(buildInfoRow(text: 'test@example.com'));
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('without url — no InkWell', (tester) async {
      await tester.pumpWidget(buildInfoRow(text: 'Lyon'));
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('with url — InkWell is present', (tester) async {
      await tester.pumpWidget(
        buildInfoRow(text: 'github.com', url: 'https://github.com'),
      );
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('with url — text is underlined', (tester) async {
      await tester.pumpWidget(
        buildInfoRow(text: 'github.com', url: 'https://github.com'),
      );
      final textWidget = tester.widget<Text>(find.text('github.com'));
      expect(textWidget.style?.decoration, TextDecoration.underline);
    });
  });
}
