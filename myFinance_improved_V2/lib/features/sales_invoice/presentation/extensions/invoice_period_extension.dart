// Presentation Extension: InvoicePeriod Display
// Provides display-related properties (displayName) for period filter
// Keeps Domain layer pure by moving UI concerns to Presentation

import '../../domain/value_objects/invoice_period.dart';

// Re-export domain type for convenience
export '../../domain/value_objects/invoice_period.dart';

/// Extension to provide UI display properties for InvoicePeriod
extension InvoicePeriodDisplay on InvoicePeriod {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case InvoicePeriod.today:
        return 'Today';
      case InvoicePeriod.yesterday:
        return 'Yesterday';
      case InvoicePeriod.thisWeek:
        return 'This week';
      case InvoicePeriod.thisMonth:
        return 'This month';
      case InvoicePeriod.lastMonth:
        return 'Last month';
      case InvoicePeriod.allTime:
        return 'All time';
    }
  }
}
