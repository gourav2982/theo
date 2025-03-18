import 'package:flutter/material.dart';
import 'package:theo/models/learning_models.dart';

class LearningData {
  // Featured courses
  static List<Course> featuredCourses = [
    Course(
      id: 1,
      title: 'Beginner\'s Guide to Stock Market',
      duration: '45 min',
      level: 'Beginner',
      completed: '0%',
    ),
    Course(
      id: 2,
      title: 'Technical Analysis Fundamentals',
      duration: '1h 20m',
      level: 'Intermediate',
      completed: '35%',
    ),
    Course(
      id: 3,
      title: 'Understanding Market Sentiment',
      duration: '55 min',
      level: 'Intermediate',
      completed: '0%',
    ),
  ];

  // Learning categories
  static List<LearningCategory> learningCategories = [
    LearningCategory(
      id: 1,
      icon: Icons.trending_up,
      title: 'Trading Strategies',
      description: 'Learn different approaches to trading',
      count: 12,
    ),
    LearningCategory(
      id: 2,
      icon: Icons.bar_chart,
      title: 'Indicators',
      description: 'Master technical indicators',
      count: 18,
    ),
    LearningCategory(
      id: 3,
      icon: Icons.pie_chart,
      title: 'Investment Securities',
      description: 'Understand different investment types',
      count: 8,
    ),
    LearningCategory(
      id: 4,
      icon: Icons.attach_money,
      title: 'Risk Management',
      description: 'Protect your investment capital',
      count: 6,
    ),
    LearningCategory(
      id: 5,
      icon: Icons.book,
      title: 'Market Fundamentals',
      description: 'Economic principles and market mechanics',
      count: 9,
    ),
  ];

  // Recent articles
  static List<Article> recentArticles = [
    Article(
      id: 1,
      title: 'How to Spot Market Reversals Early',
      readTime: '5 min',
      date: 'Mar 10, 2025',
    ),
    Article(
      id: 2,
      title: 'Understanding Price-to-Earnings Ratio',
      readTime: '7 min',
      date: 'Mar 8, 2025',
    ),
    Article(
      id: 3,
      title: 'Algorithmic Trading for Beginners',
      readTime: '12 min',
      date: 'Mar 5, 2025',
    ),
  ];

  // Popular courses
  static List<PopularCourse> popularCourses = [
    PopularCourse(
      id: 1,
      title: 'Options Trading Mastery',
      students: '2,450',
      rating: '4.9',
      instructor: 'Michael Chen',
    ),
    PopularCourse(
      id: 2,
      title: 'Fundamental Analysis Deep Dive',
      students: '1,875',
      rating: '4.7',
      instructor: 'Sarah Johnson',
    ),
    PopularCourse(
      id: 3,
      title: 'Crypto Trading Essentials',
      students: '3,120',
      rating: '4.8',
      instructor: 'Alex Rivera',
    ),
  ];
}