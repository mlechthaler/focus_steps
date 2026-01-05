/// Represents a task with its breakdown into micro-steps
class Task {
  final String id;
  final String title;
  final List<MicroStep> steps;
  final int parkCount; // Number of times this task was "parked" (procrastinated)
  final DateTime createdAt;
  final DateTime? lastParkedAt;

  Task({
    required this.id,
    required this.title,
    required this.steps,
    this.parkCount = 0,
    required this.createdAt,
    this.lastParkedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    List<MicroStep>? steps,
    int? parkCount,
    DateTime? createdAt,
    DateTime? lastParkedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      steps: steps ?? this.steps,
      parkCount: parkCount ?? this.parkCount,
      createdAt: createdAt ?? this.createdAt,
      lastParkedAt: lastParkedAt ?? this.lastParkedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'steps': steps.map((s) => s.toJson()).toList(),
      'parkCount': parkCount,
      'createdAt': createdAt.toIso8601String(),
      'lastParkedAt': lastParkedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((s) => MicroStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      parkCount: json['parkCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastParkedAt: json['lastParkedAt'] != null
          ? DateTime.parse(json['lastParkedAt'] as String)
          : null,
    );
  }
}

/// Represents a single micro-step within a task
class MicroStep {
  final int stepNumber;
  final String title;
  final String description;
  final int estimatedMinutes;
  final bool isCompleted;

  MicroStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  MicroStep copyWith({
    int? stepNumber,
    String? title,
    String? description,
    int? estimatedMinutes,
    bool? isCompleted,
  }) {
    return MicroStep(
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'title': title,
      'description': description,
      'estimated_minutes': estimatedMinutes,
      'isCompleted': isCompleted,
    };
  }

  factory MicroStep.fromJson(Map<String, dynamic> json) {
    return MicroStep(
      stepNumber: json['step_number'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedMinutes: json['estimated_minutes'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
