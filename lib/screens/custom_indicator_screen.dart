import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/widgets/chat_service.dart';

class CreateCustomIndicatorScreen extends StatefulWidget {
  const CreateCustomIndicatorScreen({Key? key}) : super(key: key);

  @override
  _CreateCustomIndicatorScreenState createState() => _CreateCustomIndicatorScreenState();
}

class _CreateCustomIndicatorScreenState extends State<CreateCustomIndicatorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = 'Momentum';
  String selectedCategory = 'Technical';
  
  // Slider values
  double periodValue = 14.0;
  double overboughtValue = 70.0;
  double oversoldValue = 30.0;
  int selectedColorIndex = 0;
  String selectedLineStyle = 'Solid';

  // Available indicator types
  final List<String> indicatorTypes = ['Momentum', 'Trend', 'Volatility', 'Volume', 'Price', 'Other'];
  
  // Available indicator categories
  final List<String> indicatorCategories = ['Technical', 'Fundamental', 'Custom'];

  // Color options
  final List<Color> colorOptions = [
    const Color(0xFF2563EB), // Blue
    const Color(0xFF10B981), // Green
    const Color(0xFFEF4444), // Red
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF111827), // Dark grey
  ];

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
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
      ),
    );
  }

  // App Bar
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
          // Back button and title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Create Custom Indicator',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          
          // User Icon
          IconButton(
            icon: const Icon(Icons.person, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Main Content with ScrollView
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInfoSection(),
          const SizedBox(height: 16),
          _buildIndicatorSettingsSection(),
          const SizedBox(height: 16),
          _buildFormulaSection(),
          const SizedBox(height: 16),
          _buildVisualizationSection(),
          const SizedBox(height: 16),
          _buildSaveButtonSection(),
          const SizedBox(height: 100), // Extra space for floating buttons
        ],
      ),
    );
  }

  // Basic Information Section
  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Indicator Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'e.g., My Custom RSI',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Describe what your indicator does and how to use it',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: selectedType,
                    items: indicatorTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedType = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: selectedCategory,
                    items: indicatorCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
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

  // Indicator Settings Section - With functional sliders
  Widget _buildIndicatorSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indicator Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Period setting
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('Period'),
                ),
                Expanded(
                  flex: 7,
                  child: Slider(
                    value: periodValue,
                    min: 1.0,
                    max: 200.0,
                    divisions: 199,
                    label: periodValue.round().toString(),
                    activeColor: AppTheme.primaryColor,
                    onChanged: (double value) {
                      setState(() {
                        periodValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    periodValue.round().toString(),
                    textAlign: TextAlign.right
                  ),
                ),
              ],
            ),
            const Divider(),
            // Overbought Level setting
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('Overbought Level'),
                ),
                Expanded(
                  flex: 7,
                  child: Slider(
                    value: overboughtValue,
                    min: 50.0,
                    max: 100.0,
                    divisions: 50,
                    label: overboughtValue.round().toString(),
                    activeColor: AppTheme.primaryColor,
                    onChanged: (double value) {
                      setState(() {
                        overboughtValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    overboughtValue.round().toString(),
                    textAlign: TextAlign.right
                  ),
                ),
              ],
            ),
            const Divider(),
            // Oversold Level setting
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('Oversold Level'),
                ),
                Expanded(
                  flex: 7,
                  child: Slider(
                    value: oversoldValue,
                    min: 0.0,
                    max: 50.0,
                    divisions: 50,
                    label: oversoldValue.round().toString(),
                    activeColor: AppTheme.primaryColor,
                    onChanged: (double value) {
                      setState(() {
                        oversoldValue = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    oversoldValue.round().toString(),
                    textAlign: TextAlign.right
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Parameter'),
              onPressed: () {
                // Add parameter functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adding parameter'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Formula Section
  Widget _buildFormulaSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Formula',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // gray-100
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD1D5DB)), // gray-300
              ),
              child: Text(
                'RSI = 100 - (100 / (1 + RS))\n'
                'RS = Average Gain / Average Loss\n'
                'Average Gain = Sum of Gains over past ${periodValue.round()} periods / ${periodValue.round()}\n'
                'Average Loss = Sum of Losses over past ${periodValue.round()} periods / ${periodValue.round()}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Formula'),
                    onPressed: () {
                      // Handle edit formula
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Editing formula'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Formula Help'),
                    onPressed: () {
                      // Show formula help
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Formula help'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Visualization Section - With functional color selection
  Widget _buildVisualizationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visualization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // gray-100
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD1D5DB)), // gray-300
              ),
              child: Center(
                child: Icon(
                  Icons.show_chart,
                  size: 48,
                  color: colorOptions[selectedColorIndex],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Line Color'),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            colorOptions.length,
                            (index) => _buildColorOption(
                              colorOptions[index], 
                              isSelected: selectedColorIndex == index,
                              index: index,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Line Style'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: selectedLineStyle,
                        isExpanded: true,
                        items: ['Solid', 'Dashed', 'Dotted'].map((String style) {
                          return DropdownMenuItem<String>(
                            value: style,
                            child: Text(style),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedLineStyle = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Color option for visualization
  Widget _buildColorOption(Color color, {required bool isSelected, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  // Save Button Section
  Widget _buildSaveButtonSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Validate form
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an indicator name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                
                // Handle save and create
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Indicator created successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Navigate back after successful creation
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Save & Create Indicator',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Buttons
  Widget _buildFloatingButtons() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: Column(
        children: [
          // Share Button
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing Indicator'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
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

  // Bottom Navigation
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 2, // Tools tab is selected
      onTap: (index) {
        // This would be handled by the main navigation controller
        // For now, we'll just go back to the tools screen
        if (index != 2) {
          Navigator.of(context).pop();
        }
      },
      // Using DummyData.tabs for consistent icons and labels
      items: DummyData.tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}