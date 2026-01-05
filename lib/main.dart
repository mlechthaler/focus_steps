import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/task.dart';
import 'providers/tasks_provider.dart';
import 'widgets/add_task_bottom_sheet.dart';
import 'widgets/task_card.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Steps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Focus Steps'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddTaskBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTasks = ref.watch(currentTasksProvider);
    final inboxTasks = ref.watch(inboxTasksProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Aktuelle Aufgaben'),
              Tab(icon: Icon(Icons.inbox), text: 'Inbox'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Current tasks tab
            _buildTasksList(
              context,
              ref,
              currentTasks,
              currentTasksProvider,
              emptyMessage: 'Keine aktuellen Aufgaben.\nFüge eine neue Aufgabe hinzu!',
            ),
            // Inbox tab
            _buildTasksList(
              context,
              ref,
              inboxTasks,
              inboxTasksProvider,
              emptyMessage: 'Inbox ist leer.\nSpeichere Aufgaben für später hier.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddTaskBottomSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('Neue Aufgabe'),
        ),
      ),
    );
  }

  Widget _buildTasksList(
    BuildContext context,
    WidgetRef ref,
    List<Task> tasks,
    StateNotifierProvider<TasksNotifier, List<Task>> provider,
    {required String emptyMessage}
  ) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist,
              size: 64,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onDelete: () {
            ref.read(provider.notifier).removeTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aufgabe gelöscht'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
