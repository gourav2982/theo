import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/learning_models.dart';

class PopularCourseGrid extends StatelessWidget {
  final List<PopularCourse> courses;

  const PopularCourseGrid({
    Key? key,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
            childAspectRatio: 0.9, // Reduced from 1.1 to provide more height
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        course.title,
                        style: AppTheme.subheadingStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFBBF24), // yellow-400
                          size: 14, // Reduced from 16
                        ),
                        const SizedBox(width: 2), // Reduced from 4
                        Text(
                          course.rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4), // Reduced from 8
                        Expanded(
                          child: Text(
                            '${course.students} students',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11, // Reduced from 12
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6), // Reduced from 8
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 2), // Reduced from 4
                        Flexible(
                          child: Text(
                            course.instructor,
                            style: const TextStyle(
                              fontSize: 11, // Reduced from 12
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 32, // Fixed height for button
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle view course button
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        child: const Text(
                          'View Course',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}