/// Sort options for product list
enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  stockAsc,
  stockDesc,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.nameAsc:
      case SortOption.nameDesc:
        return 'Name';
      case SortOption.priceAsc:
      case SortOption.priceDesc:
        return 'Price';
      case SortOption.stockAsc:
      case SortOption.stockDesc:
        return 'Stock';
    }
  }

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
