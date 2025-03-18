import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/screens/arena_screen.dart';
import 'package:theo/screens/learning_screen.dart';
import 'package:theo/screens/research_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/alerts_grid.dart';
import 'package:theo/widgets/arena_performance_list.dart';
import 'package:theo/widgets/chat_service.dart';
import 'package:theo/widgets/competitions_grid.dart';
import 'package:theo/widgets/paper_trades_card.dart';
import 'package:theo/widgets/quant_agents_list.dart';
import 'package:theo/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Actionable Alerts Section
          const SectionHeader(title: 'Actionable Alerts'),
          AlertsGrid(alerts: DummyData.alerts),
          const SizedBox(height: 24),
          
          // Arena Performance Section
          const SectionHeader(title: 'Your Arena Performance'),
          ArenaPerformanceList(performances: DummyData.arenaPerformance),
          const SizedBox(height: 24),
          
          // Competitions Section
          const SectionHeader(title: 'Competitions Starting Soon'),
          CompetitionsGrid(competitions: DummyData.upcomingCompetitions),
          const SizedBox(height: 24),
          
          // Quant Agents Section
          const SectionHeader(title: 'Quant Agents'),
          QuantAgentsList(agents: DummyData.quantAgents),
          const SizedBox(height: 24),
          
          // Paper Trades Section
          const SectionHeader(title: 'Paper Trades'),
          const PaperTradesCard(),
          const SizedBox(height: 40),
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