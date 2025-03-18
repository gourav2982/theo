import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/course_models.dart';

class CourseMenu extends StatelessWidget {
  final List<Lesson> lessons;
  final int currentLessonIndex;
  final Function(int) onLessonSelected;
  final VoidCallback onClose;

  const CourseMenu({
    Key? key,
    required this.lessons,
    required this.currentLessonIndex,
    required this.onLessonSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Course Content',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          
          // Lesson List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final isSelected = index == currentLessonIndex;
                
                return GestureDetector(
                  onTap: () {
                    onLessonSelected(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white, // blue-50 or white
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFBFDBFE) : Colors.grey.shade200, // blue-200 or gray-200
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: lesson.completed 
                                ? const Color(0xFFD1FAE5) // green-100
                                : const Color(0xFFF3F4F6), // gray-100
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Icon(
                              _getLessonIcon(lesson),
                              size: 16,
                              color: lesson.completed 
                                  ? const Color(0xFF059669) // green-600
                                  : const Color(0xFF6B7280), // gray-500
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Lesson details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: isSelected 
                                      ? const Color(0xFF1D4ED8) // blue-700
                                      : const Color(0xFF1F2937), // gray-800
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    _getLessonTypeText(lesson.type),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280), // gray-500
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  const Text(
                                    ' • ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280), // gray-500
                                    ),
                                  ),
                                  Text(
                                    lesson.duration,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280), // gray-500
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Current indicator
                        if (isSelected)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getLessonIcon(Lesson lesson) {
    if (lesson.completed) {
      return Icons.check;
    }
    
    switch (lesson.type) {
      case LessonType.video:
        return Icons.play_arrow;
      case LessonType.text:
        return Icons.description;
      case LessonType.quiz:
        return Icons.help_outline;
      default:
        return Icons.description;
    }
  }
  
  String _getLessonTypeText(LessonType type) {
    switch (type) {
      case LessonType.video:
        return 'Video';
      case LessonType.text:
        return 'Text';
      case LessonType.quiz:
        return 'Quiz';
      default:
        return 'Lesson';
    }
  }
}