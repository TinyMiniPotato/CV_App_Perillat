import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_app/widgets/timeline_entry.dart';

Widget buildEntry({
  int index = 0,
  String description = 'Task A • Task B • Task C',
}) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TimelineEntry(
            index: index,
            title: 'Developer',
            company: 'Acme Corp',
            period: '2020 - 2023',
            description: description,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('TimelineEntry', () {
    testWidgets('shows title, company and period', (tester) async {
      await tester.pumpWidget(buildEntry());
      expect(find.text('Developer'), findsOneWidget);
      expect(find.text('Acme Corp'), findsOneWidget);
      expect(find.text('2020 - 2023'), findsOneWidget);
    });

    testWidgets('description is hidden by default', (tester) async {
      await tester.pumpWidget(buildEntry());
      expect(find.text('Task A'), findsNothing);
      expect(find.text('Task B'), findsNothing);
    });

    testWidgets('tap expands and shows description items', (tester) async {
      await tester.pumpWidget(buildEntry());
      await tester.tap(find.text('Developer'));
      await tester.pumpAndSettle();
      expect(find.text('Task A'), findsOneWidget);
      expect(find.text('Task B'), findsOneWidget);
      expect(find.text('Task C'), findsOneWidget);
    });

    testWidgets('description splits on • into separate lines', (tester) async {
      await tester.pumpWidget(buildEntry(description: 'A • B • C'));
      await tester.tap(find.text('Developer'));
      await tester.pumpAndSettle();
      // Each item is a separate Text widget, not one combined string
      expect(find.text('A • B • C'), findsNothing);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('tap again collapses the description', (tester) async {
      await tester.pumpWidget(buildEntry());
      await tester.tap(find.text('Developer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Developer'));
      await tester.pumpAndSettle();
      expect(find.text('Task A'), findsNothing);
    });

    testWidgets('entry with empty description has no expand icon', (tester) async {
      await tester.pumpWidget(buildEntry(description: ''));
      expect(find.byIcon(Icons.expand_more), findsNothing);
    });
  });
}
