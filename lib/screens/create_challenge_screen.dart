import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/screens/chat_screen.dart';
import 'package:intl/intl.dart';

class CreateChallengeScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onChallengeCreated;

  const CreateChallengeScreen({
    Key? key, 
    this.onChallengeCreated,
  }) : super(key: key);

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  int _currentStep = 1;
  List<int> _selectedBaskets = [];
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();
  
  // Form data
  final Map<String, dynamic> _formData = {
    'challengeName': '',
    'description': '',
    'startDate': DateTime.now().add(const Duration(days: 1)),
    'endDate': DateTime.now().add(const Duration(days: 8)),
    'initialInvestment': 100,
    'recurringInvestment': 100,
    'recurringFrequency': 'week',
    'interestRate': 4,
    'tradesVisible': true,
    'inviteOnly': false,
    'invitedUsers': <Map<String, dynamic>>[],
  };
  
  // Sample basket data
  final List<Map<String, dynamic>> _baskets = [
    {'id': 1, 'name': 'All Stocks', 'icon': '📈', 'count': 3500, 'description': 'All available stocks in the market'},
    {'id': 2, 'name': 'All ETFs', 'icon': '🔄', 'count': 450, 'description': 'Exchange-traded funds across all sectors'},
    {'id': 3, 'name': 'All Crypto', 'icon': '₿', 'count': 100, 'description': 'Major cryptocurrencies and tokens'},
    {'id': 4, 'name': 'S&P 500', 'icon': '🏛️', 'count': 500, 'description': 'Top 500 US companies by market cap'},
    {'id': 5, 'name': 'Nasdaq 100', 'icon': '💻', 'count': 100, 'description': 'Largest non-financial companies on Nasdaq'},
    {'id': 6, 'name': 'Tech Giants', 'icon': '🌐', 'count': 15, 'description': 'Major technology companies'},
    {'id': 7, 'name': 'Financial Sector', 'icon': '💰', 'count': 80, 'description': 'Banks, insurance, and financial services'},
    {'id': 8, 'name': 'Healthcare', 'icon': '⚕️', 'count': 75, 'description': 'Pharmaceuticals and healthcare providers'},
    {'id': 9, 'name': 'Consumer Staples', 'icon': '🛒', 'count': 45, 'description': 'Essential consumer goods companies'},
    {'id': 10, 'name': 'Green Energy', 'icon': '♻️', 'count': 30, 'description': 'Renewable energy and clean tech'},
  ];
  
  // Sample users for invitation
  final List<Map<String, dynamic>> _users = [
    {'id': 1, 'name': 'trader_joe', 'avatar': '👨‍💼'},
    {'id': 2, 'name': 'stockwhiz', 'avatar': '👩‍💻'},
    {'id': 3, 'name': 'investor123', 'avatar': '🧔'},
    {'id': 4, 'name': 'market_guru', 'avatar': '🧙‍♂️'},
    {'id': 5, 'name': 'value_hunter', 'avatar': '🕵️'},
    {'id': 6, 'name': 'bull_trader', 'avatar': '🐂'},
    {'id': 7, 'name': 'bear_investor', 'avatar': '🐻'},
    {'id': 8, 'name': 'crypto_king', 'avatar': '👑'},
  ];

  void _toggleBasket(int basketId) {
    setState(() {
      if (_selectedBaskets.contains(basketId)) {
        _selectedBaskets.remove(basketId);
      } else {
        _selectedBaskets.add(basketId);
      }
    });
  }
  
  void _addInvitedUser(int userId) {
    final userToAdd = _users.firstWhere((user) => user['id'] == userId);
    final List<Map<String, dynamic>> currentUsers = List<Map<String, dynamic>>.from(_formData['invitedUsers']);
    
    if (!currentUsers.any((user) => user['id'] == userId)) {
      setState(() {
        currentUsers.add(userToAdd);
        _formData['invitedUsers'] = currentUsers;
      });
    }
  }
  
  void _removeInvitedUser(int userId) {
    final List<Map<String, dynamic>> currentUsers = List<Map<String, dynamic>>.from(_formData['invitedUsers']);
    setState(() {
      _formData['invitedUsers'] = currentUsers.where((user) => user['id'] != userId).toList();
    });
  }
  
  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }
  
  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }
  
  void _handleCreateChallenge() {
    // Combine form data with selected baskets
    final challengeData = {
      ..._formData,
      'selectedBaskets': _selectedBaskets,
    };
    
    // Handle challenge creation
    if (widget.onChallengeCreated != null) {
      widget.onChallengeCreated!(challengeData);
    }
    
    // Navigate back
    Navigator.pop(context);
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
                _buildProgressIndicator(),
                Expanded(
                  child: _buildCurrentStep(),
                ),
              ],
            ),
            _buildFloatingButtons(),
          ],
        ),
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
            'Create Challenge',
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
  
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepCircle(1),
              Expanded(
                child: Container(
                  height: 2,
                  color: _currentStep >= 2 ? AppTheme.primaryColor : Colors.grey.shade300,
                ),
              ),
              _buildStepCircle(2),
              Expanded(
                child: Container(
                  height: 2,
                  color: _currentStep >= 3 ? AppTheme.primaryColor : Colors.grey.shade300,
                ),
              ),
              _buildStepCircle(3),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Assets',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Privacy',
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
  
  Widget _buildStepCircle(int step) {
    final bool isActive = _currentStep >= step;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }
  
  // Step 1: Challenge Details
  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Challenge Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Challenge Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Challenge Name *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: _formData['challengeName'],
                decoration: InputDecoration(
                  hintText: 'E.g., Weekly Stock Battle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a challenge name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _formData['challengeName'] = value;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(
                  hintText: 'Tell participants what this challenge is about...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _formData['description'] = value;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Start and End Dates
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Date *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _formData['startDate'] ?? DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _formData['startDate'] = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM d, y').format(_formData['startDate']),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Date *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _formData['endDate'] ?? DateTime.now().add(const Duration(days: 8)),
                          firstDate: _formData['startDate'] ?? DateTime.now().add(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _formData['endDate'] = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM d, y').format(_formData['endDate']),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Initial Investment
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Initial Investment Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: _formData['initialInvestment'].toString(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _formData['initialInvestment'] = int.tryParse(value) ?? 100;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Recurring Investment
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recurring Investment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: _formData['recurringInvestment'].toString(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _formData['recurringInvestment'] = int.tryParse(value) ?? 100;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _formData['recurringFrequency'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      isExpanded: true,
                      isDense: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'day',
                          child: Text('daily', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'week',
                          child: Text('weekly', style: TextStyle(fontSize: 13)),
                        ),
                        DropdownMenuItem(
                          value: 'month',
                          child: Text('monthly', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _formData['recurringFrequency'] = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Interest Rate
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interest Rate for Cash (%)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: _formData['interestRate'].toString(),
                decoration: InputDecoration(
                  suffixText: '%',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _formData['interestRate'] = double.tryParse(value) ?? 4.0;
                },
              ),
              const SizedBox(height: 4),
              Text(
                'This is the interest rate applied to cash holdings in the challenge.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Next Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _formData['challengeName'].isNotEmpty) {
                _nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _formData['challengeName'].isNotEmpty ? AppTheme.primaryColor : Colors.grey.shade300,
              foregroundColor: _formData['challengeName'].isNotEmpty ? Colors.white : Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Next: Select Investment Universe'),
          ),
        ],
      ),
    );
  }
  
  // Step 2: Select Investment Universe (Baskets)
  Widget _buildStep2() {
    // Filter baskets based on search
    final filteredBaskets = _baskets.where((basket) {
      return basket['name'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
             basket['description'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Select Investment Universe',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose which assets participants can trade in this challenge:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Search
        TextField(
          decoration: InputDecoration(
            hintText: 'Search baskets...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Baskets List
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredBaskets.length,
            itemBuilder: (context, index) {
              final basket = filteredBaskets[index];
              final isSelected = _selectedBaskets.contains(basket['id']);
              
              return GestureDetector(
                onTap: () => _toggleBasket(basket['id']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            basket['icon'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              basket['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              basket['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${basket['count']} assets',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                              ),
                            ),
                            child: isSelected 
                              ? const Icon(Icons.check, size: 16, color: Colors.white) 
                              : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Info Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedBaskets.isNotEmpty
                      ? "You've selected ${_selectedBaskets.length} basket${_selectedBaskets.length > 1 ? 's' : ''}. Participants will be able to trade all assets within these baskets."
                      : "Select at least one basket to continue. Participants will only be able to trade assets within your selected baskets.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Navigation Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
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
                onPressed: _selectedBaskets.isNotEmpty ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedBaskets.isNotEmpty ? AppTheme.primaryColor : Colors.grey.shade300,
                  foregroundColor: _selectedBaskets.isNotEmpty ? Colors.white : Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Next: Privacy & Invitations'),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Step 3: Privacy & Invitations
  Widget _buildStep3() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Privacy & Invitations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure who can join and what they can see:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Trades Visible Toggle
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trades visible to all',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'All participants can see each other\'s trades',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _formData['tradesVisible'],
                onChanged: (value) {
                  setState(() {
                    _formData['tradesVisible'] = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Invite Only Toggle
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invite only',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Only invited users can join this challenge',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _formData['inviteOnly'],
                onChanged: (value) {
                  setState(() {
                    _formData['inviteOnly'] = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Invite Members (if invite only is enabled)
        if (_formData['inviteOnly'])
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Invite Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select users to invite:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              
              // Users list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final List<Map<String, dynamic>> invitedUsers = _formData['invitedUsers'];
                  final bool isInvited = invitedUsers.any((u) => u['id'] == user['id']);
                  
                  if (isInvited) return const SizedBox.shrink();
                  
                  return GestureDetector(
                    onTap: () => _addInvitedUser(user['id']),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user['avatar'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.add, color: AppTheme.primaryColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Invited users list
              if (_formData['invitedUsers'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invited (${_formData['invitedUsers'].length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(maxHeight: 160),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _formData['invitedUsers'].length,
                        itemBuilder: (context, index) {
                          final user = _formData['invitedUsers'][index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: index < _formData['invitedUsers'].length - 1 ? Colors.grey.shade300 : Colors.transparent,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      user['avatar'],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    user['name'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _removeInvitedUser(user['id']),
                                  child: const Icon(Icons.close, color: Colors.red, size: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 24),
        
        // Navigation Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
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
                onPressed: _handleCreateChallenge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Create Challenge'),
              ),
            ),
          ],
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
                  builder: (context) => const ChatScreen(),
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
  
  // Bottom navigation bar removed as requested
}