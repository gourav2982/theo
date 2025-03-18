// screens/research_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' show max;
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/research_data.dart';
import 'package:theo/models/research_models.dart';
import 'package:theo/screens/arena_screen.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/chat_service.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({Key? key}) : super(key: key);

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 3; // Research tab is selected by default
  late TabController _tabController;
  String _searchQuery = '';

  // Data
  late List<ResearchTab> _tabs;
  late List<Stock> _stocks;
  late List<Option> _options;
  late List<Sector> _sectors;
  late List<ETF> _etfs;
  late List<ChartPoint> _chartPoints;
  late List<StockInsight> _insights;

  @override
  void initState() {
    super.initState();
    
    // Load data
    _tabs = ResearchData.getTabs();
    _stocks = ResearchData.getStocks();
    _options = ResearchData.getOptions();
    _sectors = ResearchData.getSectors();
    _etfs = ResearchData.getETFs();
    _chartPoints = ResearchData.getTeslaChartPoints();
    _insights = ResearchData.getTeslaInsights();
    
    // Initialize tab controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDeepAnalysisTab(),
                _buildStockRankerTab(),
                _buildOptionsRankerTab(),
                _buildSectorRankerTab(),
                _buildETFRankerTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButtons(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1E3A8A),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Text(
              'HeyTheo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Expanded(
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search stocks...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70, size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        tabs: _tabs.map((tab) {
          return Tab(
            height: 50,
            child: Row(
              children: [
                Icon(tab.icon, size: 20),
                const SizedBox(width: 8),
                Text(tab.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Deep Analysis Tab
  Widget _buildDeepAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deep Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Stock Analysis Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analyze a Stock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter stock symbol...',
                            prefixText: '',
                            suffixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          controller: TextEditingController(text: 'TSLA'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Generate Analysis'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stock Analysis Result
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF1E3A8A),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tesla Inc. (TSLA)',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  '\$242.92',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+5.32 (2.24%)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade300,
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
                            'Last Updated',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade200,
                            ),
                          ),
                          const Text(
                            'Mar 13, 2025 4:00 PM EST',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Metrics
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildMetricCard(
                            title: 'AI Score',
                            value: '87',
                            badge: 'Strong Buy',
                            badgeColor: Colors.green,
                          ),
                          _buildMetricCard(
                            title: 'Market Sentiment',
                            value: 'Bullish',
                            iconData: Icons.arrow_upward,
                            iconColor: Colors.green,
                          ),
                          _buildMetricCard(
                            title: 'Risk Level',
                            value: 'Medium',
                            iconData: Icons.arrow_right_alt,
                            iconColor: Colors.amber,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Performance Chart
                      const Text(
                        'Performance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 250,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildStockChart(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Key Insights
                      const Text(
                        'Key Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._insights.map((insight) => _buildInsightCard(insight)).toList(),
                      
                      const SizedBox(height: 24),
                      
                      // Fundamentals and Prediction
                      Wrap(
                        spacing: 16,
                        runSpacing: 24,
                        children: [
                          // Fundamentals
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width > 600 
                                ? 300 
                                : MediaQuery.of(context).size.width - 64,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fundamentals',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildKeyValuePair('Market Cap', '\$771.2B'),
                                _buildKeyValuePair('P/E Ratio', '64.5'),
                                _buildKeyValuePair('Revenue (TTM)', '\$87.6B'),
                                _buildKeyValuePair('EPS', '\$3.76'),
                                _buildKeyValuePair('52-Week Range', '\$138.80 - \$299.29', hasDivider: false),
                              ],
                            ),
                          ),
                          
                          // AI Prediction
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width > 600 
                                ? 300 
                                : MediaQuery.of(context).size.width - 64,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI Prediction',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '6-Month Price Target',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '\$285.00',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade900,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '(+17.32%)',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'High Confidence',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? badge,
    Color? badgeColor,
    IconData? iconData,
    Color? iconColor,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 
          ? 180 
          : (MediaQuery.of(context).size.width - 56) / 3,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0FF), // Light blue color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF), // Dark blue color
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A), // Very dark blue
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor != null ? const Color(0xFFE6F9ED) : const Color(0xFFE6F9ED), // Light green
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor != null ? const Color(0xFF047857) : const Color(0xFF047857), // Dark green
                      ),
                    ),
                  ),
                ],
                if (iconData != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    iconData,
                    size: 16,
                    color: iconColor ?? Colors.green,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockChart() {
    return CustomPaint(
      painter: StockChartPainter(
        points: _chartPoints,
        lineColor: AppTheme.primaryColor,
        fillColor: AppTheme.primaryColor.withOpacity(0.2),
      ),
      size: const Size(double.infinity, double.infinity),
    );
  }

  Widget _buildInsightCard(StockInsight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: insight.backgroundColor,
        border: Border(
          left: BorderSide(
            color: insight.borderColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            insight.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValuePair(String key, String value, {bool hasDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        if (hasDivider) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  // Stock Ranker Tab
  Widget _buildStockRankerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Ranker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filters Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Basket',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['S&P 500', 'Nasdaq 100', 'Tech Sector', 'Healthcare', 'My Custom Basket'],
                              'S&P 500',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ranking Criteria',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['Growth Potential', 'Value', 'Momentum', 'Volatility', 'Sentiment'],
                              'Growth Potential',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Rank Stocks'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('RANK')),
                        DataColumn(label: Text('SYMBOL')),
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('PRICE')),
                        DataColumn(label: Text('SCORE')),
                        DataColumn(label: Text('SIGNAL')),
                      ],
                      rows: _stocks.asMap().entries.map((entry) {
                        final index = entry.key;
                        final stock = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(
                              Text(
                                stock.symbol,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(Text(stock.name)),
                            DataCell(Text('\$${stock.price.toStringAsFixed(2)}')),
                            DataCell(
                              _buildScoreBadge(stock.score),
                            ),
                            DataCell(
                              _buildSignalBadge(index % 3),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildScoreBadge(int score) {
    Color backgroundColor;
    Color textColor;
    
    if (score >= 90) {
      backgroundColor = const Color(0xFFE6F9ED); // Light green
      textColor = const Color(0xFF047857); // Dark green
    } else if (score >= 80) {
      backgroundColor = const Color(0xFFE6F0FF); // Light blue
      textColor = const Color(0xFF1E40AF); // Dark blue
    } else {
      backgroundColor = const Color(0xFFFFF8E6); // Light amber
      textColor = const Color(0xFFB45309); // Dark amber
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        score.toString(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSignalBadge(int type) {
    String text;
    Color backgroundColor;
    Color textColor;
    
    if (type == 0) {
      text = 'Buy';
      backgroundColor = const Color(0xFFE6F9ED); // Light green
      textColor = const Color(0xFF047857); // Dark green
    } else if (type == 1) {
      text = 'Hold';
      backgroundColor = const Color(0xFFFFF8E6); // Light amber
      textColor = const Color(0xFFB45309); // Dark amber
    } else {
      text = 'Sell';
      backgroundColor = const Color(0xFFFEE2E2); // Light red
      textColor = const Color(0xFFB91C1C); // Dark red
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // Options Ranker Tab
  Widget _buildOptionsRankerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options Ranker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filters Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Underlying Asset',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['All Optionable Stocks', 'S&P 500 Stocks', 'Tech Sector', 'My Watchlist'],
                              'All Optionable Stocks',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Option Type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['All', 'Calls', 'Puts'],
                              'All',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expiration',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['All Dates', 'This Week', 'Next Week', 'This Month', 'Next Month'],
                              'All Dates',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Find Options'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('RANK')),
                        DataColumn(label: Text('SYMBOL')),
                        DataColumn(label: Text('TYPE')),
                        DataColumn(label: Text('STRIKE')),
                        DataColumn(label: Text('EXP DATE')),
                        DataColumn(label: Text('PREMIUM')),
                        DataColumn(label: Text('PROBABILITY')),
                        DataColumn(label: Text('SCORE')),
                      ],
                      rows: _options.map((option) {
                        return DataRow(
                          cells: [
                            DataCell(Text(option.rank.toString())),
                            DataCell(
                              Text(
                                option.symbol,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(Text(option.type)),
                            DataCell(Text(option.strike)),
                            DataCell(Text(option.expDate)),
                            DataCell(Text(option.premium)),
                            DataCell(Text(option.probability)),
                            DataCell(_buildScoreBadge(option.score)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sector Ranker Tab
  Widget _buildSectorRankerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sector Ranker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filters Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ranking criteria toggle buttons
                  const Text(
                    'Ranking Criteria',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRankingButton('Performance', true),
                        const SizedBox(width: 8),
                        _buildRankingButton('Momentum', false),
                        const SizedBox(width: 8),
                        _buildRankingButton('Volatility', false),
                        const SizedBox(width: 8),
                        _buildRankingButton('Value', false),
                        const SizedBox(width: 8),
                        _buildRankingButton('Growth', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Sector performance chart
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: max(600, MediaQuery.of(context).size.width - 32), // minimum width of 600px
                        child: _buildSectorChart(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sectors table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('RANK')),
                        DataColumn(label: Text('SECTOR')),
                        DataColumn(label: Text('1-WEEK')),
                        DataColumn(label: Text('1-MONTH')),
                        DataColumn(label: Text('3-MONTH')),
                        DataColumn(label: Text('YTD')),
                        DataColumn(label: Text('SCORE')),
                      ],
                      rows: _sectors.map((sector) {
                        return DataRow(
                          cells: [
                            DataCell(Text(sector.rank.toString())),
                            DataCell(
                              Text(
                                sector.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector.oneWeek,
                                style: TextStyle(
                                  color: sector.oneWeek.startsWith('+') ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector.oneMonth,
                                style: TextStyle(
                                  color: sector.oneMonth.startsWith('+') ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector.threeMonth,
                                style: TextStyle(
                                  color: sector.threeMonth.startsWith('+') ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                sector.ytd,
                                style: TextStyle(
                                  color: sector.ytd.startsWith('+') ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(_buildScoreBadge(sector.score)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingButton(String label, bool isActive) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppTheme.primaryColor : Colors.grey.shade200,
        foregroundColor: isActive ? Colors.white : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildSectorChart() {
    return CustomPaint(
      painter: SectorChartPainter(sectors: _sectors),
      size: const Size(double.infinity, double.infinity),
    );
  }

  // ETF Ranker Tab
  Widget _buildETFRankerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ETF Ranker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Filters Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ETF Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['All ETFs', 'US Equity', 'International Equity', 'Fixed Income', 'Sector', 'Commodity'],
                              'All ETFs',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ranking Criteria',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdown(
                              ['Performance', 'Expense Ratio', 'Volatility', 'AUM', 'Dividend Yield'],
                              'Performance',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Rank ETFs'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('RANK')),
                        DataColumn(label: Text('SYMBOL')),
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('CATEGORY')),
                        DataColumn(label: Text('AUM')),
                        DataColumn(label: Text('YTD RETURN')),
                        DataColumn(label: Text('EXPENSE RATIO')),
                        DataColumn(label: Text('SCORE')),
                      ],
                      rows: _etfs.map((etf) {
                        return DataRow(
                          cells: [
                            DataCell(Text(etf.rank.toString())),
                            DataCell(
                              Text(
                                etf.symbol,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            DataCell(Text(etf.name)),
                            DataCell(Text(etf.category)),
                            DataCell(Text(etf.aum)),
                            DataCell(
                              Text(
                                etf.ytdReturn,
                                style: TextStyle(
                                  color: etf.ytdReturn.startsWith('+') ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(Text(etf.expenseRatio)),
                            DataCell(_buildScoreBadge(etf.score)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Stack(
      children: [
        // Share button
        Positioned(
          bottom: 160,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'share',
            onPressed: () {},
            backgroundColor: Colors.white,
            mini: true,
            child: Icon(Icons.share, size: 20, color: AppTheme.primaryColor),
          ),
        ),
        
        // Ask Theo button
        Positioned(
          bottom: 80,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'ask-theo',
            onPressed: () {
              // Open chat with Theo
              ChatService.openChat(context);
            },
            backgroundColor: AppTheme.primaryColor,
            label: const Text('Ask Theo'),
            icon: const Icon(Icons.message, size: 20),
          ),
        ),
      ],
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
        }else if (index == 0) {
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
        }else if (index == 3) {
        // Navigate to Research screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResearchScreen()),
        );
      }
      else if (index == 4) {
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

class StockChartPainter extends CustomPainter {
  final List<ChartPoint> points;
  final Color lineColor;
  final Color fillColor;

  StockChartPainter({
    required this.points,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define chart area
    const double paddingLeft = 50;
    const double paddingRight = 20;
    const double paddingTop = 20;
    const double paddingBottom = 40;
    
    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;
    
    // Draw grid lines
    final Paint gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    
    for (int i = 0; i < 5; i++) {
      final y = paddingTop + i * (chartHeight / 4);
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }
    
    // Draw axes
    final Paint axesPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    
    // X-axis
    canvas.drawLine(
      Offset(paddingLeft, size.height - paddingBottom),
      Offset(size.width - paddingRight, size.height - paddingBottom),
      axesPaint,
    );
    
    // Y-axis
    canvas.drawLine(
      Offset(paddingLeft, paddingTop),
      Offset(paddingLeft, size.height - paddingBottom),
      axesPaint,
    );
    
    // Draw axes labels
    const TextStyle labelStyle = TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 10,
    );
    
    // X-axis month labels
    final List<String> months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
    for (int i = 0; i < months.length; i++) {
      final x = paddingLeft + i * (chartWidth / (months.length - 1));
      final textSpan = TextSpan(text: months[i], style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - paddingBottom + 10),
      );
    }
    
    // Y-axis price labels
    final List<String> prices = ['\$300', '\$275', '\$250', '\$225', '\$200'];
    for (int i = 0; i < prices.length; i++) {
      final y = paddingTop + i * (chartHeight / (prices.length - 1));
      final textSpan = TextSpan(text: prices[i], style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }
    
    // Scale points to chart area
    final scaledPoints = points.map((point) {
      final x = paddingLeft + ((point.x - points.first.x) / (points.last.x - points.first.x)) * chartWidth;
      
      // Invert Y-axis (0 is at the top in the canvas)
      final minY = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
      final maxY = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);
      final y = paddingTop + (1 - ((point.y - minY) / (maxY - minY))) * chartHeight;
      
      return Offset(x, y);
    }).toList();
    
    // Draw the line
    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final Path linePath = Path();
    linePath.moveTo(scaledPoints.first.dx, scaledPoints.first.dy);
    
    for (int i = 1; i < scaledPoints.length; i++) {
      linePath.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }
    
    canvas.drawPath(linePath, linePaint);
    
    // Draw area under the line
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    
    final Path fillPath = Path();
    fillPath.moveTo(scaledPoints.first.dx, size.height - paddingBottom);
    fillPath.lineTo(scaledPoints.first.dx, scaledPoints.first.dy);
    
    for (int i = 1; i < scaledPoints.length; i++) {
      fillPath.lineTo(scaledPoints[i].dx, scaledPoints[i].dy);
    }
    
    fillPath.lineTo(scaledPoints.last.dx, size.height - paddingBottom);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw points
    final Paint pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final Paint pointStrokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (final point in scaledPoints) {
      canvas.drawCircle(point, 3, pointPaint);
      canvas.drawCircle(point, 3, pointStrokePaint);
    }
  }

  @override
  bool shouldRepaint(StockChartPainter oldDelegate) {
    return oldDelegate.points != points ||
           oldDelegate.lineColor != lineColor ||
           oldDelegate.fillColor != fillColor;
  }
}

class SectorChartPainter extends CustomPainter {
  final List<Sector> sectors;

  SectorChartPainter({required this.sectors});

  @override
  void paint(Canvas canvas, Size size) {
    // Define chart area
    const double paddingLeft = 80;
    const double paddingRight = 30;
    const double paddingTop = 40;
    const double paddingBottom = 50;
    
    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;
    
    // Draw title
    const TextStyle titleStyle = TextStyle(
      color: Color(0xFF1E3A8A),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    
    final titleSpan = TextSpan(text: 'Sector Performance', style: titleStyle);
    final titlePainter = TextPainter(
      text: titleSpan,
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset(size.width / 2 - titlePainter.width / 2, 10),
    );
    
    // Draw horizontal lines and labels
    final Paint gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    
    const TextStyle labelStyle = TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 10,
    );
    
    for (int i = 0; i <= 4; i++) {
      final y = size.height - paddingBottom - (i * chartHeight / 4);
      
      // Grid line
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
      
      // Y-axis label
      final value = i * 5;
      final textSpan = TextSpan(text: '$value%', style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }
    
    // Draw bottom line
    final Paint axesPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(paddingLeft, size.height - paddingBottom),
      Offset(size.width - paddingRight, size.height - paddingBottom),
      axesPaint,
    );
    
    // Calculate bar positions
    final barWidth = 60.0;
    final gap = (chartWidth - barWidth * sectors.length) / (sectors.length + 1);
    
    // Find max performance for scaling
    final maxPerformance = sectors.map((s) => s.performance).reduce((a, b) => a > b ? a : b);
    
    // Draw bars
    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];
      
      // Calculate positions
      final startX = paddingLeft + gap + i * (barWidth + gap);
      final barHeight = (sector.performance / 20) * chartHeight; // Scale to 20% max
      final startY = size.height - paddingBottom - barHeight;
      
      // Draw bar
      final Paint barPaint = Paint()
        ..color = sector.color
        ..style = PaintingStyle.fill;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, startY, barWidth, barHeight),
        const Radius.circular(4),
      );
      
      canvas.drawRRect(rect, barPaint);
      
      // Draw value on top of bar
      final valueSpan = TextSpan(
        text: '+${sector.performance}%',
        style: const TextStyle(
          color: Color(0xFF1E3A8A),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      final valuePainter = TextPainter(
        text: valueSpan,
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(
        canvas,
        Offset(startX + barWidth / 2 - valuePainter.width / 2, startY - valuePainter.height - 5),
      );
      
      // Draw sector name below bar
      final nameSpan = TextSpan(
        text: sector.name,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 12,
        ),
      );
      final namePainter = TextPainter(
        text: nameSpan,
        textDirection: TextDirection.ltr,
      );
      namePainter.layout();
      namePainter.paint(
        canvas,
        Offset(startX + barWidth / 2 - namePainter.width / 2, size.height - paddingBottom + 15),
      );
    }
  }

  @override
  bool shouldRepaint(SectorChartPainter oldDelegate) {
    return oldDelegate.sectors != sectors;
  }
}