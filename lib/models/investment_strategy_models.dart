// models/investment_strategy.dart
class InvestmentStrategy {
  final int id;
  final String name;
  final String dateCreated;
  final String dateModified;
  final String type;
  final List<String> indicators;
  final double performance;
  final int usedIn;
  final bool favorite;

  InvestmentStrategy({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.dateModified,
    required this.type,
    required this.indicators,
    required this.performance,
    required this.usedIn,
    required this.favorite,
  });
}

class StrategyTemplate {
  final String id;
  final String name;
  final IconType iconType;
  final String colorClass;

  StrategyTemplate({
    required this.id,
    required this.name,
    required this.iconType,
    required this.colorClass,
  });
}

enum IconType {
  arrowUp,
  arrowDown,
  sliders,
  barChart,
}