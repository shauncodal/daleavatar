class Course {
  final int id;
  final String scenarioId;
  final String title;
  final String description;
  final String difficulty;
  final String? avatarImage;
  final List<String> tips;

  Course({
    required this.id,
    required this.scenarioId,
    required this.title,
    required this.description,
    required this.difficulty,
    this.avatarImage,
    this.tips = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      scenarioId: json['scenario_id'] as String? ?? json['scenarioId'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      avatarImage: json['avatar_image'] as String? ?? json['avatarImage'] as String?,
      tips: json['tips'] != null 
        ? (json['tips'] as List).map((e) => e.toString()).toList()
        : (json['tips_json'] != null
            ? (json['tips_json'] is List
                ? (json['tips_json'] as List).map((e) => e.toString()).toList()
                : [])
            : []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenario_id': scenarioId,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'avatar_image': avatarImage,
      'tips_json': tips,
    };
  }
}

