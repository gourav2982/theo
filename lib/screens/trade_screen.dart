import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/screens/chat_screen.dart';

class TradeScreen extends StatefulWidget {
  final Map<String, dynamic>? challengeData;

  const TradeScreen({
    Key? key,
    this.challengeData,
  }) : super(key: key);

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String _orderType = 'buy';
  Map<String, dynamic>? _selectedStock;
  String _searchQuery = '';
  bool _showConfirmation = false;
  String _activeTab = 'chart';
  List<String> _selectedIndicators = ['ma'];
  String _selectedTimeframe = '1d';
  bool _showIndicatorMenu = false;
  bool _showOrderForm = false;
  int _quantity = 10;

  // Sample challenge data
  late final Map<String, dynamic> _challenge;

  // Sample stocks data
  final List<Map<String, dynamic>> _stocks = [
    {
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'price': 187.42,
      'change': 1.24,
      'changePercent': 0.67
    },
    {
      'symbol': 'MSFT',
      'name': 'Microsoft Corp.',
      'price': 423.18,
      'change': 5.76,
      'changePercent': 1.38
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com Inc.',
      'price': 178.75,
      'change': -2.43,
      'changePercent': -1.34
    },
    {
      'symbol': 'GOOGL',
      'name': 'Alphabet Inc.',
      'price': 152.38,
      'change': 0.87,
      'changePercent': 0.57
    },
    {
      'symbol': 'META',
      'name': 'Meta Platforms Inc.',
      'price': 486.18,
      'change': 7.65,
      'changePercent': 1.60
    },
    {
      'symbol': 'TSLA',
      'name': 'Tesla Inc.',
      'price': 175.34,
      'change': -4.23,
      'changePercent': -2.36
    },
    {
      'symbol': 'NVDA',
      'name': 'NVIDIA Corp.',
      'price': 926.74,
      'change': 18.45,
      'changePercent': 2.03
    },
    {
      'symbol': 'JPM',
      'name': 'JPMorgan Chase & Co.',
      'price': 198.48,
      'change': 1.12,
      'changePercent': 0.57
    }
  ];

  // Technical indicators
  final List<Map<String, dynamic>> _indicators = [
    {'id': 'ma', 'name': 'Moving Average', 'active': true},
    {'id': 'ema', 'name': 'Exponential MA', 'active': false},
    {'id': 'rsi', 'name': 'RSI', 'active': false},
    {'id': 'macd', 'name': 'MACD', 'active': false},
    {'id': 'bollinger', 'name': 'Bollinger Bands', 'active': false},
    {'id': 'volume', 'name': 'Volume', 'active': false},
    {'id': 'stochastic', 'name': 'Stochastic', 'active': false},
    {'id': 'adx', 'name': 'ADX', 'active': false}
  ];

  @override
  void initState() {
    super.initState();

    // Use provided challenge data or default
    _challenge = widget.challengeData ?? {
      'name': "S&P 500 Weekly Challenge",
      'cash': 8242.54,
      'portfolioValue': 10458.76,
      'returnRate': 4.6
    };
  }

