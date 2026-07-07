class Exercise {
  final String id;
  final String name;
  final String category;
  final String description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final int duration; // in seconds
  final List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.videoUrl,
    this.thumbnailUrl,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.duration,
    required this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'duration': duration,
      'instructions': instructions,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      muscleGroup: json['muscleGroup'] as String,
      equipment: json['equipment'] as String,
      difficulty: json['difficulty'] as String,
      duration: json['duration'] as int,
      instructions: List<String>.from(json['instructions'] as List),
    );
  }
}
