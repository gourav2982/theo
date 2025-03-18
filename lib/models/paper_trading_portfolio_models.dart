// models/paper_trading_portfolio.dart
class PaperTradingPortfolio {
  final int id;
  final String name;
  final String startDate;
  final String duration;
  final String strategy;
  final double initialBalance;
  final double currentBalance;
  final double returnPercentage;
  final String status;

  PaperTradingPortfolio({
    required this.id,
    required this.name,
    required this.startDate,
    required this.duration,
    required this.strategy,
    required this.initialBalance,
    required this.currentBalance,
    required this.returnPercentage,
    required this.status,
  });
}

// models/portfolio_data.dart
class PortfolioData {
  final double accountValue;
  final double initialBalance;
  final double buyingPower;
  final double dailyChange;
  final double dailyChangePercent;
  final double totalGain;
  final double totalGainPercent;

  PortfolioData({
    required this.accountValue,
    required this.initialBalance,
    required this.buyingPower,
    required this.dailyChange,
    required this.dailyChangePercent,
    required this.totalGain,
    required this.totalGainPercent,
  });
}

// models/position.dart
class Position {
  final String symbol;
  final String name;
  final int shares;
  final double avgPrice;
  final double currentPrice;
  final double value;
  final double gain;
  final double gainPercent;

  Position({
    required this.symbol,
    required this.name,
    required this.shares,
    required this.avgPrice,
    required this.currentPrice,
    required this.value,
    required this.gain,
    required this.gainPercent,
  });
}

// models/stock_order.dart
class StockOrder {
  final int id;
  final String date;
  final String time;
  final String symbol;
  final String type;
  final String status;
  final int quantity;
  final double price;
  final double total;

  StockOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.symbol,
    required this.type,
    required this.status,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

// models/watchlist_item.dart
class WatchlistItem {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;

  WatchlistItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
  });
}