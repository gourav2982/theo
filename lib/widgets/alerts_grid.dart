import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/models.dart';

class AlertsGrid extends StatelessWidget {
  final List<Alert> alerts;

  const AlertsGrid({
    Key? key,
    required this.alerts,
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
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            final bool isBuy = alert.action == 'BUY';
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alert.symbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isBuy 
                                ? AppTheme.accentGreen.withOpacity(0.1) 
                                : AppTheme.accentRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            alert.action,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isBuy 
                                  ? const Color(0xFF065F46) // green-800
                                  : const Color(0xFFB91C1C), // red-800
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alert.price,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          alert.change,
                          style: TextStyle(
                            fontSize: 12,
                            color: alert.change.startsWith('+') 
                                ? AppTheme.accentGreen
                                : AppTheme.accentRed,
                          ),
                        ),
                      ],
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