import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/main.dart';

void main() {
  group('MyHomePage Widget Tests', () {
    testWidgets('MyHomePage has a FloatingActionButton', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test'),
      ));

      // Verify that the FAB exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
      
      // Verify that the FAB has an add icon
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Tapping FAB opens BottomSheet', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test'),
      ));

      // Tap the FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that the BottomSheet is shown
      expect(find.text('Neue Hauptaufgabe'), findsOneWidget);
      expect(find.text('Aufgabentitel'), findsOneWidget);
      expect(find.text('Hinzufügen'), findsOneWidget);
    });

    testWidgets('BottomSheet has a TextField for task input', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test'),
      ));

      // Open the BottomSheet
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that there's a TextField
      expect(find.byType(TextField), findsOneWidget);
      
      // Enter text in the TextField
      await tester.enterText(find.byType(TextField), 'Test task');
      expect(find.text('Test task'), findsOneWidget);
    });

    testWidgets('Submitting task closes BottomSheet', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test'),
      ));

      // Open the BottomSheet
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter text and submit
      await tester.enterText(find.byType(TextField), 'Test task');
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();

      // Verify that the BottomSheet is closed
      expect(find.text('Neue Hauptaufgabe'), findsNothing);
    });

    testWidgets('Empty task cannot be submitted', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test'),
      ));

      // Open the BottomSheet
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to submit without entering text
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();

      // Verify that the BottomSheet is still open
      expect(find.text('Neue Hauptaufgabe'), findsOneWidget);
    });
  });

  group('AddTaskBottomSheet Widget Tests', () {
    testWidgets('AddTaskBottomSheet renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: AddTaskBottomSheet(),
        ),
      ));

      // Verify basic structure
      expect(find.text('Neue Hauptaufgabe'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Hinzufügen'), findsOneWidget);
    });
  });
}
