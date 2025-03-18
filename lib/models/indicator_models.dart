// models/indicator.dart
class Indicator {
  final int id;
  final String name;
  final String type;
  final String category;
  final String dateModified;
  final int usedIn;
  final bool favorite;
  final String description;

  Indicator({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.dateModified,
    required this.usedIn,
    required this.favorite,
    required this.description,
  });
}

class IndicatorTemplate {
  final String id;
  final String name;
  final IconType iconType;
  final String colorClass;

  IndicatorTemplate({
    required this.id,
    required this.name,
    required this.iconType,
    required this.colorClass,
  });
}

enum IconType {
  activity,
  trendingUp,
  zap,
  barChart,
}