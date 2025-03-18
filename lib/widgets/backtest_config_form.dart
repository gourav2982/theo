import 'package:flutter/material.dart';
import 'package:theo/models/backtest_config_models.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/widgets/improved_data_field.dart';

class BacktestConfigForm extends StatelessWidget {
  final String selectedStrategy;
  final String selectedBasket;
  final String startDate;
  final String endDate;
  final int investment;
  final List<Strategy> strategies;
  final List<Basket> baskets;
  final Function(String) onStrategyChanged;
  final Function(String) onBasketChanged;
  final Function(String) onStartDateChanged;
  final Function(String) onEndDateChanged;
  final Function(int) onInvestmentChanged;
  final VoidCallback onRunBacktest;

  const BacktestConfigForm({
    Key? key,
    required this.selectedStrategy,
    required this.selectedBasket,
    required this.startDate,
    required this.endDate,
    required this.investment,
    required this.strategies,
    required this.baskets,
    required this.onStrategyChanged,
    required this.onBasketChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onInvestmentChanged,
    required this.onRunBacktest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure Backtest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827), // gray-900
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 16),
            
            // Strategy Dropdown
            _buildDropdownField(
              label: 'Select Strategy',
              value: selectedStrategy,
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('Select a strategy'),
                ),
                ...strategies.map((strategy) => DropdownMenuItem(
                  value: strategy.id,
                  child: Text(strategy.name),
                )).toList(),
              ],
              onChanged: (value) {
                if (value != null) {
                  onStrategyChanged(value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Basket Dropdown
            _buildDropdownField(
              label: 'Select Basket',
              value: selectedBasket,
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('Select a basket'),
                ),
                ...baskets.map((basket) => DropdownMenuItem(
                  value: basket.id,
                  child: Text(basket.name),
                )).toList(),
              ],
              onChanged: (value) {
                if (value != null) {
                  onBasketChanged(value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Date Range with Improved Date Fields
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 500) {
                  // Use row for wider screens
                  return Row(
                    children: [
                      Expanded(
                        child: ImprovedDateField(
                          label: 'Start Date',
                          selectedDate: startDate.isNotEmpty 
                              ? DateTime.parse(startDate) 
                              : null,
                          onDateChanged: (date) {
                            if (date != null) {
                              onStartDateChanged('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
                            }
                          },
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ImprovedDateField(
                          label: 'End Date',
                          selectedDate: endDate.isNotEmpty 
                              ? DateTime.parse(endDate) 
                              : null,
                          onDateChanged: (date) {
                            if (date != null) {
                              onEndDateChanged('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
                            }
                          },
                          firstDate: startDate.isNotEmpty 
                              ? DateTime.parse(startDate) 
                              : DateTime(2020),
                          lastDate: DateTime.now(),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Use column for narrower screens
                  return Column(
                    children: [
                      ImprovedDateField(
                        label: 'Start Date',
                        selectedDate: startDate.isNotEmpty 
                            ? DateTime.parse(startDate) 
                            : null,
                        onDateChanged: (date) {
                          if (date != null) {
                            onStartDateChanged('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
                          }
                        },
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      ),
                      const SizedBox(height: 16),
                      ImprovedDateField(
                        label: 'End Date',
                        selectedDate: endDate.isNotEmpty 
                            ? DateTime.parse(endDate) 
                            : null,
                        onDateChanged: (date) {
                          if (date != null) {
                            onEndDateChanged('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
                          }
                        },
                        firstDate: startDate.isNotEmpty 
                            ? DateTime.parse(startDate) 
                            : DateTime(2020),
                        lastDate: DateTime.now(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Investment Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Initial Investment (\$)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563), // gray-600
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: investment.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      size: 20,
                      color: Color(0xFF9CA3AF), // gray-400
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB), // gray-300
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB), // gray-300
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    final intValue = int.tryParse(value);
                    if (intValue != null) {
                      onInvestmentChanged(intValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Run Backtest Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRunBacktest,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text(
                  'Run Backtest',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B5563), // gray-600
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFD1D5DB), // gray-300
            ),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Select...'),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280), // gray-500
              ),
              items: items,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937), // gray-800
                fontFamily: 'Roboto',
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              borderRadius: BorderRadius.circular(6),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}