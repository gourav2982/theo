import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/models.dart';

class CompetitionsGrid extends StatelessWidget {
  final List<Competition> competitions;

  const CompetitionsGrid({
    Key? key,
    required this.competitions,
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
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: competitions.length,
          itemBuilder: (context, index) {
            final comp = competitions[index];
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comp.name,
                      style: AppTheme.subheadingStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Starts in:',
                          style: AppTheme.captionStyle,
                        ),
                        Text(
                          comp.starts,
                          style: AppTheme.captionStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${comp.participants} joined',
                      style: AppTheme.captionStyle,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Join Challenge'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}