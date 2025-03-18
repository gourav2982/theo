import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/screens/chat_screen.dart';

class OrdersScreen extends StatefulWidget {
  final Map<String, dynamic>? challengeData;

  const OrdersScreen({
    Key? key,
    this.challengeData,
  }) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filterType = 'all';
  String _sortOrder = 'newest';
  bool _showFilters = false;

  // Sample challenge data
  late final Map<String, dynamic> _challenge;

  // Sample orders data (only user's own orders)
  final List<Map<String, dynamic>> _myOrders = [
    { 'id': 1, 'symbol': 'AAPL', 'action': 'buy', 'shares': 10, 'price': 187.42, 'total': 1874.20, 'time': '10:32 AM', 'date': 'Mar 13', 'status': 'executed' },
    { 'id': 2, 'symbol': 'MSFT', 'action': 'sell', 'shares': 5, 'price': 423.18, 'total': 2115.90, 'time': '11:45 AM', 'date': 'Mar 13', 'status': 'executed' },
    { 'id': 3, 'symbol': 'GOOGL', 'action': 'buy', 'shares': 6, 'price': 152.38, 'total': 914.28, 'time': '2:15 PM', 'date': 'Mar 13', 'status': 'executed' },
    { 'id': 4, 'symbol': 'NVDA', 'action': 'buy', 'shares': 4, 'price': 930.25, 'total': 3721.00, 'time': '3:05 PM', 'date': 'Mar 13', 'status': 'pending' },
    { 'id': 5, 'symbol': 'AMZN', 'action': 'buy', 'shares': 3, 'price': 179.50, 'total': 538.50, 'time': '9:45 AM', 'date': 'Mar 12', 'status': 'executed' },
    { 'id': 6, 'symbol': 'META', 'action': 'sell', 'shares': 2, 'price': 485.20, 'total': 970.40, 'time': '1:30 PM', 'date': 'Mar 12', 'status': 'executed' },
    { 'id': 7, 'symbol': 'JPM', 'action': 'buy', 'shares': 8, 'price': 197.35, 'total': 1578.80, 'time': '10:15 AM', 'date': 'Mar 11', 'status': 'executed' },
    { 'id': 8, 'symbol': 'TSLA', 'action': 'buy', 'shares': 5, 'price': 177.80, 'total': 889.00, 'time': '2:50 PM', 'date': 'Mar 11', 'status': 'cancelled' },
  ];

  @override
  void initState() {
    super.initState();

    // Use provided challenge data or default
    _challenge = widget.challengeData ?? {
      'name': "S&P 500 Weekly Challenge",
      'participants': 142,
      'endDate': "Mar 20, 2025"
    };
  }

