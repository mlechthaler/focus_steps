import '../models/task.dart';

/// Service for managing tasks and their statistics
/// In a real app, this would persist data to local storage or a backend
class TaskRepository {
  final List<Task> _tasks = [];

  /// Get all tasks
  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }

  /// Get the top N most procrastinated tasks (sorted by parkCount descending)
  List<Task> getTopProcrastinatedTasks({int limit = 3}) {
    final sortedTasks = List<Task>.from(_tasks)
      ..sort((a, b) => b.parkCount.compareTo(a.parkCount));
    return sortedTasks.take(limit).toList();
  }

  /// Add a new task
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Increment the park count for a task (when user procrastinates/parks it)
  void parkTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        parkCount: _tasks[index].parkCount + 1,
        lastParkedAt: DateTime.now(),
      );
    }
  }

  /// Update a task's steps (e.g., mark as completed)
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  /// Get a task by ID
  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      return null;
    }
  }

  /// Remove a task
  void removeTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
  }

  /// Add sample tasks for demo purposes
  void addSampleTasks() {
    _tasks.clear();
    
    // Sample procrastinated tasks with varying park counts
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Steuererklärung machen',
        parkCount: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastParkedAt: DateTime.now().subtract(const Duration(hours: 2)),
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Alle Belege sammeln',
            description: 'Öffne den Ordner mit den Belegen und lege sie auf den Schreibtisch',
            estimatedMinutes: 5,
          ),
          MicroStep(
            stepNumber: 2,
            title: 'Belege nach Kategorie sortieren',
            description: 'Teile die Belege in Stapel: Einkommen, Ausgaben, Versicherungen',
            estimatedMinutes: 8,
          ),
          MicroStep(
            stepNumber: 3,
            title: 'Elster-Programm öffnen',
            description: 'Starte das Elster-Programm auf deinem Computer',
            estimatedMinutes: 2,
          ),
        ],
      ),
      Task(
        id: '2',
        title: 'Arzttermin vereinbaren',
        parkCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastParkedAt: DateTime.now().subtract(const Duration(hours: 5)),
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Telefonnummer der Praxis raussuchen',
            description: 'Öffne die Webseite der Arztpraxis oder dein Telefonbuch',
            estimatedMinutes: 2,
          ),
          MicroStep(
            stepNumber: 2,
            title: 'Telefon zur Hand nehmen',
            description: 'Nimm dein Handy und entsperre es',
            estimatedMinutes: 1,
          ),
          MicroStep(
            stepNumber: 3,
            title: 'Nummer wählen',
            description: 'Gib die Telefonnummer ein und drücke auf Anrufen',
            estimatedMinutes: 1,
          ),
        ],
      ),
      Task(
        id: '3',
        title: 'E-Mails beantworten',
        parkCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        lastParkedAt: DateTime.now().subtract(const Duration(hours: 1)),
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'E-Mail-Programm öffnen',
            description: 'Klicke auf dein E-Mail-Icon oder öffne die Website',
            estimatedMinutes: 1,
          ),
          MicroStep(
            stepNumber: 2,
            title: 'Erste ungelesene E-Mail öffnen',
            description: 'Scrolle zu der ältesten ungelesenen E-Mail und öffne sie',
            estimatedMinutes: 2,
          ),
          MicroStep(
            stepNumber: 3,
            title: 'Kurze Antwort tippen',
            description: 'Schreibe eine kurze, freundliche Antwort in 2-3 Sätzen',
            estimatedMinutes: 5,
          ),
        ],
      ),
      Task(
        id: '4',
        title: 'Wohnung aufräumen',
        parkCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        steps: [
          MicroStep(
            stepNumber: 1,
            title: 'Eine Ecke aussuchen',
            description: 'Wähle die kleinste, unordentlichste Ecke im Raum aus',
            estimatedMinutes: 1,
          ),
          MicroStep(
            stepNumber: 2,
            title: '5 Dinge aufheben',
            description: 'Nimm 5 Gegenstände und lege sie an ihren Platz',
            estimatedMinutes: 3,
          ),
        ],
      ),
    ]);
  }
}
