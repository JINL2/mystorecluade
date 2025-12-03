// Presentation Extension: SortOption Display
// Provides display-related properties for SortOption enum
// Keeps Domain layer pure by moving UI concerns to Presentation

import '../../domain/value_objects/sort_option.dart';

// Re-export domain type for convenience
export '../../domain/value_objects/sort_option.dart';

/// Extension to provide display properties for SortOption
/// This keeps the Domain layer pure and moves UI concerns to Presentation
extension SortOptionDisplay on SortOption {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.priceAsc:
        return 'Price (Low-High)';
      case SortOption.priceDesc:
        return 'Price (High-Low)';
      case SortOption.stockAsc:
        return 'Stock (Low-High)';
      case SortOption.stockDesc:
        return 'Stock (High-Low)';
    }
  }
}
