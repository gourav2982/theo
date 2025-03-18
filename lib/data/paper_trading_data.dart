// data/paper_trading_data.dart
import 'package:theo/models/paper_trading_portfolio_models.dart';

class PaperTradingData {
  static List<PaperTradingPortfolio> getMockPortfolios() {
    return [
      PaperTradingPortfolio(
        id: 1, 
        name: 'Tech Growth Portfolio', 
        startDate: '2024-02-15', 
        duration: '3m', 
        strategy: 'Momentum', 
        initialBalance: 25000,
        currentBalance: 27450,
        returnPercentage: 9.8,
        status: 'active'
      ),
      PaperTradingPortfolio(
        id: 2, 
        name: 'S&P 500 Value Play', 
        startDate: '2024-01-10', 
        duration: '6m', 
        strategy: 'Value Investing', 
        initialBalance: 10000,
        currentBalance: 10680,
        returnPercentage: 6.8,
        status: 'active'
      ),
      PaperTradingPortfolio(
        id: 3, 
        name: 'Short-term Trading Test', 
        startDate: '2024-03-01', 
        duration: '20d', 
        strategy: 'Mean Reversion', 
        initialBalance: 5000,
        currentBalance: 5325,
        returnPercentage: 6.5,
        status: 'active'
      ),
      PaperTradingPortfolio(
        id: 4, 
        name: 'Dividend Portfolio', 
        startDate: '2023-12-15', 
        duration: '1y', 
        strategy: 'Income', 
        initialBalance: 15000,
        currentBalance: 15870,
        returnPercentage: 5.8,
        status: 'active'
      ),
      PaperTradingPortfolio(
        id: 5, 
        name: 'Swing Trading', 
        startDate: '2024-02-01', 
        duration: '1m', 
        strategy: 'Trend Following', 
        initialBalance: 10000,
        currentBalance: 9760,
        returnPercentage: -2.4,
        status: 'completed'
      ),
    ];
  }

  static PortfolioData getMockPortfolioData() {
    return PortfolioData(
      accountValue: 25648.72,
      initialBalance: 25000,
      buyingPower: 12500.45,
      dailyChange: 213.45,
      dailyChangePercent: 0.84,
      totalGain: 648.72,
      totalGainPercent: 2.59,
    );
  }

  static List<Position> getMockPositions() {
    return [
      Position(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        shares: 10,
        avgPrice: 177.25,
        currentPrice: 182.52,
        value: 1825.20,
        gain: 52.70,
        gainPercent: 2.97,
      ),
      Position(
        symbol: 'MSFT',
        name: 'Microsoft Corp',
        shares: 5,
        avgPrice: 328.15,
        currentPrice: 335.60,
        value: 1678.00,
        gain: 37.25,
        gainPercent: 2.27,
      ),
      Position(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        shares: 8,
        avgPrice: 210.74,
        currentPrice: 201.38,
        value: 1611.04,
        gain: -74.88,
        gainPercent: -4.44,
      ),
      Position(
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        shares: 12,
        avgPrice: 142.32,
        currentPrice: 145.10,
        value: 1741.20,
        gain: 33.36,
        gainPercent: 1.95,
      ),
    ];
  }

  static List<StockOrder> getMockOrders() {
    return [
      StockOrder(
        id: 1,
        date: '2024-03-12',
        time: '10:32 AM',
        symbol: 'AAPL',
        type: 'Buy',
        status: 'Filled',
        quantity: 5,
        price: 177.25,
        total: 886.25,
      ),
      StockOrder(
        id: 2,
        date: '2024-03-11',
        time: '2:45 PM',
        symbol: 'MSFT',
        type: 'Buy',
        status: 'Filled',
        quantity: 3,
        price: 328.15,
        total: 984.45,
      ),
      StockOrder(
        id: 3,
        date: '2024-03-10',
        time: '11:20 AM',
        symbol: 'TSLA',
        type: 'Sell',
        status: 'Filled',
        quantity: 2,
        price: 215.50,
        total: 431.00,
      ),
      StockOrder(
        id: 4,
        date: '2024-03-13',
        time: '9:15 AM',
        symbol: 'NVDA',
        type: 'Buy',
        status: 'Pending',
        quantity: 2,
        price: 885.00,
        total: 1770.00,
      ),
    ];
  }

  static List<WatchlistItem> getMockWatchlist() {
    return [
      WatchlistItem(
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        price: 178.75,
        change: 2.54,
        changePercent: 1.44,
      ),
      WatchlistItem(
        symbol: 'META',
        name: 'Meta Platforms Inc.',
        price: 485.39,
        change: -3.21,
        changePercent: -0.66,
      ),
      WatchlistItem(
        symbol: 'NVDA',
        name: 'NVIDIA Corporation',
        price: 884.15,
        change: 12.78,
        changePercent: 1.47,
      ),
      WatchlistItem(
        symbol: 'JPM',
        name: 'JPMorgan Chase & Co.',
        price: 187.92,
        change: 0.45,
        changePercent: 0.24,
      ),
    ];
  }
}