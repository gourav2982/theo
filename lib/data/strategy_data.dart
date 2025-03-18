// data/strategy_data.dart
import 'package:theo/models/strategy_component_models.dart';

class StrategyData {
  static TradingStrategy getMockTradingStrategy() {
    return TradingStrategy(
      name: 'Momentum Growth Strategy',
      description: 'A strategy focused on stocks with positive momentum and upward trends',
      type: 'momentum',
      indicators: getMockIndicators(),
      entryConditions: getMockEntryConditions(),
      exitConditions: getMockExitConditions(),
      riskSettings: getMockRiskSettings(),
    );
  }

  static List<TechnicalIndicator> getMockIndicators() {
    return [
      TechnicalIndicator(
        id: 1,
        name: 'RSI',
        parameters: {
          'period': 14,
          'overbought': 70,
          'oversold': 30,
        },
      ),
      TechnicalIndicator(
        id: 2,
        name: 'MACD',
        parameters: {
          'fast': 12,
          'slow': 26,
          'signal': 9,
        },
      ),
      TechnicalIndicator(
        id: 3,
        name: 'Moving Average',
        parameters: {
          'period': 50,
          'type': 'Simple',
        },
      ),
    ];
  }

  static List<StrategyCondition> getMockEntryConditions() {
    return [
      StrategyCondition(
        id: 1,
        indicator: 'RSI',
        condition: 'crosses above',
        value: 30,
        logic: 'AND',
      ),
      StrategyCondition(
        id: 2,
        indicator: 'MACD',
        condition: 'crosses above',
        value: 'Signal Line',
        logic: null,
      ),
    ];
  }

  static List<StrategyCondition> getMockExitConditions() {
    return [
      StrategyCondition(
        id: 1,
        indicator: 'RSI',
        condition: 'crosses above',
        value: 70,
        logic: 'OR',
      ),
      StrategyCondition(
        id: 2,
        indicator: 'Stop Loss',
        condition: 'reaches',
        value: '5%',
        logic: null,
      ),
    ];
  }

  static RiskManagementSettings getMockRiskSettings() {
    return RiskManagementSettings(
      stopLoss: 5,
      takeProfit: 15,
      trailingStop: 2,
      maxOpenPositions: 5,
      positionSizing: 'equal',
    );
  }

  static List<String> getStrategyTypes() {
    return [
      'momentum', 
      'mean-reversion', 
      'trend-following', 
      'breakout', 
      'value', 
      'custom'
    ];
  }
  
  static String getStrategyTypeDisplayName(String type) {
    switch (type) {
      case 'momentum':
        return 'Momentum';
      case 'mean-reversion':
        return 'Mean Reversion';
      case 'trend-following':
        return 'Trend Following';
      case 'breakout':
        return 'Breakout';
      case 'value':
        return 'Value Investing';
      case 'custom':
        return 'Custom';
      default:
        return type;
    }
  }

  static List<String> getConditionOptions() {
    return [
      'crosses above',
      'crosses below',
      'is above',
      'is below',
      'increases by',
      'decreases by',
      'reaches',
      'is triggered',
    ];
  }
  
  static List<String> getPositionSizingOptions() {
    return [
      'equal',
      'fixed',
      'percent',
      'risk',
    ];
  }
  
  static String getPositionSizingDisplayName(String type) {
    switch (type) {
      case 'equal':
        return 'Equal Weight';
      case 'fixed':
        return 'Fixed Dollar Amount';
      case 'percent':
        return 'Percentage of Portfolio';
      case 'risk':
        return 'Risk-Adjusted';
      default:
        return type;
    }
  }
}