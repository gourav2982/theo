import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/screens/chat_screen.dart';

class JoinChallengeScreen extends StatefulWidget {
  final Map<String, dynamic>? challengeData;
  final Function(Map<String, dynamic>)? onJoinComplete;

  const JoinChallengeScreen({
    Key? key,
    this.challengeData,
    this.onJoinComplete,
  }) : super(key: key);

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {
  String? _joinMethod; // null, 'manual', or 'auto'
  int? _selectedStrategy;
  String _tradingMode = 'auto';
  bool _showConfirmation = false;

  // Sample challenge data (use widget.challengeData if provided)
  late final Map<String, dynamic> _challenge;

  // Sample trading strategies
  final List<Map<String, dynamic>> _strategies = [
    {
      'id': 1,
      'name': "Momentum Trader",
      'description': "Follows market trends and momentum indicators",
      'winRate': 68,
      'returnRate': 12.4,
      'suitable': ["stocks", "etfs"],
      'stats': [
        {'label': "Win Rate", 'value': "68%"},
        {'label': "Avg. Return", 'value': "+12.4%"},
        {'label': "Max Drawdown", 'value': "8.2%"}
      ]
    },
    {
      'id': 2,
      'name': "Value Investor",
      'description': "Focuses on undervalued stocks with strong fundamentals",
      'winRate': 72,
      'returnRate': 8.9,
      'suitable': ["stocks"],
      'stats': [
        {'label': "Win Rate", 'value': "72%"},
        {'label': "Avg. Return", 'value': "+8.9%"},
        {'label': "Max Drawdown", 'value': "5.7%"}
      ]
    },
    {
      'id': 3,
      'name': "Dynamic Allocator",
      'description': "Balances risk across sectors based on market conditions",
      'winRate': 65,
      'returnRate': 10.5,
      'suitable': ["stocks", "etfs"],
      'stats': [
        {'label': "Win Rate", 'value': "65%"},
        {'label': "Avg. Return", 'value': "+10.5%"},
        {'label': "Max Drawdown", 'value': "7.3%"}
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    
    // Use provided challenge data or default
    _challenge = widget.challengeData ?? {
      'id': 1,
      'name': "S&P 500 Weekly Challenge",
      'creator': "market_guru",
      'creatorAvatar': "🧙‍♂️",
      'startDate': "Mar 15, 2025",
      'endDate': "Mar 22, 2025",
      'duration': "7 days",
      'participants': 142,
      'initialInvestment': 10000,
      'category': "stocks",
      'description': "Compete against others with stocks from the S&P 500 index. Show your trading skills and climb the leaderboard.",
      'universes': ["S&P 500"],
      'rules': [
        "Starting capital: \$10,000",
        "Trading only S&P 500 stocks",
        "Maximum 10 trades per day",
        "No shorting allowed",
        "All trades visible to participants"
      ]
    };
  }

  // Get available strategies for the challenge
  List<Map<String, dynamic>> _getAvailableStrategies() {
    return _strategies.where((strategy) {
      List<String> suitable = List<String>.from(strategy['suitable']);
      return suitable.contains(_challenge['category']);
    }).toList();
  }

  void _handleJoinMethodSelect(String method) {
    setState(() {
      _joinMethod = method;
      if (method == 'auto') {
        // Pre-select the first available strategy
        final availableStrategies = _getAvailableStrategies();
        if (availableStrategies.isNotEmpty) {
          _selectedStrategy = availableStrategies[0]['id'];
        }
      }
    });
  }

  void _handleJoinChallenge() {
    // Here you would send the join request to your backend
    final joinData = {
      'challengeId': _challenge['id'],
      'method': _joinMethod,
      'strategyId': _selectedStrategy,
      'tradingMode': _tradingMode
    };
    
    print("Joining challenge: $joinData");
    
    // Show confirmation modal
    setState(() {
      _showConfirmation = true;
    });
  }

  void _handleConfirmJoin() {
    // Call the callback if provided
    if (widget.onJoinComplete != null) {
      final joinData = {
        'challengeId': _challenge['id'],
        'method': _joinMethod,
        'strategyId': _selectedStrategy,
        'tradingMode': _tradingMode
      };
      widget.onJoinComplete!(joinData);
    }
    
    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
          _buildFloatingButtons(),
          if (_showConfirmation) _buildConfirmationModal(),
        ],
      ),
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
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          const Text(
            'Join Challenge',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Icon(Icons.emoji_events, color: Colors.white),
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
          _buildChallengeDetailsCard(),
          const SizedBox(height: 16),
          _buildParticipationOptions(),
        ],
      ),
    );
  }

  Widget _buildChallengeDetailsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
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
                  child: Text(
                    _challenge['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _challenge['category'] == 'stocks' ? 'Stocks' :
                    _challenge['category'] == 'crypto' ? 'Crypto' : 'ETFs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Creator info
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _challenge['creatorAvatar'],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Created by ${_challenge['creator']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Popular Challenge',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              _challenge['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            
            // Challenge metrics grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.calendar_today,
                    label: 'Start Date',
                    value: _challenge['startDate'],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.calendar_today,
                    label: 'End Date',
                    value: _challenge['endDate'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.attach_money,
                    label: 'Initial Investment',
                    value: '\$${_challenge['initialInvestment'].toString()}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.people,
                    label: 'Participants',
                    value: _challenge['participants'].toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Rules section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Challenge Rules',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_challenge['rules'] as List<String>).map((rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rule,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationOptions() {
    if (_joinMethod == null) {
      return _buildJoinMethodSelection();
    } else if (_joinMethod == 'manual') {
      return _buildManualTradingOption();
    } else {
      return _buildAutoStrategyOption();
    }
  }

  Widget _buildJoinMethodSelection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you like to participate?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Manual Trading Option
            InkWell(
              onTap: () => _handleJoinMethodSelect('manual'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.attach_money,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manual Trading',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Make all trading decisions yourself. Buy and sell stocks at your discretion to maximize returns.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Auto Strategy Option
            InkWell(
              onTap: () => _handleJoinMethodSelect('auto'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Auto Strategy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Let an AI strategy handle your trades automatically or receive alerts to approve each trade.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualTradingOption() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.attach_money,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Trading',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'You\'ll place all trades yourself',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Information box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'ll receive trade alerts and can place trades through the app during market hours.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade800,
                            ),
                            children: [
                              const TextSpan(text: 'This challenge starts on '),
                              TextSpan(
                                text: _challenge['startDate'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' with an initial investment of '),
                              TextSpan(
                                text: '\$${_challenge['initialInvestment']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _joinMethod = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleJoinChallenge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Join Challenge'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoStrategyOption() {
    final availableStrategies = _getAvailableStrategies();
    final selectedStrategyData = availableStrategies.firstWhere(
      (strategy) => strategy['id'] == _selectedStrategy,
      orElse: () => availableStrategies.first,
    );
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Strategy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Let AI handle your trades',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Strategy selection section
            const Text(
              'Select a Strategy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableStrategies.length,
              itemBuilder: (context, index) {
                final strategy = availableStrategies[index];
                final isSelected = strategy['id'] == _selectedStrategy;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStrategy = strategy['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppTheme.primaryColor : Colors.white,
                            border: isSelected 
                                ? null 
                                : Border.all(color: Colors.grey.shade300),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strategy['name'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                strategy['description'],
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
                              '+${strategy['returnRate']}%',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${strategy['winRate']}% win rate',
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
                );
              },
            ),
            const SizedBox(height: 16),
            
            if (_selectedStrategy != null) ...[
              // Trading mode selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trading mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _tradingMode,
                      underline: const SizedBox.shrink(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'auto',
                          child: Text('Fully automatic', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'approve',
                          child: Text('Approve each trade', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'alerts',
                          child: Text('Alerts only', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _tradingMode = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Strategy stats
              Row(
                children: [
                  for (var stat in selectedStrategyData['stats']) Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            stat['label'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stat['value'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Warning/Info box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can change your strategy or switch to manual trading anytime during the challenge.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _joinMethod = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedStrategy != null ? _handleJoinChallenge : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStrategy != null 
                          ? AppTheme.primaryColor 
                          : Colors.grey.shade300,
                      foregroundColor: _selectedStrategy != null 
                          ? Colors.white 
                          : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Join with Strategy'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationModal() {
    String? strategyName;
    if (_joinMethod == 'auto' && _selectedStrategy != null) {
      strategyName = _strategies.firstWhere(
        (s) => s['id'] == _selectedStrategy,
        orElse: () => {'name': 'Unknown'},
      )['name'] as String?;
    }
    
    String tradingModeText = '';
    if (_tradingMode == 'auto') {
      tradingModeText = 'automatically trade';
    } else if (_tradingMode == 'approve') {
      tradingModeText = 'suggest trades for your approval';
    } else {
      tradingModeText = 'send you alerts';
    }
    
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 32,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Successfully Joined!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'ve joined ${_challenge['name']}. The challenge starts on ${_challenge['startDate']}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                
                if (_joinMethod == 'auto' && strategyName != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade800,
                        ),
                        children: [
                          const TextSpan(text: 'Your selected strategy, '),
                          TextSpan(
                            text: strategyName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ', will $tradingModeText.'),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleConfirmJoin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Go to Arena'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Column(
        children: [
          // Chat Button
          FloatingActionButton(
            heroTag: 'chat',
            onPressed: () {
              // Open chat with Theo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.chat_bubble_outline, size: 20),
          ),
          const SizedBox(height: 12),
          
          // Share Button
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () {},
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.share, size: 20),
          ),
        ],
      ),
    );
  }
}