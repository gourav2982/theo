import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/course_data.dart';
import 'package:theo/models/course_models.dart';
import 'package:theo/widgets/chart_example_widget.dart';
import 'package:theo/widgets/course_menu.dart';
import 'package:theo/widgets/html_content_widget.dart';
import 'package:theo/widgets/notes_panel.dart';
import 'package:theo/widgets/video_player_widget.dart';

class CourseLearningScreen extends StatefulWidget {
  const CourseLearningScreen({Key? key}) : super(key: key);

  @override
  State<CourseLearningScreen> createState() => _CourseLearningScreenState();
}

class _CourseLearningScreenState extends State<CourseLearningScreen> {
  int _currentLessonIndex = 0;
  bool _showMenu = false;
  bool _showNotes = false;
  String _notesText = '';
  
  late CourseDetail _course;
  late LessonContent _lessonContent;
  
  @override
  void initState() {
    super.initState();
    _course = CourseData.getCourse();
    _lessonContent = CourseData.getLessonContent();
  }
  
  void _handlePrevious() {
    if (_currentLessonIndex > 0) {
      setState(() {
        _currentLessonIndex--;
      });
    }
  }
  
  void _handleNext() {
    if (_currentLessonIndex < _course.lessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
      });
    }
  }
  
  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }
  
  void _toggleNotes() {
    setState(() {
      _showNotes = !_showNotes;
    });
  }
  
  void _selectLesson(int index) {
    setState(() {
      _currentLessonIndex = index;
      _showMenu = false;
    });
  }
  
  void _updateNotes(String text) {
    setState(() {
      _notesText = text;
    });
  }
  
  void _saveNotes() {
    // In a real app, you would save the notes to storage or backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes saved')),
    );
    setState(() {
      _showNotes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLesson = _course.lessons[_currentLessonIndex];
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),
                
                // Progress Bar
                _buildProgressBar(),
                
                // Main Content
                Expanded(
                  child: _buildMainContent(currentLesson),
                ),
              ],
            ),
            
            // Floating Action Buttons
            _buildFloatingActionButtons(),
            
            // Course Menu Overlay
            if (_showMenu)
              Positioned.fill(
                child: CourseMenu(
                  lessons: _course.lessons,
                  currentLessonIndex: _currentLessonIndex,
                  onLessonSelected: _selectLesson,
                  onClose: _toggleMenu,
                ),
              ),
            
            // Notes Panel Overlay
            if (_showNotes)
              Positioned.fill(
                child: NotesPanel(
                  notesText: _notesText,
                  onNotesChanged: _updateNotes,
                  onSave: _saveNotes,
                  onClose: _toggleNotes,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          
          const SizedBox(width: 8),
          
          // Course and Module Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _course.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    fontFamily: 'Roboto',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _course.currentModule,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'Roboto',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Menu Button
          IconButton(
            icon: const Icon(Icons.menu, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _toggleMenu,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return Container(
      height: 4,
      child: Row(
        children: [
          Expanded(
            flex: _course.progress,
            child: Container(color: AppTheme.primaryColor),
          ),
          Expanded(
            flex: 100 - _course.progress,
            child: Container(color: Colors.grey.shade200),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent(Lesson currentLesson) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player (if video lesson)
          if (currentLesson.type == LessonType.video)
            VideoPlayerWidget(duration: currentLesson.duration),
          
          // Lesson Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson Title
                Text(
                  _lessonContent.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'Roboto',
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Chart Example: Bullish Engulfing
                ChartExampleWidget(
                  title: 'Example: Bullish Engulfing Pattern',
                  description: 'A bullish engulfing pattern occurs when a large green candle completely engulfs the previous red candle, signaling a potential trend reversal from bearish to bullish. Note how the price action confirms the reversal in subsequent candles.',
                  chart: const BullishEngulfingChart(),
                ),
                
                // Chart Example: Hammer
                ChartExampleWidget(
                  title: 'Example: Hammer Pattern',
                  description: 'A hammer pattern has a small body at the top and a long lower shadow. It appears during a downtrend and suggests that the market tried to push prices lower but buyers stepped in, potentially signaling a bullish reversal.',
                  chart: const HammerChart(),
                ),
                
                // Main Content
                HtmlContentWidget(htmlContent: _lessonContent.text),
                
                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
                      TextButton.icon(
                        onPressed: _currentLessonIndex > 0 ? _handlePrevious : null,
                        icon: const Icon(Icons.chevron_left, size: 16),
                        label: const Text('Previous'),
                        style: TextButton.styleFrom(
                          foregroundColor: _currentLessonIndex > 0 
                              ? AppTheme.primaryColor 
                              : Colors.grey.shade400,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      
                      // Next Button
                      TextButton.icon(
                        onPressed: _handleNext,
                        icon: const Text('Next'),
                        label: const Icon(Icons.chevron_right, size: 16),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Extra padding at bottom to account for FAB
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Notes Button
          FloatingActionButton(
            heroTag: 'notes',
            onPressed: _toggleNotes,
            backgroundColor: AppTheme.primaryColor,
            mini: true,
            child: const Icon(Icons.description, size: 18),
          ),
          const SizedBox(height: 8),
          
          // Share Button
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () {
              // Handle share
            },
            backgroundColor: AppTheme.primaryColor,
            mini: true,
            child: const Icon(Icons.share, size: 18),
          ),
          const SizedBox(height: 8),
          
          // Message Button
          FloatingActionButton(
            heroTag: 'message',
            onPressed: () {
              // Handle message/ask
            },
            backgroundColor: AppTheme.primaryColor,
            mini: true,
            child: const Icon(Icons.message, size: 18),
          ),
        ],
      ),
    );
  }
}