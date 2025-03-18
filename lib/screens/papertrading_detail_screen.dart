// screens/paper_trading_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/paper_trading_data.dart';
import 'package:theo/models/paper_trading_portfolio_models.dart';

import 'package:theo/widgets/chat_service.dart';

class PaperTradingDetailScreen extends StatefulWidget {
  final PaperTradingPortfolio portfolio;
  
  const PaperTradingDetailScreen({
    Key? key, 
    required this.portfolio,
  }) : super(key: key);

  @override
  _PaperTradingDetailScreenState createState() => _PaperTradingDetailScreenState();
}

class _PaperTradingDetailScreenState extends State<PaperTradingDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  // Mock data
  late PortfolioData _portfolioData;
  late List<Position> _positions;
  late List<StockOrder> _orders;
  late List<WatchlistItem> _watchlist;
  late List<WatchlistItem> _filteredWatchlist;
  
  bool _enableFractionalShares = true;
  bool _enableOptionsTrading = true;
  bool _enableMarginTrading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load mock data
    _portfolioData = PaperTradingData.getMockPortfolioData();
    _positions = PaperTradingData.getMockPositions();
    _orders = PaperTradingData.getMockOrders();
    _watchlist = PaperTradingData.getMockWatchlist();
    _filteredWatchlist = _watchlist;
    
    _searchController.addListener(_filterWatchlist);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterWatchlist() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredWatchlist = _watchlist;
      } else {
        _filteredWatchlist = _watchlist.where((stock) {
          return stock.symbol.toLowerCase().contains(query) ||
                 stock.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(),
                _buildTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPortfolioTab(),
                      _buildWatchlistTab(),
                      _buildOrdersTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
            _buildFloatingButtons(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              Text(
                widget.portfolio.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          
          // User Icon
          IconButton(
            icon: const Icon(Icons.person, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryColor,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey[600],
        tabs: const [
          Tab(text: 'Portfolio'),
          Tab(text: 'Watchlist'),
          Tab(text: 'Orders'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Overview
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currencyFormat.format(_portfolioData.accountValue),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  _portfolioData.dailyChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 14,
                                  color: _portfolioData.dailyChange >= 0 ? Colors.green[700] : Colors.red[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${currencyFormat.format(_portfolioData.dailyChange)} (${_portfolioData.dailyChangePercent.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _portfolioData.dailyChange >= 0 ? Colors.green[700] : Colors.red[700],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Total Value',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buying Power',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              currencyFormat.format(_portfolioData.buyingPower),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Total P/L: ${currencyFormat.format(_portfolioData.totalGain)} (${_portfolioData.totalGainPercent.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _portfolioData.totalGain >= 0 ? Colors.green[700] : Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Positions
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Positions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Sort'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    headingTextStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    columns: const [
                      DataColumn(label: Text('SYMBOL')),
                      DataColumn(label: Text('SHARES'), numeric: true),
                      DataColumn(label: Text('AVG PRICE'), numeric: true),
                      DataColumn(label: Text('PRICE'), numeric: true),
                      DataColumn(label: Text('VALUE'), numeric: true),
                      DataColumn(label: Text('P/L'), numeric: true),
                    ],
                    rows: _positions.map((position) {
                      final isPositive = position.gain >= 0;
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  position.symbol,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  position.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(position.shares.toString())),
                          DataCell(Text('\$${position.avgPrice.toStringAsFixed(2)}')),
                          DataCell(Text('\$${position.currentPrice.toStringAsFixed(2)}')),
                          DataCell(Text('\$${position.value.toStringAsFixed(2)}')),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${position.gain.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isPositive ? Colors.green[700] : Colors.red[700],
                                  ),
                                ),
                                Text(
                                  '${isPositive ? '+' : ''}${position.gainPercent.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPositive ? Colors.green[700] : Colors.red[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for stocks...',
              prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Watchlist
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Watchlist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                          color: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _filteredWatchlist.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final stock = _filteredWatchlist[index];
                        final isPositive = stock.change >= 0;
                        
                        return ListTile(
                          title: Text(
                            stock.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            stock.name,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${stock.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${isPositive ? '+' : ''}${stock.change.toStringAsFixed(2)} (${stock.changePercent.toStringAsFixed(2)}%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isPositive ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Show stock details
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Filter'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingTextStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text('DATE/TIME')),
                    DataColumn(label: Text('SYMBOL')),
                    DataColumn(label: Text('TYPE')),
                    DataColumn(label: Text('QUANTITY'), numeric: true),
                    DataColumn(label: Text('PRICE'), numeric: true),
                    DataColumn(label: Text('TOTAL'), numeric: true),
                    DataColumn(label: Text('STATUS')),
                  ],
                  rows: _orders.map((order) {
                    final bool isBuy = order.type == 'Buy';
                    final bool isFilled = order.status == 'Filled';
                    
                    return DataRow(
                      cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                order.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                order.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(order.symbol)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isBuy ? Colors.green[50] : Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.type,
                              style: TextStyle(
                                fontSize: 12,
                                color: isBuy ? Colors.green[700] : Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(order.quantity.toString())),
                        DataCell(Text('\$${order.price.toStringAsFixed(2)}')),
                        DataCell(Text('\$${order.total.toStringAsFixed(2)}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isFilled ? Colors.blue[50] : Colors.amber[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: isFilled ? Colors.blue[700] : Colors.amber[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paper Trading Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Divider(height: 24),
              
              // Initial Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Initial Balance',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: TextEditingController(
                      text: '${widget.portfolio.initialBalance.toStringAsFixed(2)}',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Initial balance cannot be changed for ongoing portfolios',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Reset Portfolio
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reset Portfolio',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset Portfolio'),
                          content: Text(
                            'This will clear all positions and reset your balance to \$${widget.portfolio.initialBalance.toStringAsFixed(0)}. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Portfolio has been reset'),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('RESET'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset to Initial Balance'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This will clear all positions and reset your balance to \$${widget.portfolio.initialBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Trading Preferences
              const Text(
                'Trading Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // Fractional Shares
              _buildSettingSwitch(
                title: 'Enable Fractional Shares',
                subtitle: 'Allow purchasing partial shares of stocks',
                value: _enableFractionalShares,
                onChanged: (value) {
                  setState(() {
                    _enableFractionalShares = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              
              // Options Trading
              _buildSettingSwitch(
                title: 'Enable Options Trading',
                subtitle: 'Allow trading stock options',
                value: _enableOptionsTrading,
                onChanged: (value) {
                  setState(() {
                    _enableOptionsTrading = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              
              // Margin Trading
              _buildSettingSwitch(
                title: 'Enable Margin Trading',
                subtitle: 'Allow trading with borrowed funds',
                value: _enableMarginTrading,
                onChanged: (value) {
                  setState(() {
                    _enableMarginTrading = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
  return Positioned(
    bottom: 80,
    right: 16,
    child: Column(
      children: [
        // Share Button
        FloatingActionButton(
          heroTag: 'share',
          onPressed: () {
            // Share portfolio
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sharing portfolio: ${widget.portfolio.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          backgroundColor: AppTheme.primaryColor,
          mini: true,
          child: const Icon(Icons.share, size: 20),
        ),
        const SizedBox(height: 12),
        
        // Trade Button (only in detail screen)
        FloatingActionButton.extended(
          heroTag: 'trade',
          onPressed: () {
            // Open trade form
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New Trade'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          backgroundColor: Colors.green,
          icon: const Icon(Icons.add, size: 20),
          label: const Text('New Trade'),
        ),
        const SizedBox(height: 12),
        
        // Ask Theo Button
        FloatingActionButton.extended(
          heroTag: 'message',
          onPressed: () {
            ChatService.openChat(context);
          },
          backgroundColor: AppTheme.primaryColor,
          icon: const Icon(Icons.message, size: 20),
          label: const Text('Ask Theo'),
        ),
      ],
    ),
  );
}

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 2, // Tools tab is selected
      onTap: (index) {
        // This would be handled by the main navigation controller
        // For now, we'll just go back to the tools screen
        if (index != 2) {
          Navigator.of(context).pop();
        }
      },
      // Using DummyData.tabs for consistent icons and labels
      items: DummyData.tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}