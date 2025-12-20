import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_range.freezed.dart';

/// Date range value object for financial statements
@freezed
class DateRange with _$DateRange {
  const factory DateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) = _DateRange;

  const DateRange._();

  /// Format start date as YYYY-MM-DD for RPC (legacy v2 format)
  String get startDateFormatted {
    return '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
  }

  /// Format end date as YYYY-MM-DD for RPC (legacy v2 format)
  String get endDateFormatted {
    return '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
  }

  /// Format start time as YYYY-MM-DD HH:MM:SS for v3 RPC (timestamp format)
  /// Example: '2025-12-01 00:00:00'
  String get startTimeFormatted {
    return '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} 00:00:00';
  }

  /// Format end time as YYYY-MM-DD HH:MM:SS for v3 RPC (timestamp format)
  /// Example: '2025-12-31 23:59:59'
  String get endTimeFormatted {
    return '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} 23:59:59';
  }

  /// Create date range for current month
  factory DateRange.currentMonth() {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, now.month, 1),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  /// Validate date range
  bool get isValid => endDate.isAfter(startDate) || endDate.isAtSameMomentAs(startDate);
}
