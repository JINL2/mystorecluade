import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart';

/// Bottom sheet for selecting transaction filters
/// Uses TossSelectionBottomSheet for consistent styling
class FilterBottomSheet {
  FilterBottomSheet._();

  /// Show filter selection bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String selectedFilter,
    required List<String> filterOptions,
    required Function(String) onFilterSelected,
  }) {
    final items = filterOptions
        .map((option) => TossSelectionItem(
              id: option,
              title: option,
            ))
        .toList();

    return TossSelectionBottomSheet.show(
      context: context,
      title: 'Filter Transactions',
      items: items,
      selectedId: selectedFilter,
      showIcon: false,
      showSubtitle: false,
      onItemSelected: (item) {
        onFilterSelected(item.id);
      },
    );
  }
}
