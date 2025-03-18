import 'package:flutter/material.dart';
import 'package:theo/models/models.dart';

class DummyData {
  // Alert data
  static List<Alert> alerts = [
    Alert(id: 1, symbol: 'TSLA', action: 'BUY', price: '\$242.56', change: '+2.3%'),
    Alert(id: 2, symbol: 'AAPL', action: 'SELL', price: '\$178.22', change: '-1.2%'),
    Alert(id: 3, symbol: 'NVDA', action: 'BUY', price: '\$845.78', change: '+3.7%'),
  ];

  // Arena Performance data
  static List<ArenaPerformance> arenaPerformance = [
    ArenaPerformance(
      id: 1, 
      challenge: 'Tech Titans', 
      rank: '3rd', 
      returns: '+8.2%', 
      participants: 128
    ),
    ArenaPerformance(
      id: 2, 
      challenge: 'Crypto Kings', 
      rank: '12th', 
      returns: '+4.7%', 
      participants: 86
    ),
  ];

  // Upcoming Competitions data
  static List<Competition> upcomingCompetitions = [
    Competition(
      id: 1, 
      name: 'S&P 500 Masters', 
      starts: '2h 15m', 
      participants: 78
    ),
    Competition(
      id: 2, 
      name: 'AI Revolution', 
      starts: '1d 4h', 
      participants: 124
    ),
    Competition(
      id: 3, 
      name: 'Green Energy', 
      starts: '2d 12h', 
      participants: 56
    ),
  ];

  // Quant Agents data
  static List<QuantAgent> quantAgents = [
    QuantAgent(id: 1, name: 'Sector Rotation ETFs', performance: '+5.2%'),
    QuantAgent(id: 2, name: 'S&P 500', performance: '+2.7%'),
    QuantAgent(id: 3, name: 'Tech Focus', performance: '+8.4%'),
  ];

  // Tab items
  static List<TabItem> tabs = [
    TabItem(id: 'home', icon: Icons.home, label: 'Home'),
    TabItem(id: 'learning', icon: Icons.book, label: 'Learning'),
    TabItem(id: 'tools', icon: Icons.bar_chart, label: 'Tools'),
    TabItem(id: 'research', icon: Icons.show_chart, label: 'Research'),
    TabItem(id: 'arena', icon: Icons.emoji_events, label: 'Arena'),
  ];
}