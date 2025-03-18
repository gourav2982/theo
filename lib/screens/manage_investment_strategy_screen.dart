// screens/manage_trading_strategy_screen.dart
import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/data/dummy_data.dart';
import 'package:theo/data/strategy_data.dart';
import 'package:theo/models/strategy_component_models.dart';
import 'package:theo/widgets/chat_service.dart';

class ManageTradingStrategyScreen extends StatefulWidget {
  final bool isEditing;
  final TradingStrategy? existingStrategy;
  
  const ManageTradingStrategyScreen({
    Key? key,
    this.isEditing = false,
    this.existingStrategy,
  }) : super(key: key);

  @override
  _ManageTradingStrategyScreenState createState() => _ManageTradingStrategyScreenState();
}

class _ManageTradingStrategyScreenState extends State<ManageTradingStrategyScreen> {
  late TradingStrategy _strategy;
  String? _expandedSection;
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing strategy or create a new one
    if (widget.isEditing && widget.existingStrategy != null) {
      _strategy = widget.existingStrategy!;
    } else {
      _strategy = StrategyData.getMockTradingStrategy();
    }
    
    // Set initial state
    _nameController.text = _strategy.name;
    _descriptionController.text = _strategy.description;
    _expandedSection = 'indicators'; // Initially expand indicators section
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _toggleSection(String section) {
    setState(() {
      if (_expandedSection == section) {
        _expandedSection = null;
      } else {
        _expandedSection = section;
      }
    });
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
                'Manage Strategy',
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
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
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
          _buildBasicInfoSection(),
          const SizedBox(height: 16),
          _buildIndicatorsSection(),
          const SizedBox(height: 16),
          _buildEntryConditionsSection(),
          const SizedBox(height: 16),
          _buildExitConditionsSection(),
          const SizedBox(height: 16),
          _buildRiskManagementSection(),
          const SizedBox(height: 16),
          _buildAdditionalSettingsSection(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

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
            
            // Strategy Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Strategy Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _strategy.name = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              maxLines: 2,
              onChanged: (value) {
                setState(() {
                  _strategy.description = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Strategy Type
            DropdownButtonFormField<String>(
              value: _strategy.type,
              decoration: const InputDecoration(
                labelText: 'Strategy Type',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: StrategyData.getStrategyTypes().map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(StrategyData.getStrategyTypeDisplayName(type)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _strategy.type = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => _toggleSection('indicators'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Technical Indicators',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _expandedSection == 'indicators' 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_expandedSection == 'indicators')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // List of indicators
                  ..._strategy.indicators.map((indicator) => _buildIndicatorItem(indicator)).toList(),
                  
                  // Add indicator button
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Indicator'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      minimumSize: const Size(double.infinity, 44),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Add indicator logic
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicatorItem(TechnicalIndicator indicator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator header with name and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                indicator.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: Colors.grey[400],
                onPressed: () {
                  // Remove indicator
                  setState(() {
                    _strategy.indicators.remove(indicator);
                  });
                },
              ),
            ],
          ),
          
          // Indicator parameters
          ...indicator.parameters.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      _capitalizeFirstLetter(entry.key),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: entry.value.toString()),
                      style: const TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        // Update parameter value
                        if (value.isNotEmpty) {
                          indicator.parameters[entry.key] = value;
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, size: 14),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    color: Colors.grey[400],
                    onPressed: () {
                      // Show parameter settings
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEntryConditionsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => _toggleSection('entry'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Entry Conditions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _expandedSection == 'entry' 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_expandedSection == 'entry')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // List of entry conditions
                  ..._strategy.entryConditions.asMap().entries.map((entry) => 
                    _buildConditionItem(entry.value, entry.key, _strategy.entryConditions.length, true)
                  ).toList(),
                  
                  // Add entry condition button
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Entry Condition'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green[700],
                      backgroundColor: Colors.green[50],
                      minimumSize: const Size(double.infinity, 44),
                      side: BorderSide(color: Colors.green[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Add entry condition logic
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExitConditionsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => _toggleSection('exit'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Exit Conditions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _expandedSection == 'exit' 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_expandedSection == 'exit')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // List of exit conditions
                  ..._strategy.exitConditions.asMap().entries.map((entry) => 
                    _buildConditionItem(entry.value, entry.key, _strategy.exitConditions.length, false)
                  ).toList(),
                  
                  // Add exit condition button
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Exit Condition'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red[700],
                      backgroundColor: Colors.red[50],
                      minimumSize: const Size(double.infinity, 44),
                      side: BorderSide(color: Colors.red[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Add exit condition logic
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConditionItem(StrategyCondition condition, int index, int totalItems, bool isEntry) {
    final bgColor = isEntry ? Colors.green[50]! : Colors.red[50]!;
    final logicBgColor = isEntry ? Colors.green[200]! : Colors.red[200]!;
    final logicTextColor = isEntry ? Colors.green[800]! : Colors.red[800]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Condition fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Condition fields
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Indicator dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: condition.indicator,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              isDense: true,
                            ),
                            items: [
                              ...['RSI', 'MACD', 'Moving Average', 'Price', 'Volume', 'Stop Loss', 'Take Profit', 'Trailing Stop'].map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: const TextStyle(fontSize: 13)),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  if (isEntry) {
                                    _strategy.entryConditions[index] = StrategyCondition(
                                      id: condition.id,
                                      indicator: newValue,
                                      condition: condition.condition,
                                      value: condition.value,
                                      logic: condition.logic,
                                    );
                                  } else {
                                    _strategy.exitConditions[index] = StrategyCondition(
                                      id: condition.id,
                                      indicator: newValue,
                                      condition: condition.condition,
                                      value: condition.value,
                                      logic: condition.logic,
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Condition dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: condition.condition,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              isDense: true,
                            ),
                            items: StrategyData.getConditionOptions().map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 13)),
                              ),
                            ).toList(),
                            onChanged: (String? newValue) {
                              // Update condition
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Value field
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: condition.value.toString()),
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              // Update value
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // AND/OR logic for all conditions except the last one
                    if (index < totalItems - 1)
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: logicBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          value: condition.logic,
                          underline: Container(),
                          isDense: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: logicTextColor,
                          ),
                          items: ['AND', 'OR'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                if (isEntry) {
                                  _strategy.entryConditions[index] = StrategyCondition(
                                    id: condition.id,
                                    indicator: condition.indicator,
                                    condition: condition.condition,
                                    value: condition.value,
                                    logic: newValue,
                                  );
                                } else {
                                  _strategy.exitConditions[index] = StrategyCondition(
                                    id: condition.id,
                                    indicator: condition.indicator,
                                    condition: condition.condition,
                                    value: condition.value,
                                    logic: newValue,
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
              
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                color: Colors.grey[400],
                onPressed: () {
                  // Remove condition
                  setState(() {
                    if (isEntry) {
                      _strategy.entryConditions.removeAt(index);
                    } else {
                      _strategy.exitConditions.removeAt(index);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskManagementSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => _toggleSection('risk'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Risk Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _expandedSection == 'risk' 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_expandedSection == 'risk')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Risk settings fields in 2 columns
                  _buildRiskSettingsGrid(),
                  
                  const SizedBox(height: 16),
                  
                  // Position sizing dropdown
                  DropdownButtonFormField<String>(
                    value: _strategy.riskSettings.positionSizing,
                    decoration: const InputDecoration(
                      labelText: 'Position Sizing',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: StrategyData.getPositionSizingOptions().map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(StrategyData.getPositionSizingDisplayName(value)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _strategy.riskSettings.positionSizing = newValue;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Info box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Risk management settings apply to all trades executed with this strategy. They serve as default values that can be overridden during manual trading.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[800],
                            ),
                          ),
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
  
  Widget _buildRiskSettingsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          // Two columns on wider screens
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildRiskSettingField(
                      'Stop Loss (%)',
                      _strategy.riskSettings.stopLoss.toString(),
                      (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _strategy.riskSettings.stopLoss = double.tryParse(value) ?? _strategy.riskSettings.stopLoss;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildRiskSettingField(
                      'Take Profit (%)',
                      _strategy.riskSettings.takeProfit.toString(),
                      (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _strategy.riskSettings.takeProfit = double.tryParse(value) ?? _strategy.riskSettings.takeProfit;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildRiskSettingField(
                      'Trailing Stop (%)',
                      _strategy.riskSettings.trailingStop.toString(),
                      (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _strategy.riskSettings.trailingStop = double.tryParse(value) ?? _strategy.riskSettings.trailingStop;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildRiskSettingField(
                      'Max Open Positions',
                      _strategy.riskSettings.maxOpenPositions.toString(),
                      (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _strategy.riskSettings.maxOpenPositions = int.tryParse(value) ?? _strategy.riskSettings.maxOpenPositions;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Single column on narrower screens
          return Column(
            children: [
              _buildRiskSettingField(
                'Stop Loss (%)',
                _strategy.riskSettings.stopLoss.toString(),
                (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _strategy.riskSettings.stopLoss = double.tryParse(value) ?? _strategy.riskSettings.stopLoss;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildRiskSettingField(
                'Take Profit (%)',
                _strategy.riskSettings.takeProfit.toString(),
                (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _strategy.riskSettings.takeProfit = double.tryParse(value) ?? _strategy.riskSettings.takeProfit;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildRiskSettingField(
                'Trailing Stop (%)',
                _strategy.riskSettings.trailingStop.toString(),
                (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _strategy.riskSettings.trailingStop = double.tryParse(value) ?? _strategy.riskSettings.trailingStop;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildRiskSettingField(
                'Max Open Positions',
                _strategy.riskSettings.maxOpenPositions.toString(),
                (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _strategy.riskSettings.maxOpenPositions = int.tryParse(value) ?? _strategy.riskSettings.maxOpenPositions;
                    });
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }
  
  Widget _buildRiskSettingField(String label, String value, Function(String) onChanged) {
    return TextField(
      controller: TextEditingController(text: value),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildAdditionalSettingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => _toggleSection('additional'),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Additional Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    _expandedSection == 'additional' 
                        ? Icons.keyboard_arrow_up 
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (_expandedSection == 'additional')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _strategy.riskSettings.positionSizing,
                    decoration: const InputDecoration(
                      labelText: 'Position Sizing',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    items: StrategyData.getPositionSizingOptions().map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(StrategyData.getPositionSizingDisplayName(value)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _strategy.riskSettings.positionSizing = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Horizontal buttons on wider screens
          return Row(
            children: [
              Expanded(child: _buildSaveButton()),
              const SizedBox(width: 12),
              Expanded(child: _buildTestButton()),
              const SizedBox(width: 12),
              Expanded(child: _buildCancelButton()),
            ],
          );
        } else {
          // Vertical buttons on narrower screens
          return Column(
            children: [
              _buildSaveButton(),
              const SizedBox(height: 12),
              _buildTestButton(),
              const SizedBox(height: 12),
              _buildCancelButton(),
            ],
          );
        }
      },
    );
  }
  
  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text('Save Strategy'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        // Save strategy logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Strategy saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
  
  Widget _buildTestButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: const Text('Test Strategy'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        // Test strategy logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Running strategy test...'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
  
  Widget _buildCancelButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.close),
      label: const Text('Cancel'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[700],
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
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
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing Strategy'),
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
  
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}