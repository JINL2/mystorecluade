import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../domain/entities/product.dart';

/// Client-side sort field options for inventory list
enum InventorySortField { name, price, stock, value }

/// Sort direction
enum InventorySortDirection { asc, desc }

/// Sort option combining field and direction
class InventorySortOption {
  final InventorySortField field;
  final InventorySortDirection direction;

  const InventorySortOption(this.field, this.direction);

  static const nameAsc = InventorySortOption(InventorySortField.name, InventorySortDirection.asc);
  static const nameDesc = InventorySortOption(InventorySortField.name, InventorySortDirection.desc);
  static const priceAsc = InventorySortOption(InventorySortField.price, InventorySortDirection.asc);
  static const priceDesc = InventorySortOption(InventorySortField.price, InventorySortDirection.desc);
  static const stockAsc = InventorySortOption(InventorySortField.stock, InventorySortDirection.asc);
  static const stockDesc = InventorySortOption(InventorySortField.stock, InventorySortDirection.desc);
  static const valueDesc = InventorySortOption(InventorySortField.value, InventorySortDirection.desc);

  /// Get human-readable label for this sort option
  String get label {
    final isAsc = direction == InventorySortDirection.asc;

    switch (field) {
      case InventorySortField.name:
        return isAsc ? 'Name (A-Z)' : 'Name (Z-A)';
      case InventorySortField.price:
        return isAsc ? 'Price (Low to High)' : 'Price (High to Low)';
      case InventorySortField.stock:
        return isAsc ? 'Stock (Low to High)' : 'Stock (High to Low)';
      case InventorySortField.value:
        return 'Value (High to Low)';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventorySortOption && field == other.field && direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}

/// Helper class for inventory sorting operations
class InventorySorter {
  /// Apply sort to product list
  static List<Product> applySort(List<Product> products, InventorySortOption? sortOption) {
    if (sortOption == null) return products;

    final sorted = List<Product>.from(products);
    final isAsc = sortOption.direction == InventorySortDirection.asc;

    switch (sortOption.field) {
      case InventorySortField.name:
        sorted.sort((a, b) => isAsc
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
      case InventorySortField.price:
        sorted.sort((a, b) => isAsc
            ? a.salePrice.compareTo(b.salePrice)
            : b.salePrice.compareTo(a.salePrice));
      case InventorySortField.stock:
        sorted.sort((a, b) => isAsc
            ? a.onHand.compareTo(b.onHand)
            : b.onHand.compareTo(a.onHand));
      case InventorySortField.value:
        sorted.sort((a, b) =>
            (b.onHand * b.salePrice).compareTo(a.onHand * a.salePrice));
    }

    return sorted;
  }

  /// Get label for current sort (or default)
  static String getSortLabel(InventorySortOption? sortOption) {
    return sortOption?.label ?? 'Name (A-Z)';
  }
}

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
