import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';

class LearningProgress extends StatelessWidget {
  final int completed;
  final int total;
  final double percentage;

  const LearningProgress({
    Key? key,
    required this.completed,
    required this.total,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Using Flexible for the heading to allow it to shrink if needed
                const Flexible(
                  child: Text(
                    'Your Learning Progress',
                    style: AppTheme.headingStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between the two texts
                // Using a more compact text for the completion status
                Text(
                  '$completed/$total',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            // Optionally add a small subtitle for clarity
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'lessons completed',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12.0,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                color: AppTheme.primaryColor,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percentage.toInt()}% Complete',
                  style: AppTheme.captionStyle,
                ),
                GestureDetector(
                  onTap: () {
                    // Handle tap on "View Learning Path"
                  },
                  child: const Text(
                    'View Learning Path',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}