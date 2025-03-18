// data/indicator_data.dart
import 'package:flutter/material.dart';
import 'package:theo/models/indicator_models.dart';

class IndicatorData {
  static List<Indicator> getMockIndicators() {
    return [
      Indicator(
        id: 1,
        name: 'RSI (Relative Strength Index)',
        type: 'Momentum',
        category: 'Technical',
        dateModified: '2024-03-05',
        usedIn: 8,
        favorite: true,
        description: 'Measures the magnitude of recent price changes to evaluate overbought or oversold conditions',
      ),
      Indicator(
        id: 2,
        name: 'MACD (Moving Average Convergence Divergence)',
        type: 'Trend',
        category: 'Technical',
        dateModified: '2024-02-15',
        usedIn: 6,
        favorite: true,
        description: 'Shows the relationship between two moving averages of a security\'s price',
      ),
      Indicator(
        id: 3,
        name: 'Moving Average (50-Day)',
        type: 'Trend',
        category: 'Technical',
        dateModified: '2024-03-10',
        usedIn: 10,
        favorite: false,
        description: 'Average closing price over the last 50 trading days',
      ),
      Indicator(
        id: 4,
        name: 'Bollinger Bands',
        type: 'Volatility',
        category: 'Technical',
        dateModified: '2024-01-20',
        usedIn: 4,
        favorite: false,
        description: 'Consists of a middle band with upper and lower bands based on standard deviations',
      ),
      Indicator(
        id: 5,
        name: 'P/E Ratio Alert',
        type: 'Valuation',
        category: 'Fundamental',
        dateModified: '2024-03-01',
        usedIn: 3,
        favorite: true,
        description: 'Alerts when Price-to-Earnings ratio crosses specified thresholds',
      ),
    ];
  }

  static List<IndicatorTemplate> getIndicatorTemplates() {
    return [
      IndicatorTemplate(
        id: 'momentum',
        name: 'Momentum',
        iconType: IconType.activity,
        colorClass: 'blue',
      ),
      IndicatorTemplate(
        id: 'trend',
        name: 'Trend',
        iconType: IconType.trendingUp,
        colorClass: 'green',
      ),
      IndicatorTemplate(
        id: 'volatility',
        name: 'Volatility',
        iconType: IconType.zap,
        colorClass: 'purple',
      ),
      IndicatorTemplate(
        id: 'volume',
        name: 'Volume',
        iconType: IconType.barChart,
        colorClass: 'indigo',
      ),
    ];
  }

  static IconData getIconForType(IconType type) {
    switch (type) {
      case IconType.activity:
        return Icons.show_chart;
      case IconType.trendingUp:
        return Icons.trending_up;
      case IconType.zap:
        return Icons.flash_on;
      case IconType.barChart:
        return Icons.bar_chart;
    }
  }

  static Color getBackgroundColorForTemplate(String colorClass) {
    switch (colorClass) {
      case 'blue':
        return Colors.blue.shade50;
      case 'green':
        return Colors.green.shade50;
      case 'purple':
        return Colors.purple.shade50;
      case 'indigo':
        return Colors.indigo.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  static Color getTextColorForTemplate(String colorClass) {
    switch (colorClass) {
      case 'blue':
        return Colors.blue.shade700;
      case 'green':
        return Colors.green.shade700;
      case 'purple':
        return Colors.purple.shade700;
      case 'indigo':
        return Colors.indigo.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  static List<String> getCategoryOptions() {
    return ['all', 'technical', 'fundamental', 'custom'];
  }
  
  static String getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'All Categories';
      case 'technical':
        return 'Technical';
      case 'fundamental':
        return 'Fundamental';
      case 'custom':
        return 'Custom';
      default:
        return category;
    }
  }

  static List<String> getSortOptions() {
    return ['most-used', 'recent', 'alphabetical'];
  }
  
  static String getSortDisplayName(String sort) {
    switch (sort) {
      case 'most-used':
        return 'Most Used';
      case 'recent':
        return 'Recently Modified';
      case 'alphabetical':
        return 'Alphabetical';
      default:
        return sort;
    }
  }
}