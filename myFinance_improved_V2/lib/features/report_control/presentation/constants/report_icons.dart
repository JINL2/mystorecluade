// lib/features/report_control/presentation/constants/report_icons.dart

import 'package:flutter/material.dart';

/// Icon constants for Report Control feature
///
/// Category-specific icons for consistent visual representation
class ReportIcons {
  ReportIcons._(); // Private constructor

  // ==================== Category Icons ====================

  /// Finance category icon
  static const IconData finance = Icons.account_balance_wallet;

  /// Human Resources category icon
  static const IconData humanResources = Icons.people;

  /// Operations category icon
  static const IconData operations = Icons.settings;

  /// Sales category icon
  static const IconData sales = Icons.shopping_cart;

  /// Marketing category icon
  static const IconData marketing = Icons.campaign;

  /// IT category icon
  static const IconData it = Icons.computer;

  /// Default fallback icon for unknown categories
  static const IconData defaultCategory = Icons.description;

  // ==================== Status Icons ====================

  /// Completed status icon
  static const IconData completed = Icons.check_circle;

  /// Failed status icon
  static const IconData failed = Icons.error;

  /// Pending status icon
  static const IconData pending = Icons.schedule;

  /// Processing status icon
  static const IconData processing = Icons.hourglass_empty;

  // ==================== Template Type Icons ====================

  /// Daily report icon
  static const IconData daily = Icons.today;

  /// Weekly report icon
  static const IconData weekly = Icons.date_range;

  /// Monthly report icon
  static const IconData monthly = Icons.calendar_month;

  // ==================== Helper Methods ====================

  /// Get icon for category name
  static IconData getCategoryIcon(String? categoryName) {
    if (categoryName == null) return defaultCategory;

    final normalized = categoryName.toLowerCase().trim();

    if (normalized.contains('finance') ||
        normalized.contains('재무') ||
        normalized.contains('회계')) {
      return finance;
    } else if (normalized.contains('human') ||
        normalized.contains('hr') ||
        normalized.contains('인사') ||
        normalized.contains('근태')) {
      return humanResources;
    } else if (normalized.contains('sales') ||
        normalized.contains('영업') ||
        normalized.contains('판매')) {
      return sales;
    } else if (normalized.contains('marketing') || normalized.contains('마케팅')) {
      return marketing;
    } else if (normalized.contains('operation') || normalized.contains('운영')) {
      return operations;
    } else if (normalized.contains('it') ||
        normalized.contains('tech') ||
        normalized.contains('기술')) {
      return it;
    }

    return defaultCategory;
  }

  /// Get icon for frequency
  static IconData getFrequencyIcon(String? frequency) {
    if (frequency == null) return daily;

    final normalized = frequency.toLowerCase().trim();

    if (normalized.contains('daily') || normalized.contains('일간')) {
      return daily;
    } else if (normalized.contains('weekly') || normalized.contains('주간')) {
      return weekly;
    } else if (normalized.contains('monthly') || normalized.contains('월간')) {
      return monthly;
    }

    return daily;
  }

  /// Get icon for status
  static IconData getStatusIcon(String? status) {
    if (status == null) return pending;

    final normalized = status.toLowerCase().trim();

    if (normalized == 'completed' || normalized == '완료') {
      return completed;
    } else if (normalized == 'failed' || normalized == '실패') {
      return failed;
    } else if (normalized == 'pending' || normalized == '대기') {
      return pending;
    } else if (normalized == 'processing' || normalized == '처리중') {
      return processing;
    }

    return pending;
  }
}
