import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:theo/models/backtest_config_models.dart';
import 'package:theo/config/app_theme.dart';

class PerformanceChart extends StatelessWidget {
  final List<PerformanceData> data;

  const PerformanceChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1000,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xFFE5E7EB), // gray-200
                  strokeWidth: 1,
                  dashArray: [3, 3],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xFFE5E7EB), // gray-200
                  strokeWidth: 1,
                  dashArray: [3, 3],
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < data.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          data[value.toInt()].date,
                          style: const TextStyle(
                            color: Color(0xFF6B7280), // gray-500
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2000,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '\$${value.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFF6B7280), // gray-500
                          fontSize: 12,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 0,
            maxX: data.length - 1.0,
            minY: _findMinValue() - 500,
            maxY: _findMaxValue() + 500,
            lineBarsData: [
              // Strategy line
              LineChartBarData(
                spots: _getStrategySpots(),
                isCurved: true,
                color: AppTheme.primaryColor,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppTheme.primaryColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
              ),
              // Benchmark line
              LineChartBarData(
                spots: _getBenchmarkSpots(),
                isCurved: true,
                color: const Color(0xFF9CA3AF), // gray-400
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: const Color(0xFF9CA3AF), // gray-400
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF9CA3AF).withOpacity(0.1), // gray-400
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getStrategySpots() {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].strategy));
    }
    return spots;
  }

  List<FlSpot> _getBenchmarkSpots() {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].benchmark));
    }
    return spots;
  }

  double _findMinValue() {
    double min = double.infinity;
    for (var item in data) {
      if (item.strategy < min) min = item.strategy;
      if (item.benchmark < min) min = item.benchmark;
    }
    return min;
  }

  double _findMaxValue() {
    double max = double.negativeInfinity;
    for (var item in data) {
      if (item.strategy > max) max = item.strategy;
      if (item.benchmark > max) max = item.benchmark;
    }
    return max;
  }
}