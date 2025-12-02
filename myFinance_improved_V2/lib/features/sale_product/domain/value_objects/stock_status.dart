/// Stock status value object - encapsulates stock level business rules
enum StockStatus {
  outOfStock,
  lowStock,
  inStock;

  /// Business rule: Determine stock status from quantity
  /// - 0 or less: Out of stock
  /// - 1-10: Low stock
  /// - 11+: In stock
  factory StockStatus.fromQuantity(int quantity) {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= 10) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  String get displayName {
    switch (this) {
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.inStock:
        return 'In Stock';
    }
  }
}
