// Value Object: Product Filter
// Encapsulates product filtering criteria

class ProductFilter {
  final String? searchQuery;
  final String? categoryId;
  final String? brandId;
  final String? stockStatus;

  const ProductFilter({
    this.searchQuery,
    this.categoryId,
    this.brandId,
    this.stockStatus,
  });

  bool get hasFilters =>
      searchQuery != null ||
      categoryId != null ||
      brandId != null ||
      stockStatus != null;

  int get activeFilterCount {
    int count = 0;
    if (categoryId != null) count++;
    if (brandId != null) count++;
    if (stockStatus != null) count++;
    return count;
  }

  ProductFilter copyWith({
    String? searchQuery,
    String? categoryId,
    String? brandId,
    String? stockStatus,
    bool clearSearchQuery = false,
    bool clearCategoryId = false,
    bool clearBrandId = false,
    bool clearStockStatus = false,
  }) {
    return ProductFilter(
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      brandId: clearBrandId ? null : (brandId ?? this.brandId),
      stockStatus: clearStockStatus ? null : (stockStatus ?? this.stockStatus),
    );
  }

  ProductFilter clearAll() {
    return const ProductFilter();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductFilter &&
        other.searchQuery == searchQuery &&
        other.categoryId == categoryId &&
        other.brandId == brandId &&
        other.stockStatus == stockStatus;
  }

  @override
  int get hashCode {
    return searchQuery.hashCode ^
        categoryId.hashCode ^
        brandId.hashCode ^
        stockStatus.hashCode;
  }
}
