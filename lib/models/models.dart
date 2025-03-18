// Models for the app data




import 'package:flutter/material.dart';

class Alert {
  final int id;
  final String symbol;
  final String action;
  final String price;
  final String change;

  Alert({
    required this.id,
    required this.symbol,
    required this.action,
    required this.price,
    required this.change,
  });
}

class ArenaPerformance {
  final int id;
  final String challenge;
  final String rank;
  final String returns;
  final int participants;

  ArenaPerformance({
    required this.id,
    required this.challenge,
    required this.rank,
    required this.returns,
    required this.participants,
  });
}

class Competition {
  final int id;
  final String name;
  final String starts;
  final int participants;

  Competition({
    required this.id,
    required this.name,
    required this.starts,
    required this.participants,
  });
}

class QuantAgent {
  final int id;
  final String name;
  final String performance;

  QuantAgent({
    required this.id,
    required this.name,
    required this.performance,
  });
}

class TabItem {
  final String id;
  final IconData icon;
  final String label;

  TabItem({
    required this.id,
    required this.icon,
    required this.label,
  });
}