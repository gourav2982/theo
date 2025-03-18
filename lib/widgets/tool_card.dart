import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/tool_models.dart';

class ToolCard extends StatelessWidget {
  final ToolOption tool;
  final VoidCallback? onTap;

  const ToolCard({
    Key? key,
    required this.tool,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tool icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  tool.icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Tool details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: Color(0xFF1F2937), // gray-800
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: Color(0xFF6B7280), // gray-600
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Right chevron
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF9CA3AF), // gray-400
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}