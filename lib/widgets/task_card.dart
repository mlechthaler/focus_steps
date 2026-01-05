import 'package:flutter/material.dart';
import '../models/task.dart';

/// Widget to display a single task with its steps
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    iconSize: 20,
                  ),
              ],
            ),
            if (task.steps.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${task.steps.length} Schritte • ~${task.totalEstimatedMinutes} Min',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 12),
              ...task.steps.take(3).map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${step.stepNumber}. ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Expanded(
                          child: Text(
                            step.title,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          '${step.estimatedMinutes} min',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 11,
                                  ),
                        ),
                      ],
                    ),
                  )),
              if (task.steps.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... und ${task.steps.length - 3} weitere Schritte',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Noch nicht zerlegt',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
