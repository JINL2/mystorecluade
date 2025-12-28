import 'package:flutter/material.dart';

/// Utility functions for notification settings
class NotificationUtils {
  NotificationUtils._();

  /// Format snake_case to Title Case
  static String formatName(String name) {
    return name
        .split('_')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  /// Get icon from key string
  static IconData getIconFromKey(String? iconKey) {
    switch (iconKey) {
      case 'Clock':
        return Icons.access_time_rounded;
      case 'ClockOff':
        return Icons.timer_off_outlined;
      case 'UserX':
        return Icons.running_with_errors_rounded;
      case 'FileText':
        return Icons.description_outlined;
      case 'TrendingDown':
        return Icons.trending_down_rounded;
      case 'TrendingUp':
        return Icons.trending_up_rounded;
      case 'Bell':
        return Icons.notifications_outlined;
      case 'BellRing':
        return Icons.notifications_active_outlined;
      case 'DollarSign':
        return Icons.attach_money_rounded;
      case 'Receipt':
        return Icons.receipt_long_outlined;
      case 'Users':
        return Icons.groups_outlined;
      case 'AlertCircle':
        return Icons.error_outline_rounded;
      case 'CheckCircle':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }
}
