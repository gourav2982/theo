// models/research_models.dart
import 'package:flutter/material.dart';

// Tab model for research categories
class ResearchTab {
  final String id;
  final String name;
  final IconData icon;

  ResearchTab({
    required this.id,
    required this.name,
    required this.icon,
  });
}

// Stock model for stock ranker
class Stock {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double percentChange;
  final int score;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.percentChange,
    required this.score,
  });
}

// Option model for options ranker
class Option {
  final int rank;
  final String symbol;
  final String type;
  final String strike;
  final String expDate;
  final String premium;
  final String probability;
  final int score;

  Option({
    required this.rank,
    required this.symbol,
    required this.type,
    required this.strike,
    required this.expDate,
    required this.premium,
    required this.probability,
    required this.score,
  });
}

// Sector model for sector ranker
class Sector {
  final int rank;
  final String name;
  final String oneWeek;
  final String oneMonth;
  final String threeMonth;
  final String ytd;
  final int score;
  final Color color;
  final double performance;

  Sector({
    required this.rank,
    required this.name,
    required this.oneWeek,
    required this.oneMonth,
    required this.threeMonth,
    required this.ytd,
    required this.score,
    required this.color,
    required this.performance,
  });
}

// ETF model for ETF ranker
class ETF {
  final int rank;
  final String symbol;
  final String name;
  final String category;
  final String aum;
  final String ytdReturn;
  final String expenseRatio;
  final int score;

  ETF({
    required this.rank,
    required this.symbol,
    required this.name,
    required this.category,
    required this.aum,
    required this.ytdReturn,
    required this.expenseRatio,
    required this.score,
  });
}

// Stock insight model for deep analysis
class StockInsight {
  final String title;
  final String description;
  final Color borderColor;
  final Color backgroundColor;

  StockInsight({
    required this.title,
    required this.description,
    required this.borderColor,
    required this.backgroundColor,
  });
}

// Point model for chart data
class ChartPoint {
  final double x;
  final double y;

  ChartPoint({required this.x, required this.y});
}