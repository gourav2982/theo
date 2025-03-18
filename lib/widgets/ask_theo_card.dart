import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/widgets/chat_service.dart';

class AskTheoCard extends StatelessWidget {
  const AskTheoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ask Theo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your AI financial assistant is ready to answer any investment questions',
                    style: TextStyle(
                      color: Color(0xFFDCEAFE), // Light blue
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ChatService.openChat(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Ask a Question',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Only show the icon on wider screens
                  if (constraints.maxWidth < 100) {
                    return const SizedBox();
                  }
                  return const Icon(
                    Icons.message,
                    size: 60,
                    color: Color(0xFF93C5FD), // Blue-300
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}