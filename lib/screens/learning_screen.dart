import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/learning_data.dart';
import 'package:theo/screens/arena_screen.dart';
import 'package:theo/screens/course_learning_screen.dart';
import 'package:theo/screens/home_screen.dart';
import 'package:theo/screens/research_screen.dart';
import 'package:theo/screens/tools_screen.dart';
import 'package:theo/widgets/article_list.dart';
import 'package:theo/widgets/ask_theo_card.dart';
import 'package:theo/widgets/category_grid.dart';
import 'package:theo/widgets/chat_service.dart';
import 'package:theo/widgets/course_grid.dart';
import 'package:theo/widgets/learning_progress.dart';
import 'package:theo/widgets/popular_course_grid.dart';
import 'package:theo/widgets/section_header.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int _selectedIndex = 1; // Learning tab is selected by default

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
            'Learning Center',
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
          // Learning Progress Section
          const LearningProgress(
            completed: 32,
            total: 124,
            percentage: 26,
          ),
          const SizedBox(height: 24),
          
          // Ask Theo Section
          const AskTheoCard(),
          const SizedBox(height: 24),
          
          // Continue Learning Section
          const SectionHeader(title: 'Continue Learning'),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CourseLearningScreen()),
              );
            },
            child: CourseGrid(courses: LearningData.featuredCourses),
          ),
          const SizedBox(height: 24),
          
          // Popular Courses Section
          const SectionHeader(title: 'Popular Courses'),
          PopularCourseGrid(courses: LearningData.popularCourses),
          const SizedBox(height: 24),
          
          // Learning Categories Section
          const SectionHeader(title: 'Learning Categories'),
          CategoryGrid(categories: LearningData.learningCategories),
          const SizedBox(height: 24),
          
          // Recent Articles Section
          const SectionHeader(title: 'Recent Articles'),
          ArticleList(articles: LearningData.recentArticles),
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