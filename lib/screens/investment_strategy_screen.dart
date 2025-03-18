// screens/investment_strategies_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/investment_strategy_data.dart';
import 'package:theo/data/strategy_data.dart';
import 'package:theo/models/investment_strategy_models.dart';
import 'package:theo/models/strategy_component_models.dart';
import 'package:theo/screens/manage_investment_strategy_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class InvestmentStrategiesScreen extends StatefulWidget {
  const InvestmentStrategiesScreen({Key? key}) : super(key: key);

  @override
  _InvestmentStrategiesScreenState createState() => _InvestmentStrategiesScreenState();
}

class _InvestmentStrategiesScreenState extends State<InvestmentStrategiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'newest';
  List<InvestmentStrategy> _strategies = [];
  List<StrategyTemplate> _strategyTemplates = [];
  
  @override
  void initState() {
    super.initState();
    _strategies = InvestmentStrategyData.getMockStrategies();
    _strategyTemplates = InvestmentStrategyData.getStrategyTemplates();
    _searchController.addListener(() {
      setState(() {});  // Refresh UI when search text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InvestmentStrategy> get _filteredStrategies {
    final query = _searchController.text.toLowerCase();
    var filtered = _strategies.where((strategy) {
      return strategy.name.toLowerCase().contains(query) ||
             strategy.indicators.any((indicator) => indicator.toLowerCase().contains(query));
    }).toList();
    
    // Sort the filtered strategies based on selected sort order
    switch (_sortOrder) {
      case 'newest':
        filtered.sort((a, b) => b.dateModified.compareTo(a.dateModified));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.dateModified.compareTo(b.dateModified));
        break;
      case 'best':
        filtered.sort((a, b) => b.performance.compareTo(a.performance));
        break;
      case 'most-used':
        filtered.sort((a, b) => b.usedIn.compareTo(a.usedIn));
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
                'Investment Strategies',
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
          _buildCreateStrategyCard(),
          const SizedBox(height: 16),
          _buildSearchAndFilterBar(),
          const SizedBox(height: 16),
          _buildStrategiesList(),
        ],
      ),
    );
  }

  Widget _buildCreateStrategyCard() {
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
            'Create Investment Strategy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Design custom trading strategies using technical indicators, fundamental analysis, and market conditions.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Custom Strategy'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to manage strategy screen to create a new strategy
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageTradingStrategyScreen(
                          isEditing: false, // Creating a new strategy
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Use Template'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Show template options
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Choose a template'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // ... rest of the method remains the same
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
            hintText: 'Search strategies...',
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
        DropdownMenuItem(value: 'most-used', child: Text('Most Used')),
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

  Widget _buildStrategiesList() {
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
              'Your Strategies',
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
            itemCount: _filteredStrategies.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final strategy = _filteredStrategies[index];
              return _buildStrategyItem(strategy);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyItem(InvestmentStrategy strategy) {
    return InkWell(
    onTap: () {
      // Navigate to edit screen for this strategy
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageTradingStrategyScreen(
            isEditing: true,
            existingStrategy: TradingStrategy(
              name: strategy.name,
              description: "hi",//strategy.description,
              type: strategy.type,
              indicators: StrategyData.getMockIndicators(),
              entryConditions: StrategyData.getMockEntryConditions(),
              exitConditions: StrategyData.getMockExitConditions(),
              riskSettings: StrategyData.getMockRiskSettings(),
            ),
          ),
        ),
      );
    },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Strategy name and favorite icon
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          strategy.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (strategy.favorite)
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[400],
                        ),
                    ],
                  ),
                ),
                
                // Action buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.grey[400],
                      onPressed: () {
                        // Edit strategy
                      },
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.red[400],
                      onPressed: () {
                        // Delete strategy
                      },
                    ),
                  ],
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
                  'Modified: ${strategy.dateModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Type tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: strategy.type == 'Custom' ? Colors.purple[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    strategy.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: strategy.type == 'Custom' ? Colors.purple[800] : Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Indicator tags
                ...strategy.indicators.take(2).map((indicator) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      indicator,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                
                // More indicators
                if (strategy.indicators.length > 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${strategy.indicators.length - 2} more',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
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
                  content: Text('Sharing Investment Strategies'),
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