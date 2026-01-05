import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/task.dart';

void main() {
  group('Task', () {
    test('can be instantiated with required parameters', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        createdAt: DateTime.now(),
      );
      expect(task, isNotNull);
      expect(task.id, equals('1'));
      expect(task.title, equals('Test Task'));
      expect(task.parkCount, equals(0));
    });

    test('can be instantiated with parkCount', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        parkCount: 5,
        createdAt: DateTime.now(),
      );
      expect(task.parkCount, equals(5));
    });

    test('copyWith creates new instance with updated values', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        parkCount: 5,
        createdAt: DateTime.now(),
      );

      final updatedTask = task.copyWith(parkCount: 10);
      
      expect(updatedTask.id, equals(task.id));
      expect(updatedTask.title, equals(task.title));
      expect(updatedTask.parkCount, equals(10));
    });

    test('toJson and fromJson work correctly', () {
      final now = DateTime.now();
      final step = MicroStep(
        stepNumber: 1,
        title: 'Step 1',
        description: 'Description',
        estimatedMinutes: 5,
      );
      
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [step],
        parkCount: 3,
        createdAt: now,
      );

      final json = task.toJson();
      final restoredTask = Task.fromJson(json);

      expect(restoredTask.id, equals(task.id));
      expect(restoredTask.title, equals(task.title));
      expect(restoredTask.parkCount, equals(task.parkCount));
      expect(restoredTask.steps.length, equals(1));
    });
  });

  group('MicroStep', () {
    test('can be instantiated with required parameters', () {
      final step = MicroStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
      );
      
      expect(step, isNotNull);
      expect(step.stepNumber, equals(1));
      expect(step.title, equals('Test Step'));
      expect(step.isCompleted, equals(false));
    });

    test('can be instantiated with isCompleted', () {
      final step = MicroStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
        isCompleted: true,
      );
      
      expect(step.isCompleted, equals(true));
    });

    test('copyWith creates new instance with updated values', () {
      final step = MicroStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
        isCompleted: false,
      );

      final updatedStep = step.copyWith(isCompleted: true);
      
      expect(updatedStep.stepNumber, equals(step.stepNumber));
      expect(updatedStep.title, equals(step.title));
      expect(updatedStep.isCompleted, equals(true));
    });

    test('toJson and fromJson work correctly', () {
      final step = MicroStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
        isCompleted: true,
      );

      final json = step.toJson();
      final restoredStep = MicroStep.fromJson(json);

      expect(restoredStep.stepNumber, equals(step.stepNumber));
      expect(restoredStep.title, equals(step.title));
      expect(restoredStep.description, equals(step.description));
      expect(restoredStep.estimatedMinutes, equals(step.estimatedMinutes));
      expect(restoredStep.isCompleted, equals(step.isCompleted));
    });
  });
}
