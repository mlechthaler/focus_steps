import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/tasks_provider.dart';

/// BottomSheet for adding a new task with two options:
/// 1. Break down immediately and add to current tasks
/// 2. Save to inbox for later
class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  ConsumerState<AddTaskBottomSheet> createState() =>
      _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _taskController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _handleInsertImmediately() async {
    final taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte gib eine Aufgabe ein';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Break down the task using the API
      final apiService = ref.read(apiServiceProvider);
      final breakdown = await apiService.breakdownTask(taskTitle);

      // Create a task from the API response
      final taskId = DateTime.now().millisecondsSinceEpoch.toString();
      final task = Task.fromApiResponse(breakdown, taskId);

      // Add to current tasks as the next task
      ref.read(currentTasksProvider.notifier).addTaskAsNext(task);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Aufgabe in ${task.steps.length} Schritte zerlegt und eingefügt',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Zerlegen der Aufgabe: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSaveToInbox() async {
    final taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte gib eine Aufgabe ein';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create a simple task for the inbox
      final taskId = DateTime.now().millisecondsSinceEpoch.toString();
      final task = Task.forInbox(taskTitle, taskId);

      // Add to inbox
      ref.read(inboxTasksProvider.notifier).addTask(task);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aufgabe in Inbox gespeichert'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Speichern: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Neue Aufgabe',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'Aufgaben-Titel',
              hintText: 'z.B. Wohnung aufräumen',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            enabled: !_isLoading,
            textCapitalization: TextCapitalization.sentences,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else ...[
            ElevatedButton.icon(
              onPressed: _handleInsertImmediately,
              icon: const Icon(Icons.flash_on),
              label: const Text('Sofort einschieben'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _handleSaveToInbox,
              icon: const Icon(Icons.inbox),
              label: const Text('Später zerlegen'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
