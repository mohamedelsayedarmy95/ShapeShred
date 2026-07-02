import 'package:cloud_firestore/cloud_firestore.dart';

class InBodyData {
  final double weight; // kg
  final double bodyFat; // %
  final double muscleMass; // kg
  final double bmi;
  final double visceralFat; // level
  final double boneMass; // kg
  final double protein; // kg
  final double mineral; // kg
  final double totalBodyWater; // L
  final DateTime measuredAt;

  InBodyData({
    required this.weight,
    required this.bodyFat,
    required this.muscleMass,
    required this.bmi,
    required this.visceralFat,
    required this.boneMass,
    required this.protein,
    required this.mineral,
    required this.totalBodyWater,
    required this.measuredAt,
  });

  Map<String, dynamic> toMap() => {
        'weight': weight,
        'bodyFat': bodyFat,
        'muscleMass': muscleMass,
        'bmi': bmi,
        'visceralFat': visceralFat,
        'boneMass': boneMass,
        'protein': protein,
        'mineral': mineral,
        'totalBodyWater': totalBodyWater,
        'measuredAt': measuredAt,
      };

  factory InBodyData.fromMap(Map<String, dynamic> map) => InBodyData(
        weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
        bodyFat: (map['bodyFat'] as num?)?.toDouble() ?? 0.0,
        muscleMass: (map['muscleMass'] as num?)?.toDouble() ?? 0.0,
        bmi: (map['bmi'] as num?)?.toDouble() ?? 0.0,
        visceralFat: (map['visceralFat'] as num?)?.toDouble() ?? 0.0,
        boneMass: (map['boneMass'] as num?)?.toDouble() ?? 0.0,
        protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
        mineral: (map['mineral'] as num?)?.toDouble() ?? 0.0,
        totalBodyWater: (map['totalBodyWater'] as num?)?.toDouble() ?? 0.0,
        measuredAt:
            (map['measuredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}
