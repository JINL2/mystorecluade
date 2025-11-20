// lib/features/report_control/presentation/utils/category_utils.dart

import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';

/// Utility class for category-related operations
///
/// Provides color mapping for different report categories
class CategoryUtils {
  // Private constructor to prevent instantiation
  CategoryUtils._();

  // Cache for normalized category names
  static final Map<String, Color> _colorCache = {};

  /// Get category color based on category name
  ///
  /// Returns consistent colors for category types:
  /// - Finance/재무/회계: Primary blue
  /// - HR/인사/근태: Purple
  /// - Sales/영업/판매: Success green
  /// - Marketing/마케팅: Deep orange
  /// - Operations/운영: Blue grey
  /// - IT/Tech/기술: Cyan
  static Color getCategoryColor(String? categoryName) {
    if (categoryName == null) return TossColors.primary;

    // Check cache first
    if (_colorCache.containsKey(categoryName)) {
      return _colorCache[categoryName]!;
    }

    final normalized = categoryName.toLowerCase().trim();
    Color color;

    if (normalized.contains('finance') ||
        normalized.contains('재무') ||
        normalized.contains('회계')) {
      color = TossColors.primary;
    } else if (normalized.contains('human') ||
        normalized.contains('hr') ||
        normalized.contains('인사') ||
        normalized.contains('근태')) {
      color = const Color(0xFF9C27B0); // Purple
    } else if (normalized.contains('sales') ||
        normalized.contains('영업') ||
        normalized.contains('판매')) {
      color = TossColors.success;
    } else if (normalized.contains('marketing') ||
        normalized.contains('마케팅')) {
      color = const Color(0xFFFF5722); // Deep Orange
    } else if (normalized.contains('operation') ||
        normalized.contains('운영')) {
      color = const Color(0xFF607D8B); // Blue Grey
    } else if (normalized.contains('it') ||
        normalized.contains('tech') ||
        normalized.contains('기술')) {
      color = const Color(0xFF00BCD4); // Cyan
    } else {
      color = TossColors.primary;
    }

    _colorCache[categoryName] = color;
    return color;
  }

  /// Clear the color cache
  ///
  /// Call this if category configurations change at runtime
  static void clearCache() {
    _colorCache.clear();
  }
}
