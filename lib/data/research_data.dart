// data/research_data.dart
import 'package:flutter/material.dart';
import 'package:theo/models/research_models.dart';

class ResearchData {
  // Research tabs
  static List<ResearchTab> getTabs() {
    return [
      ResearchTab(
        id: 'deep-analysis',
        name: 'Deep Analysis',
        icon: Icons.trending_up,
      ),
      ResearchTab(
        id: 'stock-ranker',
        name: 'Stock Ranker',
        icon: Icons.bar_chart,
      ),
      ResearchTab(
        id: 'options-ranker',
        name: 'Options Ranker',
        icon: Icons.show_chart,
      ),
      ResearchTab(
        id: 'sector-ranker',
        name: 'Sector Ranker',
        icon: Icons.pie_chart,
      ),
      ResearchTab(
        id: 'etf-ranker',
        name: 'ETF Ranker',
        icon: Icons.business_center,
      ),
    ];
  }

  // Stock data for ranker
  static List<Stock> getStocks() {
    return [
      Stock(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        price: 242.92,
        change: 5.32,
        percentChange: 2.24,
        score: 87,
      ),
      Stock(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        price: 182.63,
        change: -0.87,
        percentChange: -0.47,
        score: 92,
      ),
      Stock(
        symbol: 'MSFT',
        name: 'Microsoft Corp.',
        price: 415.33,
        change: 2.11,
        percentChange: 0.51,
        score: 95,
      ),
      Stock(
        symbol: 'NVDA',
        name: 'NVIDIA Corp.',
        price: 950.02,
        change: 15.73,
        percentChange: 1.68,
        score: 98,
      ),
      Stock(
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        price: 178.22,
        change: -1.34,
        percentChange: -0.75,
        score: 89,
      ),
      Stock(
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        price: 163.45,
        change: 0.78,
        percentChange: 0.48,
        score: 91,
      ),
    ];
  }

  // Options data for ranker
  static List<Option> getOptions() {
    return [
      Option(
        rank: 1,
        symbol: 'TSLA',
        type: 'Call',
        strike: '\$250',
        expDate: 'Mar 21, 2025',
        premium: '\$12.45',
        probability: '68%',
        score: 94,
      ),
      Option(
        rank: 2,
        symbol: 'AAPL',
        type: 'Put',
        strike: '\$175',
        expDate: 'Mar 28, 2025',
        premium: '\$5.80',
        probability: '72%',
        score: 91,
      ),
      Option(
        rank: 3,
        symbol: 'AMZN',
        type: 'Call',
        strike: '\$180',
        expDate: 'Apr 4, 2025',
        premium: '\$8.65',
        probability: '64%',
        score: 89,
      ),
      Option(
        rank: 4,
        symbol: 'NVDA',
        type: 'Call',
        strike: '\$975',
        expDate: 'Mar 21, 2025',
        premium: '\$32.50',
        probability: '59%',
        score: 87,
      ),
      Option(
        rank: 5,
        symbol: 'META',
        type: 'Put',
        strike: '\$480',
        expDate: 'Mar 28, 2025',
        premium: '\$14.20',
        probability: '63%',
        score: 85,
      ),
    ];
  }

  // Sector data for ranker
  static List<Sector> getSectors() {
    return [
      Sector(
        rank: 1,
        name: 'Technology',
        oneWeek: '+2.8%',
        oneMonth: '+7.4%',
        threeMonth: '+12.5%',
        ytd: '+15.3%',
        score: 94,
        color: Colors.blue,
        performance: 15.3,
      ),
      Sector(
        rank: 2,
        name: 'Energy',
        oneWeek: '+1.9%',
        oneMonth: '+5.2%',
        threeMonth: '+8.7%',
        ytd: '+10.2%',
        score: 89,
        color: Colors.green,
        performance: 10.2,
      ),
      Sector(
        rank: 3,
        name: 'Healthcare',
        oneWeek: '+1.2%',
        oneMonth: '+3.8%',
        threeMonth: '+6.3%',
        ytd: '+9.7%',
        score: 86,
        color: Colors.purple,
        performance: 9.7,
      ),
      Sector(
        rank: 4,
        name: 'Financials',
        oneWeek: '+0.8%',
        oneMonth: '+2.9%',
        threeMonth: '+5.1%',
        ytd: '+7.8%',
        score: 82,
        color: Colors.orange,
        performance: 7.8,
      ),
      Sector(
        rank: 5,
        name: 'Consumer',
        oneWeek: '+0.3%',
        oneMonth: '+1.6%',
        threeMonth: '+4.2%',
        ytd: '+6.5%',
        score: 78,
        color: Colors.red,
        performance: 6.5,
      ),
      Sector(
        rank: 6,
        name: 'Industrials',
        oneWeek: '-0.2%',
        oneMonth: '+1.1%',
        threeMonth: '+3.6%',
        ytd: '+5.3%',
        score: 74,
        color: Colors.grey,
        performance: 5.3,
      ),
      Sector(
        rank: 7,
        name: 'Materials',
        oneWeek: '-0.5%',
        oneMonth: '+0.8%',
        threeMonth: '+2.7%',
        ytd: '+4.1%',
        score: 69,
        color: Colors.cyan,
        performance: 4.1,
      ),
    ];
  }

