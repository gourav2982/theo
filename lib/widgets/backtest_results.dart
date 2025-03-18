import 'package:flutter/material.dart';
import 'package:theo/models/backtest_config_models.dart';
import 'package:theo/widgets/performance_metrics.dart';
import 'package:theo/widgets/performance_chart.dart';
import 'package:theo/widgets/trade_history.dart';

class BacktestResults extends StatelessWidget {
  final List<PerformanceMetric> metrics;
  final List<PerformanceData> chartData;
  final List<TradeRecord> trades;

  const BacktestResults({
    Key? key,
    required this.metrics,
    required this.chartData,
    required this.trades,
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
              'Backtest Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827), // gray-900
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            
            // Performance Metrics
            PerformanceMetricsGrid(metrics: metrics),
            const SizedBox(height: 24),
            
            // Chart
            const Text(
              'Performance Chart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827), // gray-900
                fontFamily: 'Roboto',
              ),
            ),
            PerformanceChart(data: chartData),
            const SizedBox(height: 16),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Your Strategy', const Color(0xFF3B82F6)), // blue-500
                const SizedBox(width: 16),
                _buildLegendItem('Benchmark', const Color(0xFF9CA3AF)), // gray-400
              ],
            ),
            const SizedBox(height: 24),
            
            // Trade History
            TradeHistoryTable(trades: trades),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4B5563), // gray-600
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}