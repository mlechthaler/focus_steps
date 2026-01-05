import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/task.dart';
import 'package:focus_steps/services/task_repository.dart';
import 'package:focus_steps/widgets/procrastinated_tasks_widget.dart';

void main() {
  group('ProcrastinatedTasksWidget', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('displays empty state when no tasks exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProcrastinatedTasksWidget(taskRepository: repository),
          ),
        ),
      );

      expect(find.text('Keine aufgeschobenen Aufgaben'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays top 3 procrastinated tasks', (WidgetTester tester) async {
      // Add tasks with different park counts
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Step 1',
            description: 'Description',
            estimatedMinutes: 5,
          ),
        ],
        parkCount: 10,
        createdAt: DateTime.now(),
      );
      final task2 = Task(
        id: '2',
        title: 'Task 2',
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Step 1',
            description: 'Description',
            estimatedMinutes: 5,
          ),
        ],
        parkCount: 5,
        createdAt: DateTime.now(),
      );
      final task3 = Task(
        id: '3',
        title: 'Task 3',
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Step 1',
            description: 'Description',
            estimatedMinutes: 5,
          ),
        ],
        parkCount: 3,
        createdAt: DateTime.now(),
      );

      repository.addTask(task1);
      repository.addTask(task2);
      repository.addTask(task3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProcrastinatedTasksWidget(taskRepository: repository),
          ),
        ),
      );

      // Check that all three tasks are displayed
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 3'), findsOneWidget);

      // Check that park counts are displayed
      expect(find.text('10× geparkt'), findsOneWidget);
      expect(find.text('5× geparkt'), findsOneWidget);
      expect(find.text('3× geparkt'), findsOneWidget);
    });

    testWidgets('displays motivational text', (WidgetTester tester) async {
      repository.addTask(
        Task(
          id: '1',
          title: 'Test Task',
          steps: [],
          parkCount: 1,
          createdAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProcrastinatedTasksWidget(taskRepository: repository),
          ),
        ),
      );

      expect(
        find.text('Nur 2 Minuten? Fangen wir mit einem kleinen Schritt an'),
        findsOneWidget,
      );
      expect(
        find.text('Meist aufgeschobene Aufgaben'),
        findsOneWidget,
      );
    });

    testWidgets('displays correct number of steps for each task', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Step 1',
            description: 'Description',
            estimatedMinutes: 5,
          ),
          MicroStep(
            stepNumber: 2,
            title: 'Step 2',
            description: 'Description',
            estimatedMinutes: 5,
          ),
          MicroStep(
            stepNumber: 3,
            title: 'Step 3',
            description: 'Description',
            estimatedMinutes: 5,
          ),
        ],
        parkCount: 1,
        createdAt: DateTime.now(),
      );

      repository.addTask(task);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProcrastinatedTasksWidget(taskRepository: repository),
          ),
        ),
      );

      expect(find.text('3 Schritte'), findsOneWidget);
    });

    testWidgets('tapping on task navigates to FocusView', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Step 1',
            description: 'Description',
            estimatedMinutes: 5,
          ),
        ],
        parkCount: 1,
        createdAt: DateTime.now(),
      );

      repository.addTask(task);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProcrastinatedTasksWidget(taskRepository: repository),
          ),
        ),
      );

      // Tap on the task
      await tester.tap(find.text('Test Task'));
      await tester.pumpAndSettle();

      // Verify that FocusView is opened
      expect(find.text('Fokus-Modus'), findsOneWidget);
    });
  });
}
