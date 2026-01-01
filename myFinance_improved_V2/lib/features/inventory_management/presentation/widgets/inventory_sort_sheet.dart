import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/inventory_sort_types.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../domain/entities/inventory_sort_types.dart';

/// Bottom sheet for selecting sort option
class InventorySortSheet {
  /// Show the sort options sheet
  static void show({
    required BuildContext context,
    required InventorySortOption? currentSort,
    required ValueChanged<InventorySortOption?> onSortChanged,
  }) {
    TossBottomSheet.show(
      context: context,
      title: 'Sort By',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SortOptionTile(
              label: 'Name (A-Z)',
              option: InventorySortOption.nameAsc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Name (Z-A)',
              option: InventorySortOption.nameDesc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Price (Low to High)',
              option: InventorySortOption.priceAsc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Price (High to Low)',
              option: InventorySortOption.priceDesc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Stock (Low to High)',
              option: InventorySortOption.stockAsc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Stock (High to Low)',
              option: InventorySortOption.stockDesc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              label: 'Value (High to Low)',
              option: InventorySortOption.valueDesc,
              currentSort: currentSort,
              onTap: (option) {
                onSortChanged(_toggleSort(currentSort, option));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle sort off if same option selected, otherwise set new sort
  static InventorySortOption? _toggleSort(
    InventorySortOption? current,
    InventorySortOption selected,
  ) {
    return current == selected ? null : selected;
  }
}

class _SortOptionTile extends StatelessWidget {
  final String label;
  final InventorySortOption option;
  final InventorySortOption? currentSort;
  final ValueChanged<InventorySortOption> onTap;

  const _SortOptionTile({
    required this.label,
    required this.option,
    required this.currentSort,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentSort == option;

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: TossColors.primary, size: 20)
          : null,
      onTap: () => onTap(option),
    );
  }
}
