// Presentation Extension: StockStatus Display
// Provides display-related properties for StockStatus enum
// Keeps Domain layer pure by moving UI concerns to Presentation

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../domain/entities/product.dart';

/// Extension to provide display properties for StockStatus
/// This keeps the Domain layer pure and moves UI concerns to Presentation
extension StockStatusDisplay on StockStatus {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.critical:
        return 'Critical';
      case StockStatus.low:
        return 'Low';
      case StockStatus.normal:
        return 'Normal';
      case StockStatus.excess:
        return 'Excess';
    }
  }

  /// Color associated with this stock status
  Color get color {
    switch (this) {
      case StockStatus.outOfStock:
        return TossColors.error;
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.normal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.info;
    }
  }
}
