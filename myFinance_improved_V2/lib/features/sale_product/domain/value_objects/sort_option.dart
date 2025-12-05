/// Sort options for product list
/// Note: Display names should be handled in Presentation layer via extensions
enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
}

/// Domain extension for SortOption business logic
/// UI display properties are in presentation/extensions/sort_option_extension.dart
extension SortOptionExtension on SortOption {
  /// Whether the sort direction is ascending (business logic)
  bool get isAscending {
    switch (this) {
      case SortOption.nameAsc:
      case SortOption.priceAsc:
      case SortOption.stockAsc:
        return true;
      case SortOption.nameDesc:
      case SortOption.priceDesc:
      case SortOption.stockDesc:
        return false;
    }
  }

  /// Get the opposite sort direction (business logic)
  SortOption get toggled {
    switch (this) {
      case SortOption.nameAsc:
        return SortOption.nameDesc;
      case SortOption.nameDesc:
        return SortOption.nameAsc;
      case SortOption.priceAsc:
        return SortOption.priceDesc;
      case SortOption.priceDesc:
        return SortOption.priceAsc;
      case SortOption.stockAsc:
        return SortOption.stockDesc;
      case SortOption.stockDesc:
        return SortOption.stockAsc;
    }
  }
}
