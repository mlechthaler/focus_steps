import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_repository.dart';
import '../screens/focus_view.dart';

/// Widget that displays the top 3 most procrastinated tasks
class ProcrastinatedTasksWidget extends StatelessWidget {
  final TaskRepository taskRepository;

  const ProcrastinatedTasksWidget({
    super.key,
    required this.taskRepository,
  });

  void _startFocusView(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FocusView(
          task: task,
          taskRepository: taskRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topTasks = taskRepository.getTopProcrastinatedTasks(limit: 3);

    if (topTasks.isEmpty) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Keine aufgeschobenen Aufgaben',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Super! Du hast aktuell keine Aufgaben, die du häufig parkst.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with motivational text
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meist aufgeschobene Aufgaben',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nur 2 Minuten? Fangen wir mit einem kleinen Schritt an',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // List of top 3 procrastinated tasks
            ...topTasks.asMap().entries.map((entry) {
              final index = entry.key;
              final task = entry.value;
              final isLast = index == topTasks.length - 1;

              return Column(
                children: [
                  InkWell(
                    onTap: () => _startFocusView(context, task),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          // Rank badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _getRankColor(context, index),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Task info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pause_circle_outline,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${task.parkCount}× geparkt',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.format_list_numbered,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${task.steps.length} Schritte',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Arrow icon
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: Colors.grey[300],
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(BuildContext context, int index) {
    switch (index) {
      case 0:
        return Colors.red[400]!; // Most procrastinated
      case 1:
        return Colors.orange[400]!;
      case 2:
        return Colors.amber[600]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
