import 'package:theo/models/backtest_config_models.dart';

class BacktestConfigData {
  static List<Strategy> getStrategies() {
    return [
      Strategy(id: 'trend-following', name: 'Trend Following'),
      Strategy(id: 'mean-reversion', name: 'Mean Reversion'),
      Strategy(id: 'momentum', name: 'Momentum'),
      Strategy(id: 'value-investing', name: 'Value Investing'),
    ];
  }

  static List<Basket> getBaskets() {
    return [
      Basket(id: 'sp500', name: 'S&P 500'),
      Basket(id: 'nasdaq100', name: 'Nasdaq 100'),
      Basket(id: 'tech-sector', name: 'Tech Sector'),
      Basket(id: 'finance', name: 'Finance'),
    ];
  }

  static List<PerformanceData> getPerformanceData() {
    return [
      PerformanceData(date: 'Jan', strategy: 10500, benchmark: 10300),
      PerformanceData(date: 'Feb', strategy: 11200, benchmark: 10600),
      PerformanceData(date: 'Mar', strategy: 10800, benchmark: 10400),
      PerformanceData(date: 'Apr', strategy: 11500, benchmark: 10800),
      PerformanceData(date: 'May', strategy: 12200, benchmark: 11000),
      PerformanceData(date: 'Jun', strategy: 12800, benchmark: 11300),
      PerformanceData(date: 'Jul', strategy: 13500, benchmark: 11600),
      PerformanceData(date: 'Aug', strategy: 14200, benchmark: 11900),
    ];
  }

  static List<PerformanceMetric> getPerformanceMetrics() {
    return [
      PerformanceMetric(
        title: 'Total Return',
        value: '+42.0%',
        comparison: 'vs +19.0% benchmark',
        isPositive: true,
      ),
      PerformanceMetric(
        title: 'Sharpe Ratio',
        value: '1.8',
        comparison: 'vs 1.2 benchmark',
        isPositive: true,
      ),
      PerformanceMetric(
        title: 'Max Drawdown',
        value: '-14.2%',
        comparison: 'vs -18.5% benchmark',
        isPositive: false,
      ),
      PerformanceMetric(
        title: 'Win Rate',
        value: '68%',
        comparison: '17 out of 25 trades',
        isPositive: true,
      ),
    ];
  }

  static List<TradeRecord> getTradeHistory() {
    return [
      TradeRecord(
        date: 'Jan 15',
        action: 'Buy',
        symbol: 'AAPL',
        price: '\$172.50',
        isBuy: true,
      ),
      TradeRecord(
        date: 'Feb 03',
        action: 'Buy',
        symbol: 'MSFT',
        price: '\$305.24',
        isBuy: true,
      ),
      TradeRecord(
        date: 'Feb 28',
        action: 'Sell',
        symbol: 'AAPL',
        price: '\$189.12',
        isBuy: false,
      ),
    ];
  }
}