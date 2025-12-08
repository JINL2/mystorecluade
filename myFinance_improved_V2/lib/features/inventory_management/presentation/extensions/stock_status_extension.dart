// Presentation Extension: StockStatus Display
// Provides display-related properties for StockStatus enum
// Keeps Domain layer pure by moving UI concerns to Presentation

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../domain/entities/product.dart';

/// Extension to provide display properties for StockStatus
/// This keeps the Domain layer pure and moves UI concerns to Presentation
extension StockStatusDisplay on StockStatus {
  /// Display name for UI (localized)
  String get displayName {
    switch (this) {
      case StockStatus.outOfStock:
        return '품절';
      case StockStatus.critical:
        return '긴급';
      case StockStatus.low:
        return '부족';
      case StockStatus.normal:
        return '정상';
      case StockStatus.excess:
        return '과재고';
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
