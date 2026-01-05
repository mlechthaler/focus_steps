import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_steps/models/task.dart';
import 'package:focus_steps/providers/tasks_provider.dart';

void main() {
  group('TasksNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with empty list', () {
      final tasks = container.read(currentTasksProvider);
      expect(tasks, isEmpty);
    });

    test('addTask adds a task to the list', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task = Task.forInbox('Test Task', '1');

      notifier.addTask(task);

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(1));
      expect(tasks[0].title, equals('Test Task'));
    });

    test('addTaskAsNext adds a task at the beginning', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task1 = Task.forInbox('Task 1', '1');
      final task2 = Task.forInbox('Task 2', '2');

      notifier.addTask(task1);
      notifier.addTaskAsNext(task2);

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(2));
      expect(tasks[0].title, equals('Task 2'));
      expect(tasks[1].title, equals('Task 1'));
    });

    test('addTasks adds multiple tasks to the list', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final taskList = [
        Task.forInbox('Task 1', '1'),
        Task.forInbox('Task 2', '2'),
      ];

      notifier.addTasks(taskList);

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(2));
    });

    test('addTasksAsNext adds multiple tasks at the beginning', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task1 = Task.forInbox('Task 1', '1');
      final taskList = [
        Task.forInbox('Task 2', '2'),
        Task.forInbox('Task 3', '3'),
      ];

      notifier.addTask(task1);
      notifier.addTasksAsNext(taskList);

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(3));
      expect(tasks[0].title, equals('Task 2'));
      expect(tasks[1].title, equals('Task 3'));
      expect(tasks[2].title, equals('Task 1'));
    });

    test('removeTask removes a task by ID', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task1 = Task.forInbox('Task 1', '1');
      final task2 = Task.forInbox('Task 2', '2');

      notifier.addTask(task1);
      notifier.addTask(task2);

      notifier.removeTask('1');

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(1));
      expect(tasks[0].id, equals('2'));
    });

    test('updateTask updates an existing task', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task = Task.forInbox('Task 1', '1');

      notifier.addTask(task);

      final updatedTask = task.copyWith(title: 'Updated Task');
      notifier.updateTask(updatedTask);

      final tasks = container.read(currentTasksProvider);
      expect(tasks.length, equals(1));
      expect(tasks[0].title, equals('Updated Task'));
    });

    test('clear removes all tasks', () {
      final notifier = container.read(currentTasksProvider.notifier);
      final task1 = Task.forInbox('Task 1', '1');
      final task2 = Task.forInbox('Task 2', '2');

      notifier.addTask(task1);
      notifier.addTask(task2);

      notifier.clear();

      final tasks = container.read(currentTasksProvider);
      expect(tasks, isEmpty);
    });
  });

  group('Inbox provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with empty list', () {
      final tasks = container.read(inboxTasksProvider);
      expect(tasks, isEmpty);
    });

    test('works independently from currentTasksProvider', () {
      final currentNotifier = container.read(currentTasksProvider.notifier);
      final inboxNotifier = container.read(inboxTasksProvider.notifier);

      final task1 = Task.forInbox('Current Task', '1');
      final task2 = Task.forInbox('Inbox Task', '2');

      currentNotifier.addTask(task1);
      inboxNotifier.addTask(task2);

      final currentTasks = container.read(currentTasksProvider);
      final inboxTasks = container.read(inboxTasksProvider);

      expect(currentTasks.length, equals(1));
      expect(inboxTasks.length, equals(1));
      expect(currentTasks[0].title, equals('Current Task'));
      expect(inboxTasks[0].title, equals('Inbox Task'));
    });
  });
}