  // Filter stocks based on search query
  List<Map<String, dynamic>> _getFilteredStocks() {
    if (_searchQuery.isEmpty) {
      return _stocks;
    }
    
    return _stocks.where((stock) {
      return stock['symbol'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             stock['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _handleStockSelect(Map<String, dynamic> stock) {
    setState(() {
      _selectedStock = stock;
      _activeTab = 'chart';
    });
  }

  void _handlePlaceOrder() {
    setState(() {
      _showConfirmation = true;
    });
  }

  void _handleConfirmOrder() {
    // Logic to place order
    setState(() {
      _showConfirmation = false;
      _showOrderForm = false;
    });
    // In a real app, you'd show a success message and update the portfolio
  }

  void _toggleIndicator(String id) {
    setState(() {
      if (_selectedIndicators.contains(id)) {
        _selectedIndicators.remove(id);
      } else {
        _selectedIndicators.add(id);
      }
    });
  }

  void _adjustQuantity(int amount) {
    setState(() {
      _quantity = (_quantity + amount).clamp(1, 1000);
    });
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
                _buildPortfolioSummary(),
                Expanded(
                  child: _selectedStock != null
                      ? _buildChartView()
                      : _buildStockSelection(),
                ),
              ],
            ),
          ),
          _buildFloatingButtons(),
          if (_showOrderForm) _buildOrderForm(),
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
            'Trade',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryColor.withOpacity(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _challenge['name'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cash Available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                '\$${_challenge['cash'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio Value',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$${_challenge['portfolioValue'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${_challenge['returnRate']}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
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

  Widget _buildStockSelection() {
    final filteredStocks = _getFilteredStocks();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search stocks...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Stocks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = filteredStocks[index];
                      final isPositive = stock['change'] >= 0;
                      
                      return GestureDetector(
                        onTap: () => _handleStockSelect(stock),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          stock['symbol'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          stock['name'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
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
                                    '\$${stock['price'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${isPositive ? '+' : ''}${stock['change'].toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock['changePercent'].toStringAsFixed(2)}%)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isPositive ? Colors.green : Colors.red,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartView() {
    final stock = _selectedStock!;
    final isPositive = stock['change'] >= 0;
    
    return Column(
      children: [
        // Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              _buildTabButton('chart', 'Chart'),
              _buildTabButton('overview', 'Overview'),
              _buildTabButton('news', 'News'),
            ],
          ),
        ),
        
        // Chart Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock['symbol'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stock['name'],
                      style: TextStyle(
                        fontSize: 14,
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
                    stock['price'].toStringAsFixed(2),  
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${isPositive ? '+' : ''}${stock['change'].toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock['changePercent'].toStringAsFixed(2)}%)',
                    style: TextStyle(
                      fontSize: 14,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Tab Content - ensuring content is scrollable to prevent overflow
        Expanded(
          child: _activeTab == 'chart' ? _buildChartTab() : 
                 _activeTab == 'overview' ? _buildOverviewTab() : 
                 _buildNewsTab(),
        ),
        
        // Buy/Sell Buttons
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _orderType = 'buy';
                      _showOrderForm = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: const Text('Buy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _orderType = 'sell';
                      _showOrderForm = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_downward, size: 16),
                  label: const Text('Sell'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String tabId, String label) {
    final isActive = _activeTab == tabId;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = tabId;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppTheme.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartTab() {
    // Wrapping the chart tab in a ListView to make it scrollable
    return ListView(
      children: [
        // Chart Controls
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timeframe buttons
              Row(
                children: [
                  _buildTimeframeButton('1d', '1D'),
                  _buildTimeframeButton('1w', '1W'),
                  _buildTimeframeButton('1m', '1M'),
                  _buildTimeframeButton('3m', '3M'),
                  _buildTimeframeButton('1y', '1Y'),
                ],
              ),
              
              // Indicators dropdown
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showIndicatorMenu = !_showIndicatorMenu;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Indicators',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Indicators Menu (if shown)
        if (_showIndicatorMenu)
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Technical Indicators',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                ...List.generate(_indicators.length, (index) {
                  final indicator = _indicators[index];
                  final isSelected = _selectedIndicators.contains(indicator['id']);
                  
                  return InkWell(
                    onTap: () => _toggleIndicator(indicator['id']),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade400,
                              ),
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            indicator['name'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        
        // Chart Area
        Container(
          height: 250,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Example chart placeholder
                Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
                
                // Indicator labels
                Positioned(
                  top: 8,
                  left: 8,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _selectedIndicators.map((id) {
                      final indicator = _indicators.firstWhere(
                        (ind) => ind['id'] == id,
                        orElse: () => {'name': id},
                      );
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          indicator['name'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Timeframe indicator
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selectedTimeframe.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Technical Analysis
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Technical Analysis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Buy Signal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Analysis rows
              if (_selectedIndicators.contains('ma'))
                _buildAnalysisRow('Moving Average (50)', 'Bullish', true),
              if (_selectedIndicators.contains('rsi'))
                _buildAnalysisRow('RSI (14)', 'Neutral (58)', null),
              if (_selectedIndicators.contains('macd'))
                _buildAnalysisRow('MACD', 'Bullish', true),
              if (_selectedIndicators.contains('bollinger'))
                _buildAnalysisRow('Bollinger Bands', 'Upper Band Test', true),
            ],
          ),
        ),
        
        // Strategy Insights
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Strategy Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Momentum Strategy
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Momentum Strategy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Strong uptrend detected. Price above 50-day moving average with increasing volume. Consider entry with stop loss at \$180.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Value Strategy
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Value Strategy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Current P/E ratio of 28.5 is slightly above sector average. Wait for better entry point.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Adding some bottom padding to ensure no overflow
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeframeButton(String timeframe, String label) {
    final isSelected = _selectedTimeframe == timeframe;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeframe = timeframe;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, bool? isBullish) {
    Color valueColor;
    
    if (isBullish == null) {
      valueColor = Colors.grey;
    } else if (isBullish) {
      valueColor = Colors.green;
    } else {
      valueColor = Colors.red;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Company Profile
        const Text(
          'Company Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
                  Expanded(
                    child: _buildCompanyDetail('Industry', 'Consumer Electronics'),
                  ),
                  Expanded(
                    child: _buildCompanyDetail('Sector', 'Technology'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCompanyDetail('CEO', 'Tim Cook'),
                  ),
                  Expanded(
                    child: _buildCompanyDetail('Founded', '1976'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildCompanyDetail('Headquarters', 'Cupertino, CA'),
                  ),
                  Expanded(
                    child: _buildCompanyDetail('Employees', '154,000+'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCompanyDetail(
                'About',
                'Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. The company offers iPhone, iPad, Mac, Apple Watch, and various related services. It also sells various related services including AppleCare, cloud services, digital content, and payment services.',
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Key Metrics
        const Text(
          'Key Metrics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            _buildMetricCard('Market Cap', '\$2.9T'),
            _buildMetricCard('P/E Ratio', '28.5'),
            _buildMetricCard('EPS (TTM)', '\$6.58'),
            _buildMetricCard('Dividend Yield', '0.54%'),
            _buildMetricCard('52-Week Range', '\$158.77 - \$199.62'),
            _buildMetricCard('Avg. Volume', '58.2M'),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Financial Highlights
        const Text(
          'Financial Highlights',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildFinancialRow('Revenue (TTM)', '\$394.3B'),
              _buildFinancialRow('Gross Margin', '44.1%'),
              _buildFinancialRow('Operating Margin', '30.5%'),
              _buildFinancialRow('Net Income (TTM)', '\$97.2B'),
              _buildFinancialRow('Cash on Hand', '\$62.5B', isLast: true),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Analyst Recommendations
        const Text(
          'Analyst Recommendations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.green,
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '22 Analysts',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnalystRating('Buy', '14', Colors.green.shade700),
                  _buildAnalystRating('Outperform', '5', Colors.green),
                  _buildAnalystRating('Hold', '3', Colors.grey),
                  _buildAnalystRating('Underperform', '0', Colors.red),
                  _buildAnalystRating('Sell', '0', Colors.red.shade700),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (!isLast)
            Divider(
              color: Colors.grey.shade300,
              height: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildAnalystRating(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsTab() {
    final newsItems = [
      {
        'source': 'MarketWatch',
        'time': '2 hours ago',
        'title': 'Apple unveils new AI features for iPhone, Mac in latest software update',
        'content': 'Apple Inc. announced a suite of new AI-powered features coming to iPhones and Macs later this year, signaling the company\'s push into the rapidly evolving artificial intelligence space.',
      },
      {
        'source': 'Bloomberg',
        'time': '5 hours ago',
        'title': 'Apple\'s services revenue hits all-time high, boosting quarterly results',
        'content': 'Apple reported better-than-expected quarterly results, helped by record services revenue. The company\'s subscription offerings, including Apple Music, TV+, and iCloud, continue to drive growth amid maturing iPhone sales.',
      },
      {
        'source': 'CNBC',
        'time': 'Yesterday',
        'title': 'Apple\'s next iPhone could feature significant camera upgrades, analysts say',
        'content': 'Supply chain reports suggest Apple\'s upcoming iPhone models will feature significant camera upgrades, including a new periscope lens for improved optical zoom and enhanced low-light performance.',
      },
      {
        'source': 'Reuters',
        'time': 'Yesterday',
        'title': 'Apple expands production in India amid supply chain diversification efforts',
        'content': 'Apple is accelerating its manufacturing expansion in India, with the country now accounting for nearly 7% of global iPhone production. The move is part of Apple\'s broader strategy to diversify its supply chain beyond China.',
      },
      {
        'source': 'Financial Times',
        'time': '2 days ago',
        'title': 'Apple increases dividend by 5%, announces \$90 billion share buyback program',
        'content': 'Apple\'s board approved a 5% increase in the company\'s quarterly dividend and authorized an additional \$90 billion for share repurchases, underscoring the tech giant\'s commitment to returning capital to shareholders.',
      },
    ];
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: newsItems.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        height: 32,
      ),
      itemBuilder: (context, index) {
        final news = newsItems[index];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  news['source']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  news['time']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              news['title']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news['content']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Read more',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderForm() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_orderType == 'buy' ? 'Buy' : 'Sell'} ${_selectedStock!['symbol']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showOrderForm = false;
                        });
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Type
                    const Text(
                      'Order Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: 'market',
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'market',
                            child: Text('Market Order'),
                          ),
                          DropdownMenuItem(
                            value: 'limit',
                            child: Text('Limit Order'),
                          ),
                          DropdownMenuItem(
                            value: 'stop',
                            child: Text('Stop Order'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Quantity
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _adjustQuantity(-1),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              _quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _adjustQuantity(1),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Order summary
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Fixed: Market Price row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Market Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "\$${_selectedStock!['price'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          
                          // Fixed: Quantity row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          
                          // Fixed: Estimated Fee row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Estimated Fee',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: const Text(
                                  "\$0.00",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          
                          // Fixed: Total Value row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: const Text(
                                  'Total Value',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "\${(_selectedStock!['price'] * _quantity).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This is a paper trading challenge. No real money will be used.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Place order button
                    ElevatedButton(
                      onPressed: _handlePlaceOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orderType == 'buy' ? Colors.green : Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Place ${_orderType == 'buy' ? 'Buy' : 'Sell'} Order'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationModal() {
    final totalValue = _selectedStock!['price'] * _quantity;
    
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Fixed: Action row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Action',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _orderType == 'buy' ? 'Buy' : 'Sell',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _orderType == 'buy' ? Colors.green : Colors.red,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Fixed: Stock row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Stock',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _selectedStock!['symbol'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Fixed: Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "\$${_selectedStock!['price'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Fixed: Quantity row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    
                    // Fixed: Total row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "\$${totalValue.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showConfirmation = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleConfirmOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _orderType == 'buy' ? Colors.green : Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      bottom: 20,
      left: 16,
      child: FloatingActionButton(
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
    );
  }
}