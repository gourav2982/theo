// data/alert_data.dart
import 'package:theo/models/alerts_models.dart';

class AlertData {
  // Mock data for watchlist
  static List<WatchlistItem> getWatchlistItems() {
    return [
      WatchlistItem(
        id: 1,
        name: 'Tech Growth Portfolio',
        basket: 'Tech Sector ETFs',
        strategy: 'Momentum Strategy',
        active: true,
        lastAlert: '2024-03-12',
      ),
      WatchlistItem(
        id: 2,
        name: 'Dividend Picks',
        basket: 'Dividend Aristocrats',
        strategy: 'Value Investing',
        active: true,
        lastAlert: '2024-03-10',
      ),
      WatchlistItem(
        id: 3,
        name: 'S&P 500 Tracker',
        basket: 'S&P 500',
        strategy: 'Mean Reversion',
        active: false,
        lastAlert: '2024-02-28',
      ),
      WatchlistItem(
        id: 4,
        name: 'Crypto Alert',
        basket: 'Top 10 Cryptocurrencies',
        strategy: 'Trend Following',
        active: true,
        lastAlert: '2024-03-13',
      ),
    ];
  }

  // Mock data for alerts
  static List<SubscriptionAlert> getSubscriptionAlerts() {
    return [
      SubscriptionAlert(
        id: 1,
        type: 'subscribed',
        name: 'Daily Market Open',
        description: 'Alerts at market open with key stocks to watch',
        price: 0,
        subscribers: 15420,
        category: 'Market Timing',
      ),
      SubscriptionAlert(
        id: 2,
        type: 'subscribed',
        name: 'Weekly Option Picks',
        description: 'High probability option trades delivered every Monday',
        price: 5,
        subscribers: 8750,
        category: 'Options',
      ),
      SubscriptionAlert(
        id: 3,
        type: 'available',
        name: 'Earnings Volatility',
        description: 'Alerts for stocks with upcoming earnings that show unusual options activity',
        price: 5,
        subscribers: 6240,
        category: 'Earnings',
      ),
      SubscriptionAlert(
        id: 4,
        type: 'available',
        name: 'Analyst Rating Changes',
        description: 'Alerts when major analysts upgrade or downgrade significant stocks',
        price: 3,
        subscribers: 12800,
        category: 'Fundamental',
      ),
      SubscriptionAlert(
        id: 5,
        type: 'available',
        name: 'Momentum Breakouts',
        description: 'Technical alerts for stocks breaking out of consolidation patterns',
        price: 3,
        subscribers: 9350,
        category: 'Technical',
      ),
    ];
  }
  
  // Mock data for baskets
  static List<Basket> getBaskets() {
    return [
      Basket(id: 'tech-sector', name: 'Tech Sector ETFs'),
      Basket(id: 'sp500', name: 'S&P 500'),
      Basket(id: 'dividend', name: 'Dividend Aristocrats'),
      Basket(id: 'crypto', name: 'Top 10 Cryptocurrencies'),
      Basket(id: 'nasdaq', name: 'Nasdaq 100'),
      Basket(id: 'custom-tech', name: 'My Tech Stocks (Custom)'),
    ];
  }
  
  // Mock data for strategies
  static List<Strategy> getStrategies() {
    return [
      Strategy(id: 'momentum', name: 'Momentum Strategy'),
      Strategy(id: 'value', name: 'Value Investing'),
      Strategy(id: 'mean-reversion', name: 'Mean Reversion'),
      Strategy(id: 'trend-following', name: 'Trend Following'),
      Strategy(id: 'custom-strategy', name: 'My Custom Strategy'),
    ];
  }
  
  // Mock data for alert conditions
  static List<AlertCondition> getAlertConditions() {
    return [
      AlertCondition(id: 1, type: 'Buy Signal', enabled: true),
      AlertCondition(id: 2, type: 'Sell Signal', enabled: true),
      AlertCondition(id: 3, type: 'Stop Loss', enabled: true),
      AlertCondition(id: 4, type: 'Take Profit', enabled: false),
      AlertCondition(id: 5, type: 'Portfolio Update', enabled: true),
    ];
  }
  
  // Mock data for alert delivery settings
  static AlertDelivery getAlertDelivery() {
    return AlertDelivery(
      email: true,
      sms: true,
      app: true,
      whatsapp: false,
    );
  }
  
  // Get watchlist item by ID
  static WatchlistItem? getWatchlistItemById(int id) {
    try {
      return getWatchlistItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}