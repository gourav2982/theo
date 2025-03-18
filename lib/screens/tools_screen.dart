// screens/tools_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/tools_data.dart';
import 'package:theo/screens/arena_screen.dart';
import 'package:theo/screens/backtest_screen.dart';
import 'package:theo/screens/baskets_hub_screen.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/indicator_hub_screen.dart';
import 'package:theo/screens/investment_strategy_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/manage_alerts_screen.dart';
import 'package:theo/screens/papertrading_hub_screen.dart';
import 'package:theo/screens/research_screen.dart';
import 'package:theo/widgets/chat_service.dart';
import 'package:theo/widgets/tool_card.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  int _selectedIndex = 2; // Tools tab is selected by default

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
          // Title
          const Text(
            'Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              fontFamily: 'Roboto',
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
    final toolOptions = ToolsData.getToolOptions();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827), // gray-900
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Access your trading tools and management options',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280), // gray-600
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 24),

          // Tools List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: toolOptions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ToolCard(
                tool: toolOptions[index],
                onTap: () {
                  // Handle tool selection
                  if (toolOptions[index].id == 'backtest') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BacktestScreen()),
                    );
                  } else if (toolOptions[index].id == 'papertrading') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaperTradingScreen()),
                    );
                  } else if (toolOptions[index].id == 'strategies') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const InvestmentStrategiesScreen()),
                    );
                  } else if (toolOptions[index].id == 'indicators') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IndicatorsHubScreen()),
                    );
                  } else if (toolOptions[index].id == 'baskets') {
                    // Add this condition
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BasketsHubScreen()),
                    );
                  } else if (toolOptions[index].id == 'alerts') {
                    // Add this condition
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageAlertsScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening ${toolOptions[index].label}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
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