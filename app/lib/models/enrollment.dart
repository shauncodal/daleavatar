import 'course.dart';

class Enrollment {
  final int enrollmentId;
  final Course course;
  final String status;
  final Progress progress;
  final DateTime enrolledAt;
  final DateTime? completedAt;

  Enrollment({
    required this.enrollmentId,
    required this.course,
    required this.status,
    required this.progress,
    required this.enrolledAt,
    this.completedAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentId: json['enrollmentId'] as int? ?? json['id'] as int,
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      status: json['status'] as String,
      progress: Progress.fromJson(json['progress'] as Map<String, dynamic>),
      enrolledAt: DateTime.parse(json['enrolledAt'] as String? ?? json['enrolled_at'] as String),
      completedAt: json['completedAt'] != null 
        ? DateTime.parse(json['completedAt'] as String)
        : (json['completed_at'] != null 
            ? DateTime.parse(json['completed_at'] as String)
            : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollmentId': enrollmentId,
      'course': course.toJson(),
      'status': status,
      'progress': progress.toJson(),
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class Progress {
  final double completionPercentage;
  final int currentStep;
  final DateTime? lastAccessed;

  Progress({
    required this.completionPercentage,
    required this.currentStep,
    this.lastAccessed,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      completionPercentage: (json['completionPercentage'] as num?)?.toDouble() ?? 
                            (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      currentStep: json['currentStep'] as int? ?? json['current_step'] as int? ?? 0,
      lastAccessed: json['lastAccessed'] != null
        ? DateTime.parse(json['lastAccessed'] as String)
        : (json['last_accessed'] != null
            ? DateTime.parse(json['last_accessed'] as String)
            : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completionPercentage': completionPercentage,
      'currentStep': currentStep,
      'lastAccessed': lastAccessed?.toIso8601String(),
    };
  }
}

