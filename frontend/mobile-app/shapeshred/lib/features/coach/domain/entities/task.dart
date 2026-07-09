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
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : DateTime.now(),
    isCompleted: map['isCompleted'] ?? false,
    assignedBy: map['assignedBy'] ?? '',
  );
}
