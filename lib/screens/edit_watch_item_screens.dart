// screens/edit_watchlist_item_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/alerts_data.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/models/alerts_models.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class EditWatchlistItemScreen extends StatefulWidget {
  final int? watchlistItemId; // Optional ID for editing existing item
  
  const EditWatchlistItemScreen({
    Key? key, 
    this.watchlistItemId,
  }) : super(key: key);

  @override
  State<EditWatchlistItemScreen> createState() => _EditWatchlistItemScreenState();
}

class _EditWatchlistItemScreenState extends State<EditWatchlistItemScreen> {
  int _selectedIndex = 2; // Tools tab is selected by default
  
  // Form data
  late TextEditingController _itemNameController;
  bool _isActive = true;
  String _selectedBasketId = 'tech-sector';
  String _selectedStrategyId = 'momentum';
  late List<AlertCondition> _conditions;
  late AlertDelivery _alertDelivery;
  
  // Data lists
  late List<Basket> _baskets;
  late List<Strategy> _strategies;
  
  @override
  void initState() {
    super.initState();
    
    // Load data
    _baskets = AlertData.getBaskets();
    _strategies = AlertData.getStrategies();
    
    // Set default values or load from existing item
    if (widget.watchlistItemId != null) {
      // Edit existing item
      final item = AlertData.getWatchlistItemById(widget.watchlistItemId!);
      if (item != null) {
        _itemNameController = TextEditingController(text: item.name);
        _isActive = item.active;
        
        // Try to find matching basket and strategy IDs
        final basketId = _baskets.firstWhere(
          (b) => b.name == item.basket, 
          orElse: () => _baskets.first
        ).id;
        
        final strategyId = _strategies.firstWhere(
          (s) => s.name == item.strategy, 
          orElse: () => _strategies.first
        ).id;
        
        _selectedBasketId = basketId;
        _selectedStrategyId = strategyId;
      } else {
        // Fallback to defaults
        _itemNameController = TextEditingController(text: 'Tech Growth Portfolio');
      }
    } else {
      // New item
      _itemNameController = TextEditingController(text: 'Tech Growth Portfolio');
    }
    
    // Get alert conditions (deep copy to avoid modifying original data)
    _conditions = AlertData.getAlertConditions().map((c) => 
      AlertCondition(id: c.id, type: c.type, enabled: c.enabled)
    ).toList();
    
    // Get alert delivery settings
    final defaultDelivery = AlertData.getAlertDelivery();
    _alertDelivery = AlertDelivery(
      email: defaultDelivery.email,
      sms: defaultDelivery.sms,
      app: defaultDelivery.app,
      whatsapp: defaultDelivery.whatsapp,
    );
  }
  
  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }
  
  // Toggle condition enabled state
  void _toggleCondition(int id) {
    setState(() {
      final index = _conditions.indexWhere((c) => c.id == id);
      if (index != -1) {
        _conditions[index].enabled = !_conditions[index].enabled;
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
                'Edit Watchlist Item',
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
                shape: const RoundedRectangleBorder(
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
          // Basic Information
          _buildBasicInfoCard(),
          
          // Alert Conditions
          _buildAlertConditionsCard(),
          
          // Alert Delivery
          _buildAlertDeliveryCard(),
          
          // Save/Cancel Buttons
          _buildActionButtons(),
          
          // Bottom padding for floating buttons
          const SizedBox(height: 80),
        ],
      ),
    );
  }
  
  Widget _buildBasicInfoCard() {
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
            // Title with Active toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    fontFamily: 'Roboto',
                  ),
                ),
                
                // Active toggle
                Row(
                  children: [
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Watchlist Item Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Watchlist Item Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Basket
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Basket',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedBasketId,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedBasketId = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  items: _baskets.map((basket) {
                    return DropdownMenuItem<String>(
                      value: basket.id,
                      child: Text(basket.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'The group of securities to apply your strategy to',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Strategy
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Strategy',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedStrategyId,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStrategyId = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                  items: _strategies.map((strategy) {
                    return DropdownMenuItem<String>(
                      value: strategy.id,
                      child: Text(strategy.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'The investment strategy that will generate buy/sell signals',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Test Strategy Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle test strategy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Testing strategy on basket...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_right_alt, size: 18),
                label: const Text('Test Strategy on Basket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAlertConditionsCard() {
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
              'Alert Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            
            // Conditions list
            ..._conditions.map((condition) => _buildConditionItem(condition)).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConditionItem(AlertCondition condition) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            condition.type,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          Switch(
            value: condition.enabled,
            onChanged: (value) {
              _toggleCondition(condition.id);
            },
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAlertDeliveryCard() {
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
              'Alert Delivery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            
            // Email notifications
            _buildDeliveryOption(
              'Email Notifications',
              _alertDelivery.email,
              (value) {
                setState(() {
                  _alertDelivery.email = value;
                });
              },
            ),
            
            // SMS notifications
            _buildDeliveryOption(
              'SMS Notifications',
              _alertDelivery.sms,
              (value) {
                setState(() {
                  _alertDelivery.sms = value;
                });
              },
            ),
            
            // In-App notifications
            _buildDeliveryOption(
              'In-App Notifications',
              _alertDelivery.app,
              (value) {
                setState(() {
                  _alertDelivery.app = value;
                });
              },
            ),
            
            // WhatsApp notifications
            _buildDeliveryOption(
              'WhatsApp Notifications',
              _alertDelivery.whatsapp,
              (value) {
                setState(() {
                  _alertDelivery.whatsapp = value;
                });
              },
              isPremium: true,
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Schedule-based alert preferences can be configured in your global notification settings.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDeliveryOption(
    String label, 
    bool value, 
    ValueChanged<bool> onChanged, 
    {bool isPremium = false}
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Cancel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Save button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle save
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Changes saved'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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