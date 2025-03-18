import 'package:theo/models/backtest_models.dart';

class BacktestData {
  static List<Backtest> getBacktestHistory() {
    return [
      Backtest(
        id: 1, 
        name: 'Momentum Strategy - Tech Sector', 
        date: '2024-03-10', 
        strategy: 'Momentum', 
        basket: 'Tech Sector', 
        period: '3 months',
        returnPercent: 14.5,
        benchmark: 8.2,
        status: BacktestStatus.completed,
      ),
      Backtest(
        id: 2, 
        name: 'Value Investing - S&P 500', 
        date: '2024-03-05', 
        strategy: 'Value Investing', 
        basket: 'S&P 500', 
        period: '6 months',
        returnPercent: 9.8,
        benchmark: 7.5,
        status: BacktestStatus.completed,
      ),
      Backtest(
        id: 3, 
        name: 'Mean Reversion - Finance Sector', 
        date: '2024-02-28', 
        strategy: 'Mean Reversion', 
        basket: 'Finance', 
        period: '1 year',
        returnPercent: -2.3,
        benchmark: 4.1,
        status: BacktestStatus.completed,
      ),
      Backtest(
        id: 4, 
        name: 'Trend Following - Nasdaq 100', 
        date: '2024-02-15', 
        strategy: 'Trend Following', 
        basket: 'Nasdaq 100', 
        period: '2 months',
        returnPercent: 12.2,
        benchmark: 5.7,
        status: BacktestStatus.completed,
      ),
      Backtest(
        id: 5, 
        name: 'Custom Strategy Test', 
        date: '2024-03-12', 
        strategy: 'Custom', 
        basket: 'My Technology Basket', 
        period: '3 months',
        returnPercent: null,
        benchmark: null,
        status: BacktestStatus.inProgress,
      ),
    ];
  }
}