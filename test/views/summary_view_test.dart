import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/views/summary_view.dart';

void main() {
  group('SummaryView', () {
    testWidgets('displays title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SummaryView(),
        ),
      );

      // Wait for loading to complete
      await tester.pump();

      expect(find.text('Deine Erfolge heute'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SummaryView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('has an app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SummaryView(),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
