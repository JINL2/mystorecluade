import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../widgets/add_attribute_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// A reusable page for selecting or adding attribute values (Category, Brand, etc.)
///
/// Shows a search bar at the top with a + button to add new values.
/// Displays existing values in a list that can be filtered by search.
/// Shows an empty state when no values exist.
class AttributeValueSelectorPage<T> extends StatefulWidget {
  const AttributeValueSelectorPage({
    super.key,
    required this.title,
    required this.searchHint,
    required this.values,
    this.selectedValue,
    required this.onSelect,
    this.onAdd,
    this.onQuickAdd,
    this.getName,
    this.getId,
  });

  /// The title shown in empty state (e.g., "brand", "category")
  final String title;

  /// Hint text for the search field (e.g., "Search or enter a brand")
  final String searchHint;

  /// List of available values to select from
  final List<T> values;

  /// Currently selected value (optional)
  final T? selectedValue;

  /// Callback when a value is selected
  final void Function(T value) onSelect;

  /// Callback when the + button is tapped to add a new value (shows dialog)
  /// Returns the newly created value, or null if cancelled
  final Future<T?> Function()? onAdd;

  /// Callback for quick add - creates value directly with the given name
  /// Returns the newly created value, or null if failed
  final Future<T?> Function(String name)? onQuickAdd;

  /// Function to get the display name from a value
  /// If not provided, assumes T has a 'name' property or uses toString()
  final String Function(T value)? getName;

  /// Function to get the ID from a value for comparison
  /// If not provided, assumes T has an 'id' property or uses toString()
  final String Function(T value)? getId;

  @override
  State<AttributeValueSelectorPage<T>> createState() =>
      _AttributeValueSelectorPageState<T>();
}

class _AttributeValueSelectorPageState<T>
    extends State<AttributeValueSelectorPage<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;
  String _searchQuery = '';
  List<T> _filteredValues = [];

  @override
  void initState() {
    super.initState();
    _filteredValues = widget.values;
    // Auto focus the search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  String _getValueName(T value) {
    if (widget.getName != null) {
      return widget.getName!(value);
    }
    // Try to access 'name' property via dynamic
    try {
      return (value as dynamic).name as String;
    } catch (_) {
      return value.toString();
    }
  }

  String _getValueId(T value) {
    if (widget.getId != null) {
      return widget.getId!(value);
    }
    // Try to access 'id' property via dynamic
    try {
      return (value as dynamic).id as String;
    } catch (_) {
      return value.toString();
    }
  }

  bool _isSelected(T value) {
    if (widget.selectedValue == null) return false;
    return _getValueId(value) == _getValueId(widget.selectedValue as T);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 200), () {
      _performSearch(value);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredValues = widget.values;
      });
      return;
    }

    final queryLower = query.toLowerCase();
    final results = widget.values.where((value) {
      final nameLower = _getValueName(value).toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredValues = results;
    });
  }

  Future<void> _handleQuickAdd() async {
    if (widget.onQuickAdd != null && _searchQuery.isNotEmpty) {
      final newValue = await widget.onQuickAdd!(_searchQuery);
      if (newValue != null && mounted) {
        widget.onSelect(newValue);
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _showAddValueDialog() async {
    final result = await AddAttributeDialog.show(
      context: context,
      title: widget.title,
      initialValue: _searchQuery,
    );

    if (result != null && result.isNotEmpty && widget.onQuickAdd != null) {
      final newValue = await widget.onQuickAdd!(result);
      if (newValue != null && mounted) {
        widget.onSelect(newValue);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.arrow_back,
                color: TossColors.gray900,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Search field
          Expanded(
            child: TossSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: widget.searchHint,
              autofocus: true,
              onChanged: _onSearchChanged,
              onClear: () {
                setState(() {
                  _searchQuery = '';
                  _filteredValues = widget.values;
                });
              },
            ),
          ),
          // Add button - shows dialog to add new value
          IconButton(
            onPressed: _showAddValueDialog,
            icon: const Icon(
              Icons.add,
              color: TossColors.gray900,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Show empty state when no values exist at all
    if (widget.values.isEmpty) {
      return _buildEmptyState();
    }

    // Show no results state when search has no matches
    if (_filteredValues.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoResultsState();
    }

    // Show the list of values
    return _buildValuesList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon - using a custom filter/tag icon similar to the screenshot
          const Icon(
            Icons.filter_alt_outlined,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Add a value',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Column(
      children: [
        // Add new value row
        _buildAddNewValueRow(),
        // Empty state message
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  size: 48,
                  color: TossColors.gray400,
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  'Add a value',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewValueRow() {
    return InkWell(
      onTap: _handleQuickAdd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _searchQuery,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.add,
                color: TossColors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds text with highlighted search query matches in blue
  Widget _buildHighlightedText(String text, String query, bool isSelected) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final matchIndex = textLower.indexOf(queryLower);

    if (matchIndex == -1) {
      return Text(
        text,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    final beforeMatch = text.substring(0, matchIndex);
    final match = text.substring(matchIndex, matchIndex + query.length);
    final afterMatch = text.substring(matchIndex + query.length);

    return RichText(
      text: TextSpan(
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        children: [
          if (beforeMatch.isNotEmpty) TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (afterMatch.isNotEmpty) TextSpan(text: afterMatch),
        ],
      ),
    );
  }

  Widget _buildValuesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      itemCount: _filteredValues.length,
      itemBuilder: (context, index) {
        final value = _filteredValues[index];
        final isSelected = _isSelected(value);

        return InkWell(
          onTap: () {
            widget.onSelect(value);
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildHighlightedText(
                    _getValueName(value),
                    _searchQuery,
                    isSelected,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: TossColors.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
