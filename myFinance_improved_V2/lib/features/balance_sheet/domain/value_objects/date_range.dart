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

  /// Format start date as YYYY-MM-DD for RPC
  String get startDateFormatted {
    return '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
  }

  /// Format end date as YYYY-MM-DD for RPC
  String get endDateFormatted {
    return '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
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
