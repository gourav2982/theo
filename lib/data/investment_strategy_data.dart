// data/investment_strategy_data.dart
import 'package:flutter/material.dart';
import 'package:theo/models/investment_strategy_models.dart';

class InvestmentStrategyData {
  static List<InvestmentStrategy> getMockStrategies() {
    return [
      InvestmentStrategy(
        id: 1,
        name: 'Momentum Growth',
        dateCreated: '2024-01-15',
        dateModified: '2024-02-28',
        type: 'Custom',
        indicators: ['RSI', 'MACD', 'Moving Average'],
        performance: 12.5,
        usedIn: 3,
        favorite: true,
      ),
      InvestmentStrategy(
        id: 2,
        name: 'Value Investing',
        dateCreated: '2023-11-10',
        dateModified: '2024-01-05',
        type: 'Predefined',
        indicators: ['P/E Ratio', 'Dividend Yield', 'PEG Ratio'],
        performance: 8.2,
        usedIn: 2,
        favorite: false,
      ),
      InvestmentStrategy(
        id: 3,
        name: 'Mean Reversion',
        dateCreated: '2024-02-05',
        dateModified: '2024-03-01',
        type: 'Custom',
        indicators: ['Bollinger Bands', 'RSI', 'Stochastic'],
        performance: -2.3,
        usedIn: 1,
        favorite: false,
      ),
      InvestmentStrategy(
        id: 4,
        name: 'Trend Following',
        dateCreated: '2023-10-15',
        dateModified: '2024-02-10',
        type: 'Predefined',
        indicators: ['Moving Average', 'ADX', 'MACD'],
        performance: 15.7,
        usedIn: 4,
        favorite: true,
      ),
      InvestmentStrategy(
        id: 5,
        name: 'Dividend Growth',
        dateCreated: '2024-03-01',
        dateModified: '2024-03-10',
        type: 'Custom',
        indicators: ['Dividend Yield', 'Dividend Growth Rate', 'Payout Ratio'],
        performance: 6.8,
        usedIn: 1,
        favorite: false,
      ),
    ];
  }

  static List<StrategyTemplate> getStrategyTemplates() {
    return [
      StrategyTemplate(
        id: 'momentum',
        name: 'Momentum',
        iconType: IconType.arrowUp,
        colorClass: 'blue',
      ),
      StrategyTemplate(
        id: 'mean-reversion',
        name: 'Mean Reversion',
        iconType: IconType.arrowDown,
        colorClass: 'green',
      ),
      StrategyTemplate(
        id: 'trend-following',
        name: 'Trend Following',
        iconType: IconType.sliders,
        colorClass: 'purple',
      ),
      StrategyTemplate(
        id: 'value',
        name: 'Value Investing',
        iconType: IconType.barChart,
        colorClass: 'indigo',
      ),
    ];
  }

  static IconData getIconForType(IconType type) {
    switch (type) {
      case IconType.arrowUp:
        return Icons.arrow_upward;
      case IconType.arrowDown:
        return Icons.arrow_downward;
      case IconType.sliders:
        return Icons.tune;
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
}