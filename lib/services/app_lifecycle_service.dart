import 'package:flutter/material.dart';
import '../widgets/parked_tasks_dialog.dart';
import '../services/storage_service.dart';

/// Service for handling end-of-day logic and app lifecycle events
class AppLifecycleService with WidgetsBindingObserver {
  /// Hour threshold for considering it "evening" (18:00 = 6 PM)
  static const int eveningHourThreshold = 18;

  final BuildContext context;
  bool _hasShownDialog = false;
  DateTime? _lastCheckDate;

  AppLifecycleService(this.context) {
    WidgetsBinding.instance.addObserver(this);
    _lastCheckDate = DateTime.now();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.detached) {
      _checkAndShowParkedTasksDialog();
    } else if (state == AppLifecycleState.resumed) {
      _checkIfNewDay();
    }
  }

  /// Check if we should show the parked tasks dialog
  Future<void> _checkAndShowParkedTasksDialog() async {
    // Only show once per session
    if (_hasShownDialog) return;
    
    final now = DateTime.now();
    
    // Only show if it's evening or when app is closing
    final isEvening = now.hour >= eveningHourThreshold;
    
    if (isEvening) {
      _hasShownDialog = true;
      if (context.mounted) {
        final shouldSave = await ParkedTasksDialog.show(context);
        
        if (shouldSave == false) {
          // User chose not to save parked tasks
          final storage = await StorageService.create();
          await storage.clearParkedTasks();
        }
      }
    }
  }

  /// Check if it's a new day and reset dialog flag
  void _checkIfNewDay() {
    final now = DateTime.now();
    if (_lastCheckDate != null) {
      final lastDate = DateTime(
        _lastCheckDate!.year,
        _lastCheckDate!.month,
        _lastCheckDate!.day,
      );
      final currentDate = DateTime(now.year, now.month, now.day);
      
      if (currentDate.isAfter(lastDate)) {
        // It's a new day, reset the dialog flag
        _hasShownDialog = false;
        _lastCheckDate = now;
      }
    }
  }

  /// Manually trigger the end-of-day dialog (for testing or manual trigger)
  Future<void> showEndOfDayDialog() async {
    if (context.mounted) {
      final shouldSave = await ParkedTasksDialog.show(context);
      
      if (shouldSave == false) {
        final storage = await StorageService.create();
        await storage.clearParkedTasks();
      }
    }
  }
}
