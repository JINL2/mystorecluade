import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';

/// Bottom sheet for selecting transaction filters
/// Uses SelectionBottomSheetCommon for consistent styling
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
        .map((option) => SelectionItem(
              id: option,
              title: option,
            ))
        .toList();

    return SelectionBottomSheetCommon.show(
      context: context,
      title: 'Filter Transactions',
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        final isSelected = item.id == selectedFilter;
        return SelectionListItem(
          item: item,
          isSelected: isSelected,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            onFilterSelected(item.id);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }
}
