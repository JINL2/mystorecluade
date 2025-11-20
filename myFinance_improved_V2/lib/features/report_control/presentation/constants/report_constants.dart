// lib/features/report_control/presentation/constants/report_constants.dart

/// Constants for Report Control feature
///
/// Centralized constants to avoid magic numbers and strings
class ReportConstants {
  ReportConstants._(); // Private constructor to prevent instantiation

  // ==================== Timezone ====================
  /// Default timezone for report scheduling
  static const String defaultTimezone = 'Asia/Seoul';

  // ==================== Calendar ====================
  /// Maximum day of month (1-31)
  static const int maxDayOfMonth = 31;

  // ==================== Pagination ====================
  /// Default number of reports to load per page
  static const int defaultReportsLimit = 50;

  /// Initial offset for pagination
  static const int initialOffset = 0;

  // ==================== UI Spacing ====================
  /// Extra small spacing (4px)
  static const double spacingXSmall = 4.0;

  /// Small spacing (8px)
  static const double spacingSmall = 8.0;

  /// Medium spacing (12px)
  static const double spacingMedium = 12.0;

  /// Large spacing (16px)
  static const double spacingLarge = 16.0;

  /// Extra large spacing (24px)
  static const double spacingXLarge = 24.0;

  // ==================== Notification Channels ====================
  /// Default notification channels
  static const List<String> defaultNotificationChannels = ['push'];

  // ==================== Icon Sizes ====================
  /// Large icon size for headers
  static const double iconSizeLarge = 64.0;

  /// Medium icon size for cards
  static const double iconSizeMedium = 40.0;

  /// Small icon size for inline elements
  static const double iconSizeSmall = 16.0;
}