  // Filter orders based on the selected filter type
  List<Map<String, dynamic>> _getFilteredOrders() {
    List<Map<String, dynamic>> filtered = List.from(_myOrders);
    
    if (_filterType == 'buy') {
      filtered = filtered.where((order) => order['action'] == 'buy').toList();
    } else if (_filterType == 'sell') {
      filtered = filtered.where((order) => order['action'] == 'sell').toList();
    } else if (_filterType == 'pending') {
      filtered = filtered.where((order) => order['status'] == 'pending').toList();
    } else if (_filterType == 'executed') {
      filtered = filtered.where((order) => order['status'] == 'executed').toList();
    } else if (_filterType == 'cancelled') {
      filtered = filtered.where((order) => order['status'] == 'cancelled').toList();
    }
    
    // Sort the orders
    if (_sortOrder == 'newest') {
      // For simplicity, we'll assume the array is already sorted by newest first
    } else if (_sortOrder == 'oldest') {
      filtered = filtered.reversed.toList();
    } else if (_sortOrder == 'highest') {
      filtered.sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));
    } else if (_sortOrder == 'lowest') {
      filtered.sort((a, b) => (a['total'] as double).compareTo(b['total'] as double));
    }
    
    return filtered;
  }

  // Group orders by date
  Map<String, List<Map<String, dynamic>>> _groupOrdersByDate(List<Map<String, dynamic>> orders) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    
    for (var order in orders) {
      final date = order['date'] as String;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(order);
    }
    
    return grouped;
  }

  // Get order summary
  Map<String, dynamic> _getOrderSummary() {
    final totalBuy = _myOrders
        .where((order) => order['action'] == 'buy' && order['status'] == 'executed')
        .fold<double>(0.0, (sum, order) => sum + ((order['total'] as double?) ?? 0.0));
    
    final totalSell = _myOrders
        .where((order) => order['action'] == 'sell' && order['status'] == 'executed')
        .fold<double>(0.0, (sum, order) => sum + ((order['total'] as double?) ?? 0.0));
    
    return {
      'total': _myOrders.length,
      'executed': _myOrders.where((order) => order['status'] == 'executed').length,
      'pending': _myOrders.where((order) => order['status'] == 'pending').length,
      'cancelled': _myOrders.where((order) => order['status'] == 'cancelled').length,
      'totalBuy': totalBuy,
      'totalSell': totalSell
    };
  }

  // Get status badge styling
  Color _getStatusColor(String status) {
    switch (status) {
      case 'executed':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();
    final groupedOrders = _groupOrdersByDate(filteredOrders);
    final summary = _getOrderSummary();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildOrderSummary(summary),
                _buildFilterChips(),
                Expanded(
                  child: _buildOrdersList(groupedOrders),
                ),
                const SizedBox(height: 70), // Space for bottom info panel
              ],
            ),
          ),
          _buildInfoPanel(),
          _buildFloatingButtons(),
          if (_showFilters) _buildFilterPanel(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.primaryColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _challenge['name'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              setState(() {
                _showFilters = true;
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(Map<String, dynamic> summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          // Summary row 1
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50] ?? Colors.blue[100] ?? Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Orders',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600] ?? Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${summary['total']?.toString() ?? "0"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green[50] ?? Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Executed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600] ?? Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${summary['executed']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber[50] ?? Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600] ?? Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${summary['pending']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Summary row 2
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomLeft: Radius.circular(7),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Buy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${summary['totalBuy'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Sell',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${summary['totalSell'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'All Orders'),
            const SizedBox(width: 8),
            _buildFilterChip('buy', 'Buy Orders', color: Colors.green),
            const SizedBox(width: 8),
            _buildFilterChip('sell', 'Sell Orders', color: Colors.red),
            const SizedBox(width: 8),
            _buildFilterChip('pending', 'Pending', color: Colors.amber),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFilters = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100] ?? Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      'More Filters',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700] ?? Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.grey[700] ?? Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String type, String label, {Color? color}) {
    final isSelected = _filterType == type;
    final textColor = isSelected ? Colors.white : Colors.grey[700] ?? Colors.grey;
    final bgColor = isSelected
        ? (color ?? AppTheme.primaryColor)
        : Colors.grey[100] ?? Colors.grey[200] ?? Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(Map<String, List<Map<String, dynamic>>> groupedOrders) {
    if (groupedOrders.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedOrders.length,
      itemBuilder: (context, index) {
        final date = groupedOrders.keys.elementAt(index);
        final orders = groupedOrders[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Order items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, orderIndex) {
                return _buildOrderItem(orders[orderIndex]);
              },
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final bool isBuy = order['action'] == 'buy';
    final Color actionColor = isBuy ? Colors.green : Colors.red;
    final Color statusColor = _getStatusColor(order['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: actionColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 18,
                  color: actionColor,
                ),
              ),
              const SizedBox(width: 12),
              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order['symbol'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:                           Text(
                            order['status'] == 'executed' ? 'Executed' :
                            order['status'] == 'pending' ? 'Pending' : 'Cancelled',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500] ?? Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500] ?? Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action and price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isBuy ? 'Buy' : 'Sell',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: actionColor,
                    ),
                  ),
                  Text(
                    '${order['shares']} shares @ \$${order['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Total value
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200] ?? Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Value',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  order['total'].toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons for pending orders
          if (order['status'] == 'pending')
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.grey[300] ?? Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Modify'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.attach_money,
              size: 32,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no orders matching your current filters',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _filterType = 'all';
                _sortOrder = 'newest';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      setState(() {
                        _showFilters = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Order Type
              const Text(
                'Order Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton('all', 'All Orders'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton('buy', 'Buy Orders', color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton('sell', 'Sell Orders', color: Colors.red),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Order Status
              const Text(
                'Order Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton('executed', 'Executed', color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton('pending', 'Pending', color: Colors.amber),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton('cancelled', 'Cancelled', color: Colors.red),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Sort By
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSortButton('newest', 'Newest First'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSortButton('oldest', 'Oldest First'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSortButton('highest', 'Highest Value'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSortButton('lowest', 'Lowest Value'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String type, String label, {Color? color}) {
    final isSelected = _filterType == type;
    final buttonColor = isSelected ? (color ?? AppTheme.primaryColor) : Colors.transparent;
    final textColor = isSelected ? Colors.white : Colors.grey[700] ?? Colors.grey;
    final borderColor = isSelected ? (color ?? AppTheme.primaryColor) : Colors.grey[300] ?? Colors.grey;
    
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filterType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildSortButton(String sort, String label) {
    final isSelected = _sortOrder == sort;
    final buttonColor = isSelected ? AppTheme.primaryColor : Colors.transparent;
    final textColor = isSelected ? Colors.white : Colors.grey[700] ?? Colors.grey;
    final borderColor = isSelected ? AppTheme.primaryColor : Colors.grey[300] ?? Colors.grey;
    
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _sortOrder = sort;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your trades in this challenge are visible only to you. Trading data is used for performance reporting.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Stack(
      children: [
        // Chat button
        Positioned(
          left: 16,
          bottom: 100,
          child: FloatingActionButton(
            heroTag: 'chat',
            onPressed: () {
              // Open chat with Theo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.chat_bubble_outline, size: 20),
          ),
        ),
        
        // Share button
        Positioned(
          right: 16,
          bottom: 100,
          child: FloatingActionButton(
            heroTag: 'share',
            onPressed: () {},
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.share, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 1, // Arena selected
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Arena',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Portfolio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Social',
        ),
      ],
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        // Handle navigation
      },
    );
  }
}