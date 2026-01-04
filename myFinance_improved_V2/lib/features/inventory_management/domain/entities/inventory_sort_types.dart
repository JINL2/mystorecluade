import 'product.dart';

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

  /// Create from string values (for server-side sort)
  static InventorySortOption? fromStrings(String sortBy, String sortDirection) {
    final dir = sortDirection == 'asc' ? InventorySortDirection.asc : InventorySortDirection.desc;

    switch (sortBy) {
      case 'name':
        return InventorySortOption(InventorySortField.name, dir);
      case 'price':
        return InventorySortOption(InventorySortField.price, dir);
      case 'stock':
        return InventorySortOption(InventorySortField.stock, dir);
      case 'value':
        return InventorySortOption(InventorySortField.value, dir);
      default:
        return null;
    }
  }

  /// Get sort field as string for RPC
  String get sortBy {
    switch (field) {
      case InventorySortField.name:
        return 'name';
      case InventorySortField.price:
        return 'price';
      case InventorySortField.stock:
        return 'stock';
      case InventorySortField.value:
        return 'value';
    }
  }

  /// Get sort direction as string for RPC
  String get sortDirection {
    return direction == InventorySortDirection.asc ? 'asc' : 'desc';
  }

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
