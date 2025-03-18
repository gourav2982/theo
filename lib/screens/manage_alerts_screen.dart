// screens/manage_alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/alerts_data.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/models/alerts_models.dart';
import 'package:theo/screens/edit_watch_item_screens.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class ManageAlertsScreen extends StatefulWidget {
  const ManageAlertsScreen({Key? key}) : super(key: key);

  @override
  State<ManageAlertsScreen> createState() => _ManageAlertsScreenState();
}

class _ManageAlertsScreenState extends State<ManageAlertsScreen> {
  int _selectedIndex = 2; // Tools tab is selected by default
  String _selectedTab = 'watchlist';
  String _searchValue = '';

  // Data
  List<WatchlistItem> _watchlistItems = [];
  List<SubscriptionAlert> _subscriptionAlerts = [];

  @override
  void initState() {
    super.initState();
    _watchlistItems = AlertData.getWatchlistItems();
    _subscriptionAlerts = AlertData.getSubscriptionAlerts();
  }

  // Toggle watchlist item active state
  void _toggleWatchlistItemActive(int id) {
    setState(() {
      final index = _watchlistItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _watchlistItems[index];
        _watchlistItems[index] = WatchlistItem(
          id: item.id,
          name: item.name,
          basket: item.basket,
          strategy: item.strategy,
          active: !item.active,
          lastAlert: item.lastAlert,
        );
      }
    });
  }

  // Delete watchlist item
  void _deleteWatchlistItem(int id) {
    setState(() {
      _watchlistItems.removeWhere((item) => item.id == id);
    });
  }

  // Subscribe to alert
  void _subscribeToAlert(int id) {
    setState(() {
      final index = _subscriptionAlerts.indexWhere((alert) => alert.id == id);
      if (index != -1) {
        final alert = _subscriptionAlerts[index];
        _subscriptionAlerts[index] = SubscriptionAlert(
          id: alert.id,
          type: 'subscribed',
          name: alert.name,
          description: alert.description,
          price: alert.price,
          subscribers: alert.subscribers + 1,
          category: alert.category,
        );
      }
    });
  }

  // Unsubscribe from alert
  void _unsubscribeFromAlert(int id) {
    setState(() {
      final index = _subscriptionAlerts.indexWhere((alert) => alert.id == id);
      if (index != -1) {
        final alert = _subscriptionAlerts[index];
        _subscriptionAlerts[index] = SubscriptionAlert(
          id: alert.id,
          type: 'available',
          name: alert.name,
          description: alert.description,
          price: alert.price,
          subscribers: alert.subscribers - 1,
          category: alert.category,
        );
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
                _buildSubNavigation(),
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
                'Manage Alerts',
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

  Widget _buildSubNavigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTabButton('watchlist', 'My Watchlist'),
          const SizedBox(width: 8),
          _buildTabButton('subscriptions', 'Alert Subscriptions'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabId, String label) {
    final isSelected = _selectedTab == tabId;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabId;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display content based on selected tab
          _selectedTab == 'watchlist'
              ? _buildWatchlistContent()
              : _buildSubscriptionsContent(),
        ],
      ),
    );
  }

  Widget _buildWatchlistContent() {
    return Column(
      children: [
        // Search and Add Bar
        _buildWatchlistSearchBar(),

        // Watchlist
        _buildWatchlistCard(),
      ],
    );
  }

  Widget _buildWatchlistSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
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
                  hintText: 'Search watchlist...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),

          // Add button
          ElevatedButton.icon(
            onPressed: () {
              // Handle add to watchlist
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adding to watchlist...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add to Watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Watchlist',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage the baskets and strategies you want to receive alerts for',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Empty state or watchlist items
          _watchlistItems.isEmpty
              ? _buildEmptyWatchlistState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _watchlistItems.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return _buildWatchlistItem(_watchlistItems[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyWatchlistState() {
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
                Icons.visibility,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No items in watchlist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get started by adding a basket and strategy to your watchlist.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Handle add first item
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adding first item...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add First Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildWatchlistItem(WatchlistItem item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and status
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.active
                                ? Colors.green.shade100
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.active ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: item.active
                                  ? Colors.green.shade800
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Basket and strategy
                    Wrap(
                      children: [
                        Text(
                          'Basket: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          item.basket,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Text(
                          'Strategy: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          item.strategy,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
                  // Activate/Deactivate
                  IconButton(
                    icon: Icon(
                      item.active ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: item.active
                          ? Colors.grey.shade600
                          : AppTheme.primaryColor,
                    ),
                    tooltip: item.active ? 'Deactivate' : 'Activate',
                    onPressed: () => _toggleWatchlistItemActive(item.id),
                  ),

                  // Edit
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    tooltip: 'Edit',
                    onPressed: () {
                      // Navigate to edit screen with the item ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditWatchlistItemScreen(
                            watchlistItemId: item.id,
                          ),
                        ),
                      );
                    },
                  ),

                  // Delete
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red.shade400,
                    ),
                    tooltip: 'Delete',
                    onPressed: () {
                      // Show delete confirmation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Watchlist Item'),
                          content: Text(
                              'Are you sure you want to delete "${item.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteWatchlistItem(item.id);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red.shade600),
                              ),
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

          // Last alert tag
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications,
                  size: 12,
                  color: Colors.blue.shade800,
                ),
                const SizedBox(width: 4),
                Text(
                  'Last alert: ${item.lastAlert}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsContent() {
    return Column(
      children: [
        // Search and Filter Bar
        _buildSubscriptionsSearchBar(),

        // Subscribed Alerts
        _buildSubscribedAlertsCard(),

        // Available Alerts
        _buildAvailableAlertsCard(),
      ],
    );
  }

  Widget _buildSubscriptionsSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
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
                  hintText: 'Search alerts...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),

          // Filter button
          OutlinedButton.icon(
            onPressed: () {
              // Handle filter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter options...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribedAlertsCard() {
    final subscribedAlerts = _subscriptionAlerts
        .where((alert) => alert.type == 'subscribed')
        .toList();

    if (subscribedAlerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'My Alert Subscriptions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const Divider(height: 1),

          // Alert items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subscribedAlerts.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildAlertItem(
                subscribedAlerts[index],
                isSubscribed: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableAlertsCard() {
    final availableAlerts = _subscriptionAlerts
        .where((alert) => alert.type == 'available')
        .toList();

    if (availableAlerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Available Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const Divider(height: 1),

          // Alert items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableAlerts.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildAlertItem(
                availableAlerts[index],
                isSubscribed: false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(SubscriptionAlert alert,
      {required bool isSubscribed}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and price tag
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            alert.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (alert.price == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Free',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        if (alert.price > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '\$${alert.price}/week',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      alert.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Action button
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  if (isSubscribed) {
                    _unsubscribeFromAlert(alert.id);
                  } else {
                    _subscribeToAlert(alert.id);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: isSubscribed
                      ? Colors.red.shade100
                      : AppTheme.primaryColor,
                  foregroundColor:
                      isSubscribed ? Colors.red.shade700 : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isSubscribed ? 'Unsubscribe' : 'Subscribe',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Category and subscribers tags
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Category tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  alert.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              // Subscribers tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${alert.subscribers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} subscribers',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
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
