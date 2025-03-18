import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';

class PaperTradesCard extends StatelessWidget {
  const PaperTradesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Start paper trading to test your strategies without risk',
              textAlign: TextAlign.center,
              style: AppTheme.captionStyle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                'Create New Paper Trade',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}