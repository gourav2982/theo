import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/screens/order_screen.dart';
import 'package:theo/screens/trade_chat_screen.dart';
import 'package:theo/screens/create_challenge_screen.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/join_challenge_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/research_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/screens/trade_screen.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({Key? key}) : super(key: key);

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  int _selectedIndex = 4; // Arena is selected at index 1
  bool _showCreateModal = false;
  bool _showJoinModal = false;
  String _activeSection = 'myStandings';

  // Sample data - in a real app, move this to dummy_data.dart
  final List<Map<String, dynamic>> currentChallenges = [
    {
      'id': 1,
      'name': "S&P 500 Weekly Challenge",
      'endDate': "Mar 20, 2025",
      'participants': 142,
      'myRank': 24,
      'returnRate': 5.8,
      'initialInvestment': 10000
    },
    {
      'id': 2,
      'name': "Tech Stocks Battle",
      'endDate': "Mar 25, 2025",
      'participants': 87,
      'myRank': 3,
      'returnRate': 12.4,
      'initialInvestment': 5000
    }
  ];

  final List<Map<String, dynamic>> startingTodayChallenges = [
    {
      'id': 3,
      'name': "Crypto Showdown",
      'startDate': "Mar 13, 2025",
      'duration': "7 days",
      'participants': 64,
      'entryFee': "Free"
    },
    {
      'id': 4,
      'name': "Green Energy Focus",
      'startDate': "Mar 13, 2025",
      'duration': "14 days",
      'participants': 38,
      'entryFee': "Free"
    }
  ];

  final List<Map<String, dynamic>> upcomingChallenges = [
    {
      'id': 5,
      'name': "Blue Chip Masters",
      'startDate': "Mar 15, 2025",
      'duration': "30 days",
      'participants': 112,
      'entryFee': "Free"
    },
    {
      'id': 6,
      'name': "Dividend Heroes",
      'startDate': "Mar 18, 2025",
      'duration': "21 days",
      'participants': 75,
      'entryFee': "Free"
    }
  ];

  final List<Map<String, dynamic>> completedChallenges = [
    {
      'id': 7,
      'name': "Financial Sector Sprint",
      'endDate': "Mar 10, 2025",
      'participants': 95,
      'winner': "trader_pro",
      'returnRate': 15.2
    },
    {
      'id': 8,
      'name': "Small Cap Challenge",
      'endDate': "Mar 5, 2025",
      'participants': 63,
      'winner': "investKing",
      'returnRate': 9.7
    }
  ];

  final List<Map<String, dynamic>> recentOrders = [
    {
      'id': 1,
      'symbol': "AAPL",
      'action': "Buy",
      'shares': 10,
      'price': 187.42,
      'time': "10:32 AM",
      'user': "trader_joe"
    },
    {
      'id': 2,
      'symbol': "MSFT",
      'action': "Sell",
      'shares': 5,
      'price': 423.18,
      'time': "2:15 PM",
      'user': "investor123"
    },
    {
      'id': 3,
      'symbol': "NVDA",
      'action': "Buy",
      'shares': 3,
      'price': 926.74,
      'time': "11:05 AM",
      'user': "stockwhiz"
    }
  ];

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
          // Logo
          const Text(
            'HeyTheo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
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
    return Column(
      children: [
        // Page Title
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          color: AppTheme.primaryColor.withOpacity(0.9),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arena',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Compete, learn, and win with trading challenges',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Quick Action Buttons
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.emoji_events,
                  label: 'Join Challenge',
                  color: AppTheme.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    // Navigate to Join Challenge Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinChallengeScreen(
                          // We'll use a generic challenge from startingTodayChallenges if available
                          challengeData: startingTodayChallenges.isNotEmpty
                              ? {
                                  'id': startingTodayChallenges[0]['id'],
                                  'name': startingTodayChallenges[0]['name'],
                                  'creator': 'market_guru',
                                  'creatorAvatar': '🧙‍♂️',
                                  'startDate': startingTodayChallenges[0]
                                      ['startDate'],
                                  'endDate': startingTodayChallenges[0]
                                      ['duration'],
                                  'duration': startingTodayChallenges[0]
                                      ['duration'],
                                  'participants': startingTodayChallenges[0]
                                      ['participants'],
                                  'initialInvestment': 10000,
                                  'category': "stocks",
                                  'description':
                                      "Compete against others with stocks from the S&P 500 index. Show your trading skills and climb the leaderboard.",
                                  'universes': ["S&P 500"],
                                  'rules': [
                                    "Starting capital: \$10,000",
                                    "Trading only S&P 500 stocks",
                                    "Maximum 10 trades per day",
                                    "No shorting allowed",
                                    "All trades visible to participants"
                                  ]
                                }
                              : null,
                          onJoinComplete: (joinData) {
                            // Handle challenge join
                            print('Joined challenge: $joinData');
                            // Here you would typically add this participant to the challenge
                            // and navigate to the My Standings tab
                            setState(() {
                              _activeSection = 'myStandings';
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.add,
                  label: 'Create Challenge',
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    // Navigate to Create Challenge Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateChallengeScreen(
                          onChallengeCreated: (challengeData) {
                            // Handle new challenge creation
                            print('New challenge created: $challengeData');
                            // Here you would typically add this to your challenges list
                            // and possibly navigate to the My Standings tab
                            setState(() {
                              _activeSection = 'myStandings';
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.people,
                  label: 'Invite Friends',
                  color: Colors.grey.shade100,
                  textColor: Colors.grey.shade700,
                  onPressed: () {
                    // Invite friends logic
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.filter_list,
                  label: 'Filter',
                  color: Colors.grey.shade100,
                  textColor: Colors.grey.shade700,
                  onPressed: () {
                    // Filter logic
                  },
                ),
              ],
            ),
          ),
        ),

        // Section Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSectionTab('myStandings', 'My Standings'),
                _buildSectionTab('startingToday', 'Starting Today'),
                _buildSectionTab('upcoming', 'Next 5 Days'),
                _buildSectionTab('completed', 'Completed'),
              ],
            ),
          ),
        ),

        // Content Section
        Expanded(
          child: _getActiveSection(),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _buildSectionTab(String section, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSection = section;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _activeSection == section
                  ? AppTheme.primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _activeSection == section
                ? AppTheme.primaryColor
                : Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _getActiveSection() {
    switch (_activeSection) {
      case 'myStandings':
        return _buildMyStandingsSection();
      case 'startingToday':
        return _buildStartingTodaySection();
      case 'upcoming':
        return _buildUpcomingSection();
      case 'completed':
        return _buildCompletedSection();
      default:
        return _buildMyStandingsSection();
    }
  }

  Widget _buildMyStandingsSection() {
    if (currentChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.emoji_events,
        title: 'No Active Challenges',
        message: 'Join a challenge or create your own to start competing!',
        buttonText: 'Join Challenge',
        onPressed: () {
          setState(() {
            _showJoinModal = true;
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...currentChallenges
            .map((challenge) => _buildCurrentChallengeCard(challenge)),
        const SizedBox(height: 16),
        _buildRecentOrdersCard(),
      ],
    );
  }

  Widget _buildCurrentChallengeCard(Map<String, dynamic> challenge) {
    final currentValue =
        (challenge['initialInvestment'] * (1 + challenge['returnRate'] / 100))
            .round();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ends on ${challenge['endDate']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rank: ${challenge['myRank']}/${challenge['participants']}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Initial',
                    '\$${challenge['initialInvestment'].toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'Current',
                    '\$${currentValue.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    'Return',
                    '+${challenge['returnRate']}%',
                    valueColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton2(
                    icon: Icons.attach_money,
                    label: 'Trade',
                    color: AppTheme.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      // Navigate to Trade screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TradeScreen(
                            challengeData: {
                              'name': challenge['name'],
                              'cash': 8242.54,
                              'portfolioValue': 10458.76,
                              'returnRate': 4.6
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton2(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chat',
                    color: Colors.grey.shade100,
                    textColor: Colors.grey.shade700,
                    onPressed: () {
                      // Navigate to Chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            challengeData: {
                              'name': challenge['name'],
                              'participants': challenge['participants'],
                              'endDate': challenge['endDate'],
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton2(
                    icon: Icons.people_outline,
                    label: 'Orders',
                    color: Colors.grey.shade100,
                    textColor: Colors.grey.shade700,
                    onPressed: () {
                      // Navigate to Orders screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(
                            challengeData: {
                              'name': challenge['name'],
                              'participants': challenge['participants'],
                              'endDate': challenge['endDate'],
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton2({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildRecentOrdersCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ...recentOrders.map((order) => _buildOrderItem(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final bool isBuy = order['action'] == 'Buy';
    final Color actionColor = isBuy ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: actionColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isBuy ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: actionColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['symbol'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${order['user']} • ${order['time']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order['action'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: actionColor,
                ),
              ),
              Text(
                '${order['shares']} @ \$${order['price']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartingTodaySection() {
    if (startingTodayChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: 'No Challenges Today',
        message: 'Check back tomorrow or create your own challenge!',
        buttonText: 'Create Challenge',
        onPressed: () {
          setState(() {
            _showCreateModal = true;
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text(
              'Challenges Starting Today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...startingTodayChallenges.map((challenge) => _buildChallengeCard(
              challenge,
              showNew: true,
              actionText: 'Join Challenge',
              onAction: () {
                setState(() {
                  _showJoinModal = true;
                });
              },
            )),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    if (upcomingChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: 'No Upcoming Challenges',
        message: 'Create your own challenge and invite others!',
        buttonText: 'Create Challenge',
        onPressed: () {
          setState(() {
            _showCreateModal = true;
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text(
              'Challenges Starting in Next 5 Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...upcomingChallenges.map((challenge) => _buildChallengeCard(
              challenge,
              showNew: false,
              actionText: 'Join Challenge',
              onAction: () {
                setState(() {
                  _showJoinModal = true;
                });
              },
            )),
      ],
    );
  }

  Widget _buildCompletedSection() {
    if (completedChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.emoji_events,
        title: 'No Completed Challenges',
        message: 'Join a challenge to see results here!',
        buttonText: 'Join Challenge',
        onPressed: () {
          setState(() {
            _showJoinModal = true;
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Text(
              'Recently Completed Challenges',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...completedChallenges
            .map((challenge) => _buildCompletedChallengeCard(challenge)),
      ],
    );
  }

  Widget _buildChallengeCard(
    Map<String, dynamic> challenge, {
    required bool showNew,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                          Text(
                            challenge['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (showNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'New',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Starts: ${challenge['startDate']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Duration: ${challenge['duration']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${challenge['participants']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      challenge['entryFee'],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(actionText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      Text(
                        challenge['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ended: ${challenge['endDate']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Winner: ${challenge['winner']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Top Return',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '+${challenge['returnRate']}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${challenge['participants']} participants',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // View results logic
                  },
                  icon: const Text(
                    'View Results',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  label: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
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
        if (index == 1) {
          // Navigate to Learning screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LearningScreen()),
          );
        } else if (index == 0) {
          // Navigate to Tools screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 2) {
          // Navigate to Tools screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ToolsScreen()),
          );
        } else if (index == 3) {
          // Navigate to Research screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResearchScreen()),
          );
        } else if (index == 4) {
          // Navigate to Research screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ArenaScreen()),
          );
        }
        // For Home (index == 0), we're already here
        // Research and Arena screens would be added later
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
