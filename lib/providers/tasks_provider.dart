import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/api_service.dart';

/// Provider for the ApiService instance
/// In production, the API key should come from secure storage or environment
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    apiKey: const String.fromEnvironment(
      'OPENAI_API_KEY',
      defaultValue: '',
    ),
  );
});

/// Provider for the current tasks list (tasks that are being worked on)
final currentTasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

/// Provider for the inbox tasks list (tasks saved for later)
final inboxTasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

/// State notifier for managing a list of tasks
class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([]);

  /// Add a task to the list
  void addTask(Task task) {
    state = [...state, task];
  }

  /// Add a task as the next task (insert at the beginning)
  void addTaskAsNext(Task task) {
    state = [task, ...state];
  }

  /// Add multiple tasks (e.g., from breaking down a task)
  void addTasks(List<Task> tasks) {
    state = [...state, ...tasks];
  }

  /// Add multiple tasks at the beginning (insert as next tasks)
  void addTasksAsNext(List<Task> tasks) {
    state = [...tasks, ...state];
  }

  /// Remove a task by ID
  void removeTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  /// Update a task
  void updateTask(Task updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  /// Clear all tasks
  void clear() {
    state = [];
  }
}
