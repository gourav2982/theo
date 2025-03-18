import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/indicator_data.dart';
import 'package:theo/models/indicator_models.dart';
import 'package:theo/screens/custom_indicator_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class IndicatorsHubScreen extends StatefulWidget {
  const IndicatorsHubScreen({Key? key}) : super(key: key);

  @override
  _IndicatorsHubScreenState createState() => _IndicatorsHubScreenState();
}

class _IndicatorsHubScreenState extends State<IndicatorsHubScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'most-used';
  String _categoryFilter = 'all';
  List<Indicator> _indicators = [];
  List<IndicatorTemplate> _indicatorTemplates = [];
  
  @override
  void initState() {
    super.initState();
    _indicators = IndicatorData.getMockIndicators();
    _indicatorTemplates = IndicatorData.getIndicatorTemplates();
    _searchController.addListener(() {
      setState(() {});  // Refresh UI when search text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Indicator> get _filteredIndicators {
    final query = _searchController.text.toLowerCase();
    var filtered = _indicators.where((indicator) {
      // Filter by search query
      final matchesSearch = indicator.name.toLowerCase().contains(query) || 
                            indicator.description.toLowerCase().contains(query);
      
      // Filter by category
      final matchesCategory = _categoryFilter == 'all' || 
                              indicator.category.toLowerCase() == _categoryFilter.toLowerCase();
      
      return matchesSearch && matchesCategory;
    }).toList();
    
    // Sort the filtered indicators based on selected sort order
    switch (_sortOrder) {
      case 'most-used':
        filtered.sort((a, b) => b.usedIn.compareTo(a.usedIn));
        break;
      case 'recent':
        filtered.sort((a, b) => b.dateModified.compareTo(a.dateModified));
        break;
      case 'alphabetical':
        filtered.sort((a, b) => a.name.compareTo(b.name));
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
                'Manage Indicators',
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
          _buildCreateNewIndicatorCard(),
          const SizedBox(height: 16),
          _buildSearchAndFilterBar(),
          const SizedBox(height: 16),
          _buildIndicatorsList(),
        ],
      ),
    );
  }

  Widget _buildCreateNewIndicatorCard() {
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
              'Create New Indicator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create custom technical indicators or modify existing ones to enhance your trading strategies.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            
            // Create Custom Indicator Button - Updated with navigation
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Custom Indicator'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                // Navigate to CreateCustomIndicatorScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateCustomIndicatorScreen(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            Text(
              'Or start with a template:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: _indicatorTemplates.length,
              itemBuilder: (context, index) {
                final template = _indicatorTemplates[index];
                final backgroundColor = IndicatorData.getBackgroundColorForTemplate(template.colorClass);
                final textColor = IndicatorData.getTextColorForTemplate(template.colorClass);
                final icon = IndicatorData.getIconForType(template.iconType);
                
                return InkWell(
                  onTap: () {
                    // Template selected action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected template: ${template.name}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            color: textColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
            hintText: 'Search indicators...',
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
                    child: _buildCategoryDropdown(),
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
                  _buildCategoryDropdown(),
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _categoryFilter,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      items: IndicatorData.getCategoryOptions().map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(IndicatorData.getCategoryDisplayName(category)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _categoryFilter = newValue;
          });
        }
      },
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      value: _sortOrder,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      items: IndicatorData.getSortOptions().map((String sort) {
        return DropdownMenuItem<String>(
          value: sort,
          child: Text(IndicatorData.getSortDisplayName(sort)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _sortOrder = newValue;
          });
        }
      },
    );
  }

  Widget _buildIndicatorsList() {
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
              'Your Indicators',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          
          // If no indicators match the filter
          if (_filteredIndicators.isEmpty) 
            _buildEmptyState()
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _filteredIndicators.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final indicator = _filteredIndicators[index];
                return _buildIndicatorItem(indicator);
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.show_chart,
                size: 32,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No custom indicators',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get started by creating your first indicator or modifying an existing one.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create New Indicator'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                // Navigate to CreateCustomIndicatorScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateCustomIndicatorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorItem(Indicator indicator) {
    final categoryColor = indicator.category.toLowerCase() == 'technical' 
        ? Colors.blue 
        : Colors.green;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and favorite icon
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        indicator.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (indicator.favorite)
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
                    icon: const Icon(Icons.copy, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.grey[400],
                    tooltip: 'Duplicate',
                    onPressed: () {
                      // Duplicate indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Duplicating: ${indicator.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.settings, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.grey[400],
                    tooltip: 'Edit',
                    onPressed: () {
                      // Edit indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Editing: ${indicator.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.grey[400],
                    tooltip: 'Delete',
                    onPressed: () {
                      // Delete indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleting: ${indicator.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            indicator.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Tags and info
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Category tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: categoryColor[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  indicator.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: categoryColor[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              // Type
              Text(
                indicator.type,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              
              // Dot separator
              Text(
                '•',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              
              // Used in
              Text(
                'Used in ${indicator.usedIn} ${indicator.usedIn == 1 ? 'strategy' : 'strategies'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
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
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing Indicators'),
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