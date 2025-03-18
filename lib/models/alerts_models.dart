// models/alert_models.dart

class WatchlistItem {
  final int id;
  final String name;
  final String basket;
  final String strategy;
  final bool active;
  final String lastAlert;

  WatchlistItem({
    required this.id,
    required this.name,
    required this.basket,
    required this.strategy,
    required this.active,
    required this.lastAlert,
  });
}

class SubscriptionAlert {
  final int id;
  final String type; // 'subscribed' or 'available'
  final String name;
  final String description;
  final double price;
  final int subscribers;
  final String category;

  SubscriptionAlert({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.subscribers,
    required this.category,
  });
}

// For the edit watchlist screen
class Basket {
  final String id;
  final String name;
  
  Basket({required this.id, required this.name});
}

class Strategy {
  final String id;
  final String name;
  
  Strategy({required this.id, required this.name});
}

class AlertCondition {
  final int id;
  final String type;
  bool enabled;
  
  AlertCondition({
    required this.id,
    required this.type,
    required this.enabled,
  });
}

class AlertDelivery {
  bool email;
  bool sms;
  bool app;
  bool whatsapp;
  
  AlertDelivery({
    required this.email,
    required this.sms,
    required this.app,
    required this.whatsapp,
  });
}