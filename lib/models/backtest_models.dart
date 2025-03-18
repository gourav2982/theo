// Models for the backtest screen

enum BacktestStatus {
  completed,
  inProgress,
}

class Backtest {
  final int id;
  final String name;
  final String date;
  final String strategy;
  final String basket;
  final String period;
  final double? returnPercent;
  final double? benchmark;
  final BacktestStatus status;

  Backtest({
    required this.id,
    required this.name,
    required this.date,
    required this.strategy,
    required this.basket,
    required this.period,
    this.returnPercent,
    this.benchmark,
    required this.status,
  });

  bool get isOutperforming => 
      returnPercent != null && 
      benchmark != null && 
      returnPercent! >= benchmark!;
}