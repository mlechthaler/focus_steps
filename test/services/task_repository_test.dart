import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/task.dart';
import 'package:focus_steps/services/task_repository.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('can be instantiated', () {
      expect(repository, isNotNull);
    });

    test('getAllTasks returns empty list initially', () {
      final tasks = repository.getAllTasks();
      expect(tasks, isEmpty);
    });

    test('addTask adds a task to the repository', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        createdAt: DateTime.now(),
      );

      repository.addTask(task);
      final tasks = repository.getAllTasks();

      expect(tasks.length, equals(1));
      expect(tasks.first.id, equals('1'));
    });

    test('getTopProcrastinatedTasks returns tasks sorted by parkCount', () {
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        steps: [],
        parkCount: 5,
        createdAt: DateTime.now(),
      );
      final task2 = Task(
        id: '2',
        title: 'Task 2',
        steps: [],
        parkCount: 10,
        createdAt: DateTime.now(),
      );
      final task3 = Task(
        id: '3',
        title: 'Task 3',
        steps: [],
        parkCount: 3,
        createdAt: DateTime.now(),
      );

      repository.addTask(task1);
      repository.addTask(task2);
      repository.addTask(task3);

      final topTasks = repository.getTopProcrastinatedTasks(limit: 3);

      expect(topTasks.length, equals(3));
      expect(topTasks[0].id, equals('2')); // parkCount 10
      expect(topTasks[1].id, equals('1')); // parkCount 5
      expect(topTasks[2].id, equals('3')); // parkCount 3
    });

    test('getTopProcrastinatedTasks respects limit parameter', () {
      final task1 = Task(
        id: '1',
        title: 'Task 1',
        steps: [],
        parkCount: 5,
        createdAt: DateTime.now(),
      );
      final task2 = Task(
        id: '2',
        title: 'Task 2',
        steps: [],
        parkCount: 10,
        createdAt: DateTime.now(),
      );
      final task3 = Task(
        id: '3',
        title: 'Task 3',
        steps: [],
        parkCount: 3,
        createdAt: DateTime.now(),
      );

      repository.addTask(task1);
      repository.addTask(task2);
      repository.addTask(task3);

      final topTasks = repository.getTopProcrastinatedTasks(limit: 2);

      expect(topTasks.length, equals(2));
      expect(topTasks[0].id, equals('2'));
      expect(topTasks[1].id, equals('1'));
    });

    test('parkTask increments parkCount and updates lastParkedAt', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        parkCount: 0,
        createdAt: DateTime.now(),
      );

      repository.addTask(task);
      repository.parkTask('1');

      final updatedTask = repository.getTaskById('1');
      expect(updatedTask, isNotNull);
      expect(updatedTask!.parkCount, equals(1));
      expect(updatedTask.lastParkedAt, isNotNull);
    });

    test('parkTask can be called multiple times', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        parkCount: 0,
        createdAt: DateTime.now(),
      );

      repository.addTask(task);
      repository.parkTask('1');
      repository.parkTask('1');
      repository.parkTask('1');

      final updatedTask = repository.getTaskById('1');
      expect(updatedTask!.parkCount, equals(3));
    });

    test('updateTask updates existing task', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        createdAt: DateTime.now(),
      );

      repository.addTask(task);

      final updatedTask = task.copyWith(title: 'Updated Task');
      repository.updateTask(updatedTask);

      final retrievedTask = repository.getTaskById('1');
      expect(retrievedTask!.title, equals('Updated Task'));
    });

    test('getTaskById returns task with matching id', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        createdAt: DateTime.now(),
      );

      repository.addTask(task);

      final retrievedTask = repository.getTaskById('1');
      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, equals('1'));
    });

    test('getTaskById returns null for non-existent id', () {
      final retrievedTask = repository.getTaskById('non-existent');
      expect(retrievedTask, isNull);
    });

    test('removeTask removes task from repository', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        steps: [],
        createdAt: DateTime.now(),
      );

      repository.addTask(task);
      expect(repository.getAllTasks().length, equals(1));

      repository.removeTask('1');
      expect(repository.getAllTasks().isEmpty, isTrue);
    });

    test('addSampleTasks adds sample tasks', () {
      repository.addSampleTasks();
      
      final tasks = repository.getAllTasks();
      expect(tasks, isNotEmpty);
      
      // Verify that tasks have parkCount > 0
      final topTasks = repository.getTopProcrastinatedTasks();
      expect(topTasks, isNotEmpty);
      expect(topTasks.first.parkCount, greaterThan(0));
    });
  });
}
