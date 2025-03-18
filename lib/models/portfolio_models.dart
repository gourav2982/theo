// Models for the paper trading portfolios

enum PortfolioStatus {
  active,
  completed,
}

class Portfolio {
  final int id;
  final String name;
  final String startDate;
  final String duration;
  final String strategy;
  final double initialBalance;
  final double currentBalance;
  final double returnPercent;
  final PortfolioStatus status;

  Portfolio({
    required this.id,
    required this.name,
    required this.startDate,
    required this.duration,
    required this.strategy,
    required this.initialBalance,
    required this.currentBalance,
    required this.returnPercent,
    required this.status,
  });

  bool get isPositiveReturn => returnPercent >= 0;
}