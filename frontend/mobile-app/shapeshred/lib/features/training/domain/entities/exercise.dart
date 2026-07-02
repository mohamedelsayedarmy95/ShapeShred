import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String category;
  final String difficulty;
  final String equipmentRequired;
  final List<String> targetMuscles;
  final String? videoUrl;
  final String? thumbnailUrl;
  final List<String> instructions;
  final List<String> formTips;
  final double? caloriesPerMinute;
  final bool isPremium;

  const Exercise({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.difficulty,
    required this.equipmentRequired,
    required this.targetMuscles,
    this.videoUrl,
    this.thumbnailUrl,
    required this.instructions,
    required this.formTips,
    this.caloriesPerMinute,
    required this.isPremium,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        difficulty,
        equipmentRequired,
        targetMuscles,
        videoUrl,
        thumbnailUrl,
        instructions,
        formTips,
        caloriesPerMinute,
        isPremium,
      ];
}
