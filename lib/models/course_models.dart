// Models for the course learning screen

class Lesson {
  final int id;
  final String title;
  final LessonType type;
  final String duration;
  final bool completed;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.completed,
  });
}

enum LessonType {
  video,
  text,
  quiz,
}

// Renamed from Course to CourseDetail to avoid collision with 
// the Course class in learning_models.dart
class CourseDetail {
  final String title;
  final int progress;
  final String currentModule;
  final List<Lesson> lessons;

  CourseDetail({
    required this.title,
    required this.progress,
    required this.currentModule,
    required this.lessons,
  });
}

class LessonContent {
  final String title;
  final String? videoUrl;
  final String text;

  LessonContent({
    required this.title,
    this.videoUrl,
    required this.text,
  });
}