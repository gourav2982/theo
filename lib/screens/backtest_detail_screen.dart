import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/backtest_config_data.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/models/backtest_config_models.dart';
import 'package:theo/widgets/backtest_config_form.dart';
import 'package:theo/widgets/backtest_results.dart';
import 'package:theo/widgets/chat_service.dart';
import 'package:theo/screens/backtest_screen.dart';

class BacktestDetailScreen extends StatefulWidget {
  const BacktestDetailScreen({Key? key}) : super(key: key);

  @override
  State<BacktestDetailScreen> createState() => _BacktestDetailScreenState();
}

class _BacktestDetailScreenState extends State<BacktestDetailScreen> {
  int _selectedIndex = 2; // Tools tab is selected
  
  // Form state
  String _selectedStrategy = '';
  String _selectedBasket = '';
  String _startDate = '2023-01-01';
  String _endDate = '2024-01-01';
  int _investment = 10000;
  
  // Display state
  bool _showResults = false;
  
  late List<Strategy> _strategies;
  late List<Basket> _baskets;
  late List<PerformanceMetric> _metrics;
  late List<PerformanceData> _chartData;
  late List<TradeRecord> _trades;
  
  @override
  void initState() {
    super.initState();
    _strategies = BacktestConfigData.getStrategies();
    _baskets = BacktestConfigData.getBaskets();
    _metrics = BacktestConfigData.getPerformanceMetrics();
    _chartData = BacktestConfigData.getPerformanceData();
    _trades = BacktestConfigData.getTradeHistory();
  }
  
  void _runBacktest() {
    if (_selectedStrategy.isEmpty || _selectedBasket.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both a strategy and a basket'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() {
      _showResults = true;
    });
    
    // In a real app, this would make an API call and update the results
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
                Expanded(
                  child: _buildMainContent(),
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
                'Backtest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          
          // User and Notification Icons
          Row(
            children: [
              // User Profile
              PopupMenuButton(
                icon: const Icon(Icons.person, size: 20),
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Text('Your Profile'),
                  ),
                  const PopupMenuItem(
                    value: 'preferences',
                    child: Text('Preferences'),
                  ),
                  const PopupMenuItem(
                    value: 'subscription',
                    child: Text('Subscription & Billing'),
                  ),
                  const PopupMenuItem(
                    value: 'support',
                    child: Text('Support'),
                  ),
                  const PopupMenuItem(
                    value: 'signout',
                    child: Text('Sign Out'),
                  ),
                ],
              ),
              
              // Notification
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, size: 20),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Configuration Form
          BacktestConfigForm(
            selectedStrategy: _selectedStrategy,
            selectedBasket: _selectedBasket,
            startDate: _startDate,
            endDate: _endDate,
            investment: _investment,
            strategies: _strategies,
            baskets: _baskets,
            onStrategyChanged: (value) {
              setState(() {
                _selectedStrategy = value;
              });
            },
            onBasketChanged: (value) {
              setState(() {
                _selectedBasket = value;
              });
            },
            onStartDateChanged: (value) {
              setState(() {
                _startDate = value;
              });
            },
            onEndDateChanged: (value) {
              setState(() {
                _endDate = value;
              });
            },
            onInvestmentChanged: (value) {
              setState(() {
                _investment = value;
              });
            },
            onRunBacktest: _runBacktest,
          ),
          const SizedBox(height: 24),
          
          // Results (conditionally displayed)
          if (_showResults)
            BacktestResults(
              metrics: _metrics,
              chartData: _chartData,
              trades: _trades,
            ),
            
          // Extra padding at bottom to account for FAB
          const SizedBox(height: 80),
        ],
      ),
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
            onPressed: () {},
            backgroundColor: AppTheme.primaryColor,
            mini: true,
            child: const Icon(Icons.share, size: 20),
          ),
          const SizedBox(height: 12),
          
          // Ask Theo Button
          FloatingActionButton.extended(
            heroTag: 'message',
            onPressed: () {
              // Open chat with Theo
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
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // Handle navigation between screens
        if (_selectedIndex == 2) {
          // Navigate back to backtests list screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BacktestScreen()),
          );
        }
      },
      items: DummyData.tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}