import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/main.dart';

void main() {
  group('MyHomePage', () {
    testWidgets('displays title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Focus Steps'), findsOneWidget);
      expect(find.text('Focus Steps - ADHD Task Breakdown'), findsOneWidget);
    });

    testWidgets('does not show inbox button when no items', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byIcon(Icons.inbox), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
