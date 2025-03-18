// models/strategy_components.dart
class IndicatorParameter {
  final String name;
  dynamic value;

  IndicatorParameter({
    required this.name,
    required this.value,
  });
}

class TechnicalIndicator {
  final int id;
  final String name;
  final Map<String, dynamic> parameters;

  TechnicalIndicator({
    required this.id,
    required this.name,
    required this.parameters,
  });
}

class StrategyCondition {
  final int id;
  final String indicator;
  final String condition;
  final dynamic value;
  final String? logic; // AND/OR, null for last condition

  StrategyCondition({
    required this.id,
    required this.indicator,
    required this.condition,
    required this.value,
    this.logic,
  });
}

class RiskManagementSettings {
  double stopLoss;
  double takeProfit;
  double trailingStop;
  int maxOpenPositions;
  String positionSizing;

  RiskManagementSettings({
    required this.stopLoss,
    required this.takeProfit,
    required this.trailingStop,
    required this.maxOpenPositions,
    required this.positionSizing,
  });
}

class TradingStrategy {
  String name;
  String description;
  String type;
  List<TechnicalIndicator> indicators;
  List<StrategyCondition> entryConditions;
  List<StrategyCondition> exitConditions;
  RiskManagementSettings riskSettings;

  TradingStrategy({
    required this.name,
    required this.description,
    required this.type,
    required this.indicators,
    required this.entryConditions,
    required this.exitConditions,
    required this.riskSettings,
  });
}