import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';

/// Stock color helper utility
///
/// Provides color coding based on stock levels.
/// Business rule:
/// - 0 or less: Error (red)
/// - 1-10: Warning (orange)
/// - 11+: Success (green)
class StockColorHelper {
  /// Get color based on stock quantity
  static Color getStockColor(int stock) {
    if (stock <= 0) return TossColors.error;
    if (stock <= 10) return TossColors.warning;
    return TossColors.success;
  }

  /// Get stock status text
  static String getStockStatus(int stock) {
    if (stock <= 0) return 'Out of Stock';
    if (stock <= 10) return 'Low Stock';
    return 'In Stock';
  }
}
