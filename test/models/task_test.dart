import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/task.dart';

void main() {
  group('TaskStep', () {
    test('can be created with required parameters', () {
      const step = TaskStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
      );

      expect(step.stepNumber, equals(1));
      expect(step.title, equals('Test Step'));
      expect(step.description, equals('Test Description'));
      expect(step.estimatedMinutes, equals(5));
      expect(step.isCompleted, isFalse);
    });

    test('can be created from JSON', () {
      final json = {
        'step_number': 1,
        'title': 'Test Step',
        'description': 'Test Description',
        'estimated_minutes': 5,
      };

      final step = TaskStep.fromJson(json);

      expect(step.stepNumber, equals(1));
      expect(step.title, equals('Test Step'));
      expect(step.description, equals('Test Description'));
      expect(step.estimatedMinutes, equals(5));
      expect(step.isCompleted, isFalse);
    });

    test('copyWith creates a new instance with updated values', () {
      const step = TaskStep(
        stepNumber: 1,
        title: 'Test Step',
        description: 'Test Description',
        estimatedMinutes: 5,
      );

      final updatedStep = step.copyWith(isCompleted: true);

      expect(updatedStep.stepNumber, equals(1));
      expect(updatedStep.title, equals('Test Step'));
      expect(updatedStep.isCompleted, isTrue);
    });
  });

  group('Task', () {
    test('can be created with required parameters', () {
      const task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        totalEstimatedMinutes: 0,
      );

      expect(task.id, equals('1'));
      expect(task.title, equals('Test Task'));
      expect(task.steps, isEmpty);
      expect(task.totalEstimatedMinutes, equals(0));
    });

    test('can be created from API response', () {
      final apiResponse = {
        'task': 'Test Task',
        'steps': [
          {
            'step_number': 1,
            'title': 'Step 1',
            'description': 'Description 1',
            'estimated_minutes': 5,
          },
          {
            'step_number': 2,
            'title': 'Step 2',
            'description': 'Description 2',
            'estimated_minutes': 10,
          },
        ],
        'total_steps': 2,
        'total_estimated_minutes': 15,
      };

      final task = Task.fromApiResponse(apiResponse, 'test-id');

      expect(task.id, equals('test-id'));
      expect(task.title, equals('Test Task'));
      expect(task.steps.length, equals(2));
      expect(task.steps[0].title, equals('Step 1'));
      expect(task.steps[1].title, equals('Step 2'));
      expect(task.totalEstimatedMinutes, equals(15));
    });

    test('can be created for inbox', () {
      final task = Task.forInbox('Test Task', 'inbox-id');

      expect(task.id, equals('inbox-id'));
      expect(task.title, equals('Test Task'));
      expect(task.steps, isEmpty);
      expect(task.totalEstimatedMinutes, equals(0));
    });

    test('copyWith creates a new instance with updated values', () {
      const task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        totalEstimatedMinutes: 0,
      );

      final updatedTask = task.copyWith(title: 'Updated Task');

      expect(updatedTask.id, equals('1'));
      expect(updatedTask.title, equals('Updated Task'));
      expect(updatedTask.steps, isEmpty);
    });
  });
}
