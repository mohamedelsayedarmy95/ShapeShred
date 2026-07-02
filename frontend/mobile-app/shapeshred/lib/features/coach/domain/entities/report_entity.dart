import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressReport {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double bodyFat;
  final double muscleMass;
  final int caloriesBurned;
  final int workoutsCompleted;

  ProgressReport({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    required this.bodyFat,
    required this.muscleMass,
    required this.caloriesBurned,
    required this.workoutsCompleted,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'date': date,
        'weight': weight,
        'bodyFat': bodyFat,
        'muscleMass': muscleMass,
        'caloriesBurned': caloriesBurned,
        'workoutsCompleted': workoutsCompleted,
      };

  factory ProgressReport.fromMap(Map<String, dynamic> map) => ProgressReport(
        id: map['id'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
        bodyFat: (map['bodyFat'] as num?)?.toDouble() ?? 0.0,
        muscleMass: (map['muscleMass'] as num?)?.toDouble() ?? 0.0,
        caloriesBurned: map['caloriesBurned'] as int? ?? 0,
        workoutsCompleted: map['workoutsCompleted'] as int? ?? 0,
      );
}
