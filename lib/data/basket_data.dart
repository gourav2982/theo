// data/basket_data.dart
import 'package:flutter/material.dart';
import 'package:theo/models/basket_models.dart';

class BasketData {
  static List<Basket> getBaskets() {
    return [
      Basket(
        id: 1, 
        name: 'Tech Leaders', 
        type: 'Custom',
        dateCreated: '2024-02-15', 
        dateModified: '2024-03-10',
        securities: 8,
        performance1m: 5.2,
        favorite: true,
      ),
      Basket(
        id: 2, 
        name: 'S&P 500', 
        type: 'Predefined',
        dateCreated: '2024-01-20', 
        dateModified: '2024-03-01',
        securities: 500,
        performance1m: 2.8,
        favorite: true,
      ),
      Basket(
        id: 3, 
        name: 'Dividend Income', 
        type: 'Custom',
        dateCreated: '2024-02-25', 
        dateModified: '2024-03-12',
        securities: 12,
        performance1m: 1.7,
        favorite: false,
      ),
      Basket(
        id: 4, 
        name: 'Growth ETFs', 
        type: 'Custom',
        dateCreated: '2024-01-05', 
        dateModified: '2024-02-18',
        securities: 5,
        performance1m: 4.3,
        favorite: false,
      ),
      Basket(
        id: 5, 
        name: 'Crypto Top 10', 
        type: 'Predefined',
        dateCreated: '2024-03-01', 
        dateModified: '2024-03-05',
        securities: 10,
        performance1m: -3.2,
        favorite: false,
      ),
    ];
  }

  static List<BasketTemplate> getBasketTemplates() {
    return [
      BasketTemplate(
        id: 'tech',
        name: 'Technology',
        icon: Icons.bar_chart,
        iconColor: Colors.blue.shade600,
        backgroundColor: Colors.blue.shade100,
      ),
      BasketTemplate(
        id: 'finance',
        name: 'Financial',
        icon: Icons.attach_money,
        iconColor: Colors.green.shade600,
        backgroundColor: Colors.green.shade100,
      ),
      BasketTemplate(
        id: 'dividend',
        name: 'Dividend',
        icon: Icons.pie_chart,
        iconColor: Colors.purple.shade600,
        backgroundColor: Colors.purple.shade100,
      ),
      BasketTemplate(
        id: 'growth',
        name: 'Growth',
        icon: Icons.trending_up,
        iconColor: Colors.indigo.shade600,
        backgroundColor: Colors.indigo.shade100,
      ),
    ];
  }
}