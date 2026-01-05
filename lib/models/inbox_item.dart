/// Represents a task that has been parked or marked for later
class InboxItem {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;

  InboxItem({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  /// Creates an InboxItem from a JSON map
  factory InboxItem.fromJson(Map<String, dynamic> json) {
    return InboxItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Converts this InboxItem to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InboxItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
