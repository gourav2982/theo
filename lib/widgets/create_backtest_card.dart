import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';

class CreateBacktestCard extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const CreateBacktestCard({
    Key? key,
    required this.onCreatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Backtest',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827), // gray-900
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Test your investment strategies against historical market data to see how they would have performed.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280), // gray-600
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCreatePressed,
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Create New Backtest',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}