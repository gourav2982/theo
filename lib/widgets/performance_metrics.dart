import 'package:flutter/material.dart';
import 'package:theo/models/backtest_config_models.dart';

class PerformanceMetricsGrid extends StatelessWidget {
  final List<PerformanceMetric> metrics;

  const PerformanceMetricsGrid({
    Key? key,
    required this.metrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns based on available width
        final int columns = constraints.maxWidth > 600 ? 4 : 2;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _buildMetricCard(metric);
          },
        );
      }
    );
  }

  Widget _buildMetricCard(PerformanceMetric metric) {
    Color valueColor;
    
    if (metric.title == 'Max Drawdown') {
      // For Max Drawdown, red is positive (better)
      valueColor = metric.isPositive 
          ? const Color(0xFFDC2626) // red-600
          : const Color(0xFF059669); // green-600
    } else {
      // For other metrics, green is positive (better)
      valueColor = metric.isPositive 
          ? const Color(0xFF059669) // green-600
          : const Color(0xFFDC2626); // red-600
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // gray-50
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280), // gray-500
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.comparison,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280), // gray-500
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}