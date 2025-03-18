// data/security_data.dart
import 'package:theo/models/security_models.dart';

class SecurityData {
  static List<Security> getBasketSecurities() {
    return [
      Security(
        id: 1,
        symbol: 'AAPL',
        name: 'Apple Inc.',
        sector: 'Technology',
        price: 172.28,
        change: 1.25,
        weight: 20,
      ),
      Security(
        id: 2,
        symbol: 'MSFT',
        name: 'Microsoft Corp',
        sector: 'Technology',
        price: 328.87,
        change: 2.6,
        weight: 20,
      ),
      Security(
        id: 3,
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        sector: 'Technology',
        price: 145.72,
        change: -0.8,
        weight: 15,
      ),
      Security(
        id: 4,
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        sector: 'Consumer Cyclical',
        price: 178.35,
        change: 1.05,
        weight: 15,
      ),
      Security(
        id: 5,
        symbol: 'NVDA',
        name: 'NVIDIA Corporation',
        sector: 'Technology',
        price: 884.18,
        change: 12.3,
        weight: 15,
      ),
      Security(
        id: 6,
        symbol: 'META',
        name: 'Meta Platforms Inc.',
        sector: 'Communication Services',
        price: 485.92,
        change: -2.15,
        weight: 15,
      ),
    ];
  }

  static List<Security> searchSecurities(String query) {
    if (query.isEmpty) return [];
    
    // This is just dummy data for the search functionality
    return [
      Security(
        id: 7,
        symbol: 'AMD',
        name: 'Advanced Micro Devices, Inc.',
        sector: 'Technology',
        price: 157.20,
        change: 3.2,
      ),
      Security(
        id: 8,
        symbol: 'INTC',
        name: 'Intel Corporation',
        sector: 'Technology',
        price: 42.35,
        change: -0.62,
      ),
      Security(
        id: 9,
        symbol: 'CRM',
        name: 'Salesforce, Inc.',
        sector: 'Technology',
        price: 277.12,
        change: 1.9,
      ),
    ];
  }
}