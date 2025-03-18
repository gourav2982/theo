import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:theo/config/app_theme.dart';

class ImprovedDateField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ImprovedDateField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final displayText = selectedDate != null ? dateFormat.format(selectedDate!) : 'Select a date';

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
        InkWell(
          onTap: () => _showDatePicker(context),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFD1D5DB), // gray-300
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF6B7280), // gray-500
                ),
                const SizedBox(width: 10),
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: selectedDate != null 
                        ? const Color(0xFF1F2937) // gray-800
                        : const Color(0xFF9CA3AF), // gray-400
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF6B7280), // gray-500
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate ?? now;
    final DateTime firstAllowedDate = firstDate ?? DateTime(now.year - 5);
    final DateTime lastAllowedDate = lastDate ?? DateTime(now.year + 5);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: lastAllowedDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateChanged(pickedDate);
    }
  }
}