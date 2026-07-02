import 'package:cloud_firestore/cloud_firestore.dart';

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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? assignedBy,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedBy: assignedBy ?? this.assignedBy,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'isCompleted': isCompleted,
        'assignedBy': assignedBy,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isCompleted: map['isCompleted'] as bool? ?? false,
        assignedBy: map['assignedBy'] as String? ?? '',
      );
}
