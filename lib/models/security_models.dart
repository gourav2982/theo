// models/security_model.dart

class Security {
  final int id;
  final String symbol;
  final String name;
  final String sector;
  final double price;
  final double change;
  int weight;

  Security({
    required this.id,
    required this.symbol,
    required this.name,
    required this.sector,
    required this.price,
    required this.change,
    this.weight = 0,
  });
}