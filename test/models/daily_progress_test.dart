import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/models/daily_progress.dart';

void main() {
  group('DailyProgress', () {
    test('can be created with required fields', () {
      final date = DateTime.now();
      final progress = DailyProgress(
        date: date,
        completedTasksCount: 5,
        totalEstimatedMinutes: 50,
      );
      
      expect(progress.date, equals(date));
      expect(progress.completedTasksCount, equals(5));
      expect(progress.totalEstimatedMinutes, equals(50));
    });

    test('factory today creates progress for current day', () {
      final progress = DailyProgress.today();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      expect(progress.date, equals(today));
      expect(progress.completedTasksCount, equals(0));
      expect(progress.totalEstimatedMinutes, equals(0));
    });

    test('toJson and fromJson work correctly', () {
      final date = DateTime(2024, 1, 15);
      final progress = DailyProgress(
        date: date,
        completedTasksCount: 5,
        totalEstimatedMinutes: 50,
      );
      
      final json = progress.toJson();
      final restoredProgress = DailyProgress.fromJson(json);
      
      expect(restoredProgress.date, equals(progress.date));
      expect(
        restoredProgress.completedTasksCount,
        equals(progress.completedTasksCount),
      );
      expect(
        restoredProgress.totalEstimatedMinutes,
        equals(progress.totalEstimatedMinutes),
      );
    });
  });
}
