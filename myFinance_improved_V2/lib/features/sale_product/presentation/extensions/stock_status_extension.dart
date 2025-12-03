// Presentation Extension: StockStatus Display
// Provides display-related properties for StockStatus enum
// Keeps Domain layer pure by moving UI concerns to Presentation

import '../../domain/value_objects/stock_status.dart';

/// Extension to provide display properties for StockStatus
/// This keeps the Domain layer pure and moves UI concerns to Presentation
extension StockStatusDisplay on StockStatus {
  /// Display name for UI
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
