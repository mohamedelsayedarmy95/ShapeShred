class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String assignedBy; // coachId

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.assignedBy,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
        'assignedBy': assignedBy,
      };

  factory Task.fromMap(String id, Map<String, dynamic> map) => Task(
        id: id,
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        dueDate: map['dueDate'] != null
            ? DateTime.parse(map['dueDate'] as String)
            : DateTime.now(),
        isCompleted: map['isCompleted'] as bool? ?? false,
        assignedBy: map['assignedBy'] as String? ?? '',
      );
}
