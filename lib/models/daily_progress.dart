/// Represents daily progress statistics
class DailyProgress {
  final DateTime date;
  final int completedTasksCount;
  final int totalEstimatedMinutes;

  DailyProgress({
    required this.date,
    required this.completedTasksCount,
    required this.totalEstimatedMinutes,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'completedTasksCount': completedTasksCount,
      'totalEstimatedMinutes': totalEstimatedMinutes,
    };
  }

  /// Create from JSON
  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      date: DateTime.parse(json['date'] as String),
      completedTasksCount: json['completedTasksCount'] as int,
      totalEstimatedMinutes: json['totalEstimatedMinutes'] as int,
    );
  }

  /// Create empty progress for today
  factory DailyProgress.today() {
    final now = DateTime.now();
    return DailyProgress(
      date: DateTime(now.year, now.month, now.day),
      completedTasksCount: 0,
      totalEstimatedMinutes: 0,
    );
  }
}
