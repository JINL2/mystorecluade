import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/option_trigger.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';

/// A complete selection organism combining trigger + bottom sheet.
///
/// Composes:
/// - [OptionTrigger] - The tappable field that opens the sheet
/// - [SelectionBottomSheetCommon] - The modal bottom sheet for selection
/// - [SelectionListItem] - The list items in the sheet (optional, can use custom)
///
/// ## Design Principles:
/// - **All-in-one**: Single widget for trigger + sheet + selection logic
/// - **Easy refactor**: Drop-in replacement for OptionTrigger + manual sheet calls
/// - **Flexible**: Supports both simple items and custom builders
/// - **Type-safe**: Generic type for value handling
///
/// ## Example Usage:
///
/// ### Simple with SelectionItem list:
/// ```dart
/// TriggerBottomSheetCommon<String>(
///   label: 'Store',
///   value: selectedStoreId,
///   items: stores.map((s) => SelectionItem(
///     id: s.id,
///     title: s.name,
///   )).toList(),
///   onChanged: (value) => setState(() => selectedStoreId = value),
/// )
/// ```
///
/// ### With custom item builder:
/// ```dart
/// TriggerBottomSheetCommon<String>(
///   label: 'Account',
///   value: selectedAccountId,
///   displayText: selectedAccount?.name,
///   itemCount: accounts.length,
///   itemBuilder: (context, index, isSelected, onSelect) {
///     final account = accounts[index];
///     return AccountTile(
///       account: account,
///       isSelected: isSelected,
///       onTap: () => onSelect(account.id),
///     );
///   },
///   onChanged: (value) => setState(() => selectedAccountId = value),
/// )
/// ```
///
/// ### With search:
/// ```dart
/// TriggerBottomSheetCommon<String>(
///   label: 'Location',
///   value: selectedLocationId,
///   items: locations,
///   showSearch: true,
///   searchHint: 'Search locations...',
///   onChanged: (value) => setState(() => selectedLocationId = value),
/// )
/// ```
class TriggerBottomSheetCommon<T> extends StatelessWidget {
  // ============================================
  // Trigger Properties (from OptionTrigger)
  // ============================================

  /// The label displayed above the trigger field
  final String label;

  /// The currently selected value
  final T? value;

  /// Custom display text (if not provided, derives from items)
  final String? displayText;

  /// Hint text when no value is selected
  final String? hint;

  /// Callback when a value is selected
  final ValueChanged<T?>? onChanged;

  /// Whether to show loading state
  final bool isLoading;

  /// Whether the field has an error
  final bool hasError;

  /// Error message to display below the field
  final String? errorText;

  /// Whether this field is required (shows asterisk)
  final bool isRequired;

  /// Whether the field is disabled
  final bool isDisabled;

  // ============================================
  // Bottom Sheet Properties
  // ============================================

  /// Title for the bottom sheet (defaults to label)
  final String? sheetTitle;

  /// Whether to show search field in the sheet
  final bool showSearch;

  /// Hint text for search field
  final String searchHint;

  /// Maximum height as ratio of screen (0.0 to 1.0)
  final double maxHeightRatio;

  /// Whether to show dividers between items
  final bool showDividers;

  /// Spacing between list items
  final double itemSpacing;

  // ============================================
  // Item Configuration - Option 1: Simple list
  // ============================================

  /// List of selection items (simple mode)
  /// Use this for straightforward lists with SelectionItem
  final List<SelectionItem>? items;

  /// Variant for SelectionListItem rendering
  final SelectionItemVariant itemVariant;

  // ============================================
  // Item Configuration - Option 2: Builder pattern
  // ============================================

  /// Number of items (required when using itemBuilder)
  final int? itemCount;

  /// Custom item builder for complex items
  /// Parameters: (context, index, isSelected, onSelect callback)
  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
    void Function(T value) onSelect,
  )? itemBuilder;

  /// Function to check if item at index is selected
  /// Required when using itemBuilder
  final bool Function(int index)? isItemSelected;

  const TriggerBottomSheetCommon({
    super.key,
    required this.label,
    this.value,
    this.displayText,
    this.hint,
    this.onChanged,
    this.isLoading = false,
    this.hasError = false,
    this.errorText,
    this.isRequired = false,
    this.isDisabled = false,
    // Sheet properties
    this.sheetTitle,
    this.showSearch = false,
    this.searchHint = 'Search...',
    this.maxHeightRatio = 0.7,
    this.showDividers = false,
    this.itemSpacing = 8.0,
    // Simple mode
    this.items,
    this.itemVariant = SelectionItemVariant.minimal,
    // Builder mode
    this.itemCount,
    this.itemBuilder,
    this.isItemSelected,
  }) : assert(
          items != null || (itemBuilder != null && itemCount != null),
          'Either items or both itemBuilder and itemCount must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return OptionTrigger(
      label: label,
      displayText: _getDisplayText(),
      hasSelection: value != null,
      isLoading: isLoading,
      hasError: hasError,
      errorText: errorText,
      isRequired: isRequired,
      isDisabled: isDisabled,
      onTap: _canTap ? () => _showBottomSheet(context) : null,
    );
  }

  bool get _canTap => !isLoading && !isDisabled && onChanged != null;

  String _getDisplayText() {
    // Use custom display text if provided
    if (displayText != null) return displayText!;

    // Try to find selected item from items list
    if (value != null && items != null) {
      final selectedItem = items!.where((item) => item.id == value.toString()).firstOrNull;
      if (selectedItem != null) return selectedItem.title;
    }

    // Fall back to hint or default
    return hint ?? 'Select $label';
  }

  void _showBottomSheet(BuildContext context) {
    SelectionBottomSheetCommon.show(
      context: context,
      title: sheetTitle ?? label,
      showSearch: showSearch,
      searchHint: searchHint,
      maxHeightRatio: maxHeightRatio,
      showDividers: showDividers,
      itemSpacing: itemSpacing,
      itemCount: items?.length ?? itemCount!,
      itemBuilder: (ctx, index) => _buildItem(ctx, index),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    // Use custom builder if provided
    if (itemBuilder != null) {
      final isSelected = isItemSelected?.call(index) ?? false;
      return itemBuilder!(
        context,
        index,
        isSelected,
        (selectedValue) {
          onChanged?.call(selectedValue);
          Navigator.of(context).pop();
        },
      );
    }

    // Use simple items list with SelectionListItem
    final item = items![index];
    final isSelected = item.id == value?.toString();

    return SelectionListItem(
      item: item,
      isSelected: isSelected,
      variant: itemVariant,
      onTap: () {
        // Try to parse back to T if possible, otherwise use id as string
        final selectedValue = _parseValue(item.id);
        onChanged?.call(selectedValue);
        Navigator.of(context).pop();
      },
    );
  }

  /// Attempt to parse the id back to type T
  T? _parseValue(String id) {
    // Handle common types
    if (T == String) return id as T;
    if (T == int) return int.tryParse(id) as T?;
    if (T == double) return double.tryParse(id) as T?;

    // Default: return as-is (assumes T is String-compatible)
    return id as T?;
  }
}
