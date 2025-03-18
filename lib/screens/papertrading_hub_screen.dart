// screens/papertrading_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/paper_trading_data.dart';
import 'package:theo/models/paper_trading_portfolio_models.dart';
import 'package:theo/screens/papertrading_detail_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class PaperTradingScreen extends StatefulWidget {
  const PaperTradingScreen({Key? key}) : super(key: key);

  @override
  _PaperTradingScreenState createState() => _PaperTradingScreenState();
}

class _PaperTradingScreenState extends State<PaperTradingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'newest';
  List<PaperTradingPortfolio> _portfolios = [];
  
  @override
  void initState() {
    super.initState();
    _portfolios = PaperTradingData.getMockPortfolios();
    _searchController.addListener(() {
      setState(() {});  // Refresh UI when search text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PaperTradingPortfolio> get _filteredPortfolios {
    final query = _searchController.text.toLowerCase();
    var filtered = _portfolios.where((portfolio) {
      return portfolio.name.toLowerCase().contains(query) ||
             portfolio.strategy.toLowerCase().contains(query);
    }).toList();
    
    // Sort the filtered portfolios based on selected sort order
    switch (_sortOrder) {
      case 'newest':
        filtered.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case 'best':
        filtered.sort((a, b) => b.returnPercentage.compareTo(a.returnPercentage));
        break;
      case 'worst':
        filtered.sort((a, b) => a.returnPercentage.compareTo(b.returnPercentage));
        break;
    }
    
    return filtered;
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Paper Trading',
                style: TextStyle(
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

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCreateNewPortfolioCard(),
          const SizedBox(height: 16),
          _buildSearchAndFilterBar(),
          const SizedBox(height: 16),
          _buildPortfoliosList(),
        ],
      ),
    );
  }

  Widget _buildCreateNewPortfolioCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start Paper Trading',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Practice trading with virtual money in real market conditions to test your strategies without any risk.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create New Portfolio'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Navigate to create new portfolio screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Create New Portfolio'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search portfolios...',
            prefixIcon: const Icon(Icons.search, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        const SizedBox(height: 8),
        // Using LayoutBuilder to handle overflow
        LayoutBuilder(
          builder: (context, constraints) {
            // If screen is wide enough, use row layout
            if (constraints.maxWidth > 500) {
              return Row(
                children: [
                  Expanded(
                    child: _buildFilterButton(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSortDropdown(),
                  ),
                ],
              );
            } else {
              // For smaller screens, use column layout with full width buttons
              return Column(
                children: [
                  _buildFilterButton(),
                  const SizedBox(height: 8),
                  _buildSortDropdown(),
                ],
              );
            }
          }
        ),
      ],
    );
  }

  // Extracted filter button to separate widget
  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.filter_list, size: 16),
      label: const Text('Filter'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        // Show filter options
      },
    );
  }

  // Extracted sort dropdown to separate widget
  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      value: _sortOrder,
      isExpanded: true,  // Important to prevent overflow
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      items: const [
        DropdownMenuItem(value: 'newest', child: Text('Newest First')),
        DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
        DropdownMenuItem(value: 'best', child: Text('Best Performance')),
        DropdownMenuItem(value: 'worst', child: Text('Worst Performance')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortOrder = value;
          });
        }
      },
    );
  }

  Widget _buildPortfoliosList() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Portfolios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _filteredPortfolios.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final portfolio = _filteredPortfolios[index];
              return _buildPortfolioItem(portfolio);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(PaperTradingPortfolio portfolio) {
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final bool isPositiveReturn = portfolio.returnPercentage >= 0;
    
    return InkWell(
      onTap: () {
        // Navigate to portfolio detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaperTradingDetailScreen(portfolio: portfolio),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              portfolio.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (portfolio.status == 'active')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (portfolio.status == 'completed')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Started: ${portfolio.startDate}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Duration: ${portfolio.duration}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(portfolio.currentBalance),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          isPositiveReturn ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: isPositiveReturn ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${isPositiveReturn ? '+' : ''}${portfolio.returnPercentage}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isPositiveReturn ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    portfolio.strategy,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 12,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Initial: ${currencyFormat.format(portfolio.initialBalance)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
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
            // Share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sharing Paper Trading Hub'),
                duration: Duration(seconds: 1),
              ),
            );
          },
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