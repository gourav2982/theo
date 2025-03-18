import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';

enum SortOrder {
  newest,
  oldest,
  best,
  worst,
}

class BacktestSearchBar extends StatefulWidget {
  final String searchValue;
  final Function(String) onSearchChanged;
  final SortOrder sortOrder;
  final Function(SortOrder) onSortChanged;
  final VoidCallback onFilterPressed;

  const BacktestSearchBar({
    Key? key,
    required this.searchValue,
    required this.onSearchChanged,
    required this.sortOrder,
    required this.onSortChanged,
    required this.onFilterPressed,
  }) : super(key: key);

  @override
  State<BacktestSearchBar> createState() => _BacktestSearchBarState();
}

class _BacktestSearchBarState extends State<BacktestSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchValue);
    
    // Add listener to update parent when text changes
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }
  
  @override
  void didUpdateWidget(BacktestSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if searchValue changes externally
    if (widget.searchValue != oldWidget.searchValue && 
        widget.searchValue != _searchController.text) {
      _searchController.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // Use a row for wider screens, column for narrower screens
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  Expanded(
                    child: _buildSearchField(),
                  ),
                  const SizedBox(width: 12),
                  _buildFilterButton(),
                  const SizedBox(width: 12),
                  _buildSortDropdown(),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterButton(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSortDropdown(),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search backtests...',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF), // gray-400
          fontFamily: 'Roboto',
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF9CA3AF), // gray-400
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        color: Color(0xFF1F2937), // gray-800
      ),
      onSubmitted: widget.onSearchChanged,
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      onPressed: widget.onFilterPressed,
      icon: const Icon(
        Icons.filter_list,
        size: 18,
      ),
      label: const Text('Filter'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4B5563), // gray-600
        side: const BorderSide(
          color: Color(0xFFD1D5DB), // gray-300
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD1D5DB), // gray-300
        ),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOrder>(
          value: widget.sortOrder,
          onChanged: (SortOrder? newValue) {
            if (newValue != null) {
              widget.onSortChanged(newValue);
            }
          },
          items: [
            DropdownMenuItem(
              value: SortOrder.newest,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Newest First',
                  style: _dropdownTextStyle,
                ),
              ),
            ),
            DropdownMenuItem(
              value: SortOrder.oldest,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Oldest First',
                  style: _dropdownTextStyle,
                ),
              ),
            ),
            DropdownMenuItem(
              value: SortOrder.best,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Best Performance',
                  style: _dropdownTextStyle,
                ),
              ),
            ),
            DropdownMenuItem(
              value: SortOrder.worst,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Worst Performance',
                  style: _dropdownTextStyle,
                ),
              ),
            ),
          ],
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF6B7280), // gray-500
          ),
          borderRadius: BorderRadius.circular(6),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  // Common text style for dropdown items
  final TextStyle _dropdownTextStyle = const TextStyle(
    fontSize: 14,
    fontFamily: 'Roboto',
    color: Color(0xFF4B5563), // gray-600
  );
}