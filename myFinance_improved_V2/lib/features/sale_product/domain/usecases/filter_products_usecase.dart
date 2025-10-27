import '../entities/sales_product.dart';
import '../value_objects/sort_option.dart';

/// Filter and sort products use case
///
/// Business logic for filtering and sorting product lists.
/// Applies search filters and sorting criteria.
class FilterProductsUseCase {
  /// Execute the use case
  List<SalesProduct> execute({
    required List<SalesProduct> products,
    required String searchQuery,
    required SortOption sortOption,
  }) {
    var result = List<SalesProduct>.from(products);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      result = _applySearchFilter(result, searchQuery);
    }

    // Apply sorting
    result = _applySorting(result, sortOption);

    return result;
  }

  /// Apply search filter to product list
  List<SalesProduct> _applySearchFilter(
    List<SalesProduct> products,
    String searchQuery,
  ) {
    final searchLower = searchQuery.toLowerCase();
    return products.where((product) {
      return product.productName.toLowerCase().contains(searchLower) ||
          product.sku.toLowerCase().contains(searchLower);
    }).toList();
  }

  /// Apply sorting to product list
  List<SalesProduct> _applySorting(
    List<SalesProduct> products,
    SortOption sortOption,
  ) {
    final sortedProducts = List<SalesProduct>.from(products);

    sortedProducts.sort((a, b) {
      switch (sortOption) {
        case SortOption.nameAsc:
          return a.productName.compareTo(b.productName);
        case SortOption.nameDesc:
          return b.productName.compareTo(a.productName);
        case SortOption.priceAsc:
          final aPrice = a.pricing.sellingPrice ?? 0;
          final bPrice = b.pricing.sellingPrice ?? 0;
          return aPrice.compareTo(bPrice);
        case SortOption.priceDesc:
          final aPrice = a.pricing.sellingPrice ?? 0;
          final bPrice = b.pricing.sellingPrice ?? 0;
          return bPrice.compareTo(aPrice);
        case SortOption.stockAsc:
          return a.totalStockSummary.totalQuantityOnHand
              .compareTo(b.totalStockSummary.totalQuantityOnHand);
        case SortOption.stockDesc:
          return b.totalStockSummary.totalQuantityOnHand
              .compareTo(a.totalStockSummary.totalQuantityOnHand);
      }
    });

    return sortedProducts;
  }
}