  // ETF data for ranker
  static List<ETF> getETFs() {
    return [
      ETF(
        rank: 1,
        symbol: 'QQQ',
        name: 'Invesco QQQ Trust',
        category: 'US Equity',
        aum: '\$245.8B',
        ytdReturn: '+16.8%',
        expenseRatio: '0.20%',
        score: 96,
      ),
      ETF(
        rank: 2,
        symbol: 'SPY',
        name: 'SPDR S&P 500 ETF',
        category: 'US Equity',
        aum: '\$489.2B',
        ytdReturn: '+10.3%',
        expenseRatio: '0.09%',
        score: 93,
      ),
      ETF(
        rank: 3,
        symbol: 'XLK',
        name: 'Technology Select Sector SPDR',
        category: 'Sector',
        aum: '\$58.6B',
        ytdReturn: '+15.7%',
        expenseRatio: '0.10%',
        score: 91,
      ),
      ETF(
        rank: 4,
        symbol: 'VTI',
        name: 'Vanguard Total Stock Market ETF',
        category: 'US Equity',
        aum: '\$352.4B',
        ytdReturn: '+9.8%',
        expenseRatio: '0.03%',
        score: 89,
      ),
      ETF(
        rank: 5,
        symbol: 'ARKK',
        name: 'ARK Innovation ETF',
        category: 'US Equity',
        aum: '\$7.2B',
        ytdReturn: '+28.5%',
        expenseRatio: '0.75%',
        score: 86,
      ),
    ];
  }

  // Tesla stock chart data
  static List<ChartPoint> getTeslaChartPoints() {
    return [
      ChartPoint(x: 50, y: 150),
      ChartPoint(x: 108, y: 140),
      ChartPoint(x: 166, y: 160),
      ChartPoint(x: 224, y: 170),
      ChartPoint(x: 282, y: 145),
      ChartPoint(x: 340, y: 120),
      ChartPoint(x: 398, y: 100),
      ChartPoint(x: 456, y: 125),
      ChartPoint(x: 514, y: 150),
      ChartPoint(x: 572, y: 130),
      ChartPoint(x: 630, y: 90),
      ChartPoint(x: 688, y: 110),
      ChartPoint(x: 746, y: 70),
    ];
  }

  // Insights for Tesla stock
  static List<StockInsight> getTeslaInsights() {
    return [
      StockInsight(
        title: 'Strong Product Pipeline',
        description: 'Tesla\'s upcoming product releases including the Cybertruck and advances in Full Self-Driving technology position the company for potential growth.',
        borderColor: Colors.blue,
        backgroundColor: Colors.blue.shade50,
      ),
      StockInsight(
        title: 'Increased Competition',
        description: 'Traditional automakers are accelerating their EV strategies, potentially eroding Tesla\'s first-mover advantage in key markets.',
        borderColor: Colors.amber,
        backgroundColor: Colors.amber.shade50,
      ),
      StockInsight(
        title: 'Energy Business Expansion',
        description: 'Tesla\'s energy storage business shows promising growth potential with increased adoption of Powerwall and utility-scale solutions.',
        borderColor: Colors.green,
        backgroundColor: Colors.green.shade50,
      ),
    ];
  }
}