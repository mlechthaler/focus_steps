/// Model for a micro-task step
class TaskStep {
  final int stepNumber;
  final String title;
  final String description;
  final int estimatedMinutes;
  final bool isCompleted;

  const TaskStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  TaskStep copyWith({
    int? stepNumber,
    String? title,
    String? description,
    int? estimatedMinutes,
    bool? isCompleted,
  }) {
    return TaskStep(
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory TaskStep.fromJson(Map<String, dynamic> json) {
    return TaskStep(
      stepNumber: json['step_number'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedMinutes: json['estimated_minutes'] as int,
      isCompleted: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'title': title,
      'description': description,
      'estimated_minutes': estimatedMinutes,
      'is_completed': isCompleted,
    };
  }
}

/// Model for a task that can contain multiple micro-steps
class Task {
  final String id;
  final String title;
  final List<TaskStep> steps;
  final int totalEstimatedMinutes;

  const Task({
    required this.id,
    required this.title,
    required this.steps,
    required this.totalEstimatedMinutes,
  });

  Task copyWith({
    String? id,
    String? title,
    List<TaskStep>? steps,
    int? totalEstimatedMinutes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      steps: steps ?? this.steps,
      totalEstimatedMinutes:
          totalEstimatedMinutes ?? this.totalEstimatedMinutes,
    );
  }

  factory Task.fromApiResponse(Map<String, dynamic> json, String id) {
    final stepsJson = json['steps'] as List<dynamic>;
    final steps = stepsJson
        .map((step) => TaskStep.fromJson(step as Map<String, dynamic>))
        .toList();

    return Task(
      id: id,
      title: json['task'] as String,
      steps: steps,
      totalEstimatedMinutes: json['total_estimated_minutes'] as int,
    );
  }

  /// Creates a simple task for inbox (not yet broken down)
  factory Task.forInbox(String title, String id) {
    return Task(
      id: id,
      title: title,
      steps: [],
      totalEstimatedMinutes: 0,
    );
  }
}
