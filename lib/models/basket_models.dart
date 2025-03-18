// models/basket_model.dart
import 'package:flutter/material.dart';

class Basket {
  final int id;
  final String name;
  final String type;
  final String dateCreated;
  final String dateModified;
  final int securities;
  final double performance1m;
  final bool favorite;

  Basket({
    required this.id,
    required this.name,
    required this.type,
    required this.dateCreated,
    required this.dateModified,
    required this.securities,
    required this.performance1m,
    required this.favorite,
  });
}

class BasketTemplate {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  BasketTemplate({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}