import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/task.dart';

void main() {
  group('Task', () {
    test('can be created with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 10,
        createdAt: DateTime.now(),
      );
      
      expect(task.id, equals('1'));
      expect(task.title, equals('Test Task'));
      expect(task.estimatedMinutes, equals(10));
      expect(task.status, equals(TaskStatus.pending));
    });

    test('can be created with all fields', () {
      final now = DateTime.now();
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        estimatedMinutes: 10,
        status: TaskStatus.completed,
        createdAt: now,
        completedAt: now,
      );
      
      expect(task.description, equals('Test Description'));
      expect(task.status, equals(TaskStatus.completed));
      expect(task.completedAt, equals(now));
    });

    test('copyWith creates a new instance with updated fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        estimatedMinutes: 10,
        createdAt: DateTime.now(),
      );
      
      final updatedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
      );
      
      expect(updatedTask.id, equals(task.id));
      expect(updatedTask.title, equals(task.title));
      expect(updatedTask.status, equals(TaskStatus.completed));
      expect(updatedTask.completedAt, isNotNull);
    });

    test('toJson and fromJson work correctly', () {
      final now = DateTime.now();
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        estimatedMinutes: 10,
        status: TaskStatus.completed,
        createdAt: now,
        completedAt: now,
      );
      
      final json = task.toJson();
      final restoredTask = Task.fromJson(json);
      
      expect(restoredTask.id, equals(task.id));
      expect(restoredTask.title, equals(task.title));
      expect(restoredTask.description, equals(task.description));
      expect(restoredTask.estimatedMinutes, equals(task.estimatedMinutes));
      expect(restoredTask.status, equals(task.status));
    });

    test('supports all task statuses', () {
      expect(TaskStatus.pending, isNotNull);
      expect(TaskStatus.inProgress, isNotNull);
      expect(TaskStatus.completed, isNotNull);
      expect(TaskStatus.parked, isNotNull);
    });
  });
}
