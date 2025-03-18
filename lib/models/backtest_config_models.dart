// Models for backtest configuration and results

class Strategy {
  final String id;
  final String name;

  Strategy({
    required this.id,
    required this.name,
  });
}

class Basket {
  final String id;
  final String name;

  Basket({
    required this.id,
    required this.name,
  });
}

class PerformanceData {
  final String date;
  final double strategy;
  final double benchmark;

  PerformanceData({
    required this.date,
    required this.strategy,
    required this.benchmark,
  });
}

class PerformanceMetric {
  final String title;
  final String value;
  final String comparison;
  final bool isPositive;

  PerformanceMetric({
    required this.title,
    required this.value,
    required this.comparison,
    this.isPositive = true,
  });
}

class TradeRecord {
  final String date;
  final String action;
  final String symbol;
  final String price;
  final bool isBuy;

  TradeRecord({
    required this.date,
    required this.action,
    required this.symbol,
    required this.price,
    required this.isBuy,
  });
}