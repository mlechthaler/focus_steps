import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/daily_progress.dart';

/// Service for persisting tasks and daily progress locally
class StorageService {
  static const String _tasksKey = 'focus_steps_tasks';
  static const String _dailyProgressKey = 'focus_steps_daily_progress';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Create a new instance of StorageService
  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Save tasks to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    final jsonList = tasks.map((task) => task.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_tasksKey, jsonString);
  }

  /// Load tasks from local storage
  Future<List<Task>> loadTasks() async {
    final jsonString = _prefs.getString(_tasksKey);
    if (jsonString == null) {
      return [];
    }
    
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Save daily progress
  Future<void> saveDailyProgress(DailyProgress progress) async {
    final json = progress.toJson();
    final jsonString = jsonEncode(json);
    await _prefs.setString(_dailyProgressKey, jsonString);
  }

  /// Load daily progress
  Future<DailyProgress?> loadDailyProgress() async {
    final jsonString = _prefs.getString(_dailyProgressKey);
    if (jsonString == null) {
      return null;
    }
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return DailyProgress.fromJson(json);
  }

  /// Get completed tasks for today
  Future<int> getCompletedTasksToday() async {
    final tasks = await loadTasks();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return tasks.where((task) {
      if (task.status != TaskStatus.completed || task.completedAt == null) {
        return false;
      }
      final completedDate = task.completedAt!;
      final completedDay = DateTime(
        completedDate.year,
        completedDate.month,
        completedDate.day,
      );
      return completedDay == today;
    }).length;
  }

  /// Get parked tasks
  Future<List<Task>> getParkedTasks() async {
    final tasks = await loadTasks();
    return tasks.where((task) => task.status == TaskStatus.parked).toList();
  }

  /// Clear parked tasks
  Future<void> clearParkedTasks() async {
    final tasks = await loadTasks();
    final nonParkedTasks = tasks
        .where((task) => task.status != TaskStatus.parked)
        .toList();
    await saveTasks(nonParkedTasks);
  }
}
