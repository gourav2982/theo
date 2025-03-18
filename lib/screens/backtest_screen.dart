import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/backtest_data.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/models/backtest_models.dart';
import 'package:theo/screens/backtest_detail_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/backtest_list_item.dart';
import 'package:theo/widgets/backtest_search_bar.dart';
import 'package:theo/widgets/create_backtest_card.dart';
import 'package:theo/widgets/chat_service.dart';

class BacktestScreen extends StatefulWidget {
  const BacktestScreen({Key? key}) : super(key: key);

  @override
  State<BacktestScreen> createState() => _BacktestScreenState();
}

class _BacktestScreenState extends State<BacktestScreen> {
  int _selectedIndex = 2; // Tools tab is selected
  String _searchValue = '';
  SortOrder _sortOrder = SortOrder.newest;
  
  late List<Backtest> _backtestHistory;
  List<Backtest> _filteredBacktests = [];
  
  @override
  void initState() {
    super.initState();
    _backtestHistory = BacktestData.getBacktestHistory();
    _filteredBacktests = [..._backtestHistory];
    _applyFilters();
  }
  
  void _applyFilters() {
    setState(() {
      // Apply search filter
      if (_searchValue.isNotEmpty) {
        _filteredBacktests = _backtestHistory.where((backtest) => 
          backtest.name.toLowerCase().contains(_searchValue.toLowerCase()) ||
          backtest.strategy.toLowerCase().contains(_searchValue.toLowerCase()) ||
          backtest.basket.toLowerCase().contains(_searchValue.toLowerCase())
        ).toList();
      } else {
        _filteredBacktests = [..._backtestHistory];
      }
      
      // Apply sort order
      switch (_sortOrder) {
        case SortOrder.newest:
          _filteredBacktests.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SortOrder.oldest:
          _filteredBacktests.sort((a, b) => a.date.compareTo(b.date));
          break;
        case SortOrder.best:
          _filteredBacktests.sort((a, b) {
            if (a.returnPercent == null) return 1;
            if (b.returnPercent == null) return -1;
            return b.returnPercent!.compareTo(a.returnPercent!);
          });
          break;
        case SortOrder.worst:
          _filteredBacktests.sort((a, b) {
            if (a.returnPercent == null) return 1;
            if (b.returnPercent == null) return -1;
            return a.returnPercent!.compareTo(b.returnPercent!);
          });
          break;
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
          // Create New Backtest Card
          CreateBacktestCard(
            onCreatePressed: () {
              // Navigate to backtest details screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BacktestDetailScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Search and Filter Bar
          BacktestSearchBar(
            searchValue: _searchValue,
            onSearchChanged: (value) {
              setState(() {
                _searchValue = value;
                _applyFilters();
              });
            },
            sortOrder: _sortOrder,
            onSortChanged: (order) {
              setState(() {
                _sortOrder = order;
                _applyFilters();
              });
            },
            onFilterPressed: () {
              // Handle filter button press
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening filters...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Backtest History Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Backtest History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827), // gray-900
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        '${_filteredBacktests.length} results',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280), // gray-500
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Divider
                const Divider(height: 1),
                
                // List of backtests
                _filteredBacktests.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No backtest results found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280), // gray-500
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredBacktests.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return BacktestListItem(
                            backtest: _filteredBacktests[index],
                            onTap: () {
                              // Navigate to backtest details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BacktestDetailScreen()),
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
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
        
        // If going back to Tools screen
        if (_selectedIndex == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ToolsScreen()),
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