// Models for the learning center

import 'package:flutter/material.dart';

class Course {
  final int id;
  final String title;
  final String duration;
  final String level;
  final String completed;

  Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.level,
    required this.completed,
  });
}

class PopularCourse {
  final int id;
  final String title;
  final String students;
  final String rating;
  final String instructor;

  PopularCourse({
    required this.id,
    required this.title,
    required this.students,
    required this.rating,
    required this.instructor,
  });
}

class LearningCategory {
  final int id;
  final IconData icon;
  final String title;
  final String description;
  final int count;

  LearningCategory({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.count,
  });
}

class Article {
  final int id;
  final String title;
  final String readTime;
  final String date;

  Article({
    required this.id,
    required this.title,
    required this.readTime,
    required this.date,
  });
}