import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_repository.dart';

/// Screen that displays the focus view for a single micro-step
class FocusView extends StatefulWidget {
  final Task task;
  final TaskRepository taskRepository;

  const FocusView({
    super.key,
    required this.task,
    required this.taskRepository,
  });

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> {
  late int _currentStepIndex;
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    // Find the first incomplete step
    _currentStepIndex = _currentTask.steps.indexWhere((step) => !step.isCompleted);
    if (_currentStepIndex == -1) {
      _currentStepIndex = 0; // Default to first step if all are completed
    }
  }

  void _completeCurrentStep() {
    final updatedSteps = List<MicroStep>.from(_currentTask.steps);
    updatedSteps[_currentStepIndex] = updatedSteps[_currentStepIndex].copyWith(
      isCompleted: true,
    );

    setState(() {
      _currentTask = _currentTask.copyWith(steps: updatedSteps);
    });

    widget.taskRepository.updateTask(_currentTask);

    // Move to next step or finish
    if (_currentStepIndex < _currentTask.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      // All steps completed
      _showCompletionDialog();
    }
  }

  void _parkTask() {
    widget.taskRepository.parkTask(_currentTask.id);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aufgabe geparkt. Kein Problem - versuch es später nochmal!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Geschafft!'),
        content: const Text('Du hast alle Schritte dieser Aufgabe abgeschlossen!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to home
            },
            child: const Text('Zurück'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _currentTask.steps[_currentStepIndex];
    final completedSteps = _currentTask.steps.where((s) => s.isCompleted).length;
    final totalSteps = _currentTask.steps.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fokus-Modus'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task title
            Text(
              _currentTask.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Progress indicator
            LinearProgressIndicator(
              value: completedSteps / totalSteps,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Schritt ${_currentStepIndex + 1} von $totalSteps',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Current step card
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step number badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Schritt ${currentStep.stepNumber}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step title
                      Text(
                        currentStep.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step description
                      Text(
                        currentStep.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      // Estimated time
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ca. ${currentStep.estimatedMinutes} Minuten',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            ElevatedButton(
              onPressed: _completeCurrentStep,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(
                _currentStepIndex < _currentTask.steps.length - 1
                    ? 'Erledigt! Nächster Schritt'
                    : 'Aufgabe abschließen',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _parkTask,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Aufgabe parken (später)',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
