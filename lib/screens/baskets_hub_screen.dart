// screens/baskets_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/basket_data.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/models/basket_models.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/manage_basket_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class BasketsHubScreen extends StatefulWidget {
  const BasketsHubScreen({Key? key}) : super(key: key);

  @override
  State<BasketsHubScreen> createState() => _BasketsHubScreenState();
}

class _BasketsHubScreenState extends State<BasketsHubScreen> {
  int _selectedIndex = 2; // Tools tab is selected by default
  String _searchValue = '';
  String _sortOrder = 'newest';
  List<Basket> _baskets = [];
  List<BasketTemplate> _basketTemplates = [];

  @override
  void initState() {
    super.initState();
    _baskets = BasketData.getBaskets();
    _basketTemplates = BasketData.getBasketTemplates();
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
        color: AppTheme.primaryColor,
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
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Manage Baskets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),

          // User Profile
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Show user profile options
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Your Profile'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('Preferences'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.credit_card_outlined),
                        title: const Text('Subscription & Billing'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Support'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout_outlined),
                        title: const Text('Sign Out'),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
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
          // Create New Basket Card
          _buildCreateBasketCard(),

          // Search and Filter Bar
          _buildSearchAndFilterBar(),

          // Baskets List
          _buildBasketsList(),
        ],
      ),
    );
  }

  Widget _buildCreateBasketCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Basket',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a custom collection of securities or select from predefined baskets.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),

            // Create Empty Basket Button
            ElevatedButton(
              onPressed: () {
                // Navigate to ManageBasketScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageBasketScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Create Empty Basket',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Or start with a template:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5563),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),

            // Template Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: _basketTemplates.length,
              itemBuilder: (context, index) {
                return _buildTemplateCard(_basketTemplates[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BasketTemplate template) {
    return InkWell(
      onTap: () {
        // Handle template selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Creating ${template.name} basket'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: template.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                template.icon,
                color: template.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              template.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Search Input
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchValue = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search baskets...',
                prefixIcon: Icon(Icons.search, size: 18),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // Filter and Sort
          Row(
            children: [
              // Filter Button
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle filter
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Filter options'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filter'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Sort Dropdown
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortOrder,
                      isExpanded: true,
                      hint: const Text('Sort by'),
                      items: const [
                        DropdownMenuItem(
                          value: 'newest',
                          child: Text('Newest First'),
                        ),
                        DropdownMenuItem(
                          value: 'oldest',
                          child: Text('Oldest First'),
                        ),
                        DropdownMenuItem(
                          value: 'best',
                          child: Text('Best Performance'),
                        ),
                        DropdownMenuItem(
                          value: 'most-used',
                          child: Text('Most Securities'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortOrder = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasketsList() {
    return Card(
      elevation: 2,
      margin:
          const EdgeInsets.only(bottom: 80), // Add padding for floating buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Your Baskets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const Divider(height: 1),

          // Empty state or list of baskets
          _baskets.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _baskets.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _buildBasketItem(_baskets[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No baskets created',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get started by creating your first basket of securities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Handle create basket
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Creating new basket'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create New Basket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasketItem(Basket basket) {
    return InkWell(
      onTap: () {
        // Handle basket selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${basket.name}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Basket info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and badges
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            basket.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          if (basket.favorite)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Favorite',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: basket.type == 'Custom'
                                  ? Colors.purple.shade100
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              basket.type,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: basket.type == 'Custom'
                                    ? Colors.purple.shade800
                                    : Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Date and securities info
                      Wrap(
                        spacing: 8,
                        children: [
                          Text(
                            'Modified: ${basket.dateModified}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            '${basket.securities} securities',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy_outlined, size: 18),
                      color: Colors.grey.shade400,
                      tooltip: 'Duplicate',
                      onPressed: () {
                        // Handle duplicate
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Duplicating ${basket.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 18),
                      color: Colors.grey.shade400,
                      tooltip: 'Edit',
                      onPressed: () {
                        // Handle edit
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Editing ${basket.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.grey.shade400,
                      tooltip: 'Delete',
                      onPressed: () {
                        // Handle delete with confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Basket'),
                            content: Text(
                                'Are you sure you want to delete "${basket.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _baskets
                                        .removeWhere((b) => b.id == basket.id);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Basket deleted'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Performance
            Row(
              children: [
                const Text(
                  '1 Month Performance:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  basket.performance1m >= 0
                      ? '+${basket.performance1m}%'
                      : '${basket.performance1m}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: basket.performance1m >= 0
                        ? Colors.green.shade600
                        : Colors.red.shade600,
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
            onPressed: () {},
            backgroundColor: Colors.green.shade500,
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
        if (index == 0) {
          // Navigate to Home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          // Navigate to Learning screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LearningScreen()),
          );
        } else if (index == 2 && _selectedIndex != index) {
          // Navigate to Tools screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ToolsScreen()),
          );
        }
        // For other tabs (not yet implemented)
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
