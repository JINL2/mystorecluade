import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../domain/value_objects/stock_status.dart';
import '../extensions/stock_status_extension.dart';

/// Stock color mapper utility
///
/// Maps domain StockStatus to UI colors.
/// Business rules are in Domain layer (StockStatus.fromQuantity).
class StockColorHelper {
  /// Get color based on stock quantity
  /// Delegates business logic to Domain layer
  static Color getStockColor(int stock) {
    final status = StockStatus.fromQuantity(stock);
    return mapStatusToColor(status);
  }

  /// Map StockStatus to color (pure UI concern)
  static Color mapStatusToColor(StockStatus status) {
    switch (status) {
      case StockStatus.outOfStock:
        return TossColors.error;
      case StockStatus.lowStock:
        return TossColors.warning;
      case StockStatus.inStock:
        return TossColors.success;
    }
  }

  /// Get stock status text
  /// Uses Presentation extension for display name
  static String getStockStatus(int stock) {
    final status = StockStatus.fromQuantity(stock);
    return status.displayName;
  }
}
