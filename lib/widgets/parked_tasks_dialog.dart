import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Dialog that asks user if they want to save parked tasks for tomorrow
class ParkedTasksDialog extends StatelessWidget {
  const ParkedTasksDialog({super.key});

  /// Show the parked tasks dialog
  static Future<bool?> show(BuildContext context) async {
    // First check if there are any parked tasks
    final storage = await StorageService.create();
    final parkedTasks = await storage.getParkedTasks();
    
    if (parkedTasks.isEmpty) {
      // No parked tasks, nothing to save
      return null;
    }

    if (!context.mounted) return null;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ParkedTasksDialog._internal(
        parkedTasksCount: parkedTasks.length,
      ),
    );
  }

  final int? _parkedTasksCount;

  const ParkedTasksDialog._internal({int? parkedTasksCount})
      : _parkedTasksCount = parkedTasksCount;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.nightlight_round, color: Colors.indigo),
          SizedBox(width: 12),
          Expanded(child: Text('Ende des Tages')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Du hast ${_parkedTasksCount ?? 0} geparkte ${(_parkedTasksCount ?? 0) == 1 ? 'Aufgabe' : 'Aufgaben'}.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Möchtest du die geparkten Aufgaben für morgen speichern?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Wenn du "Ja" wählst, bleiben die Aufgaben für morgen erhalten. '
            'Bei "Nein" werden sie gelöscht.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Nein, löschen',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Ja, speichern'),
        ),
      ],
    );
  }
}
