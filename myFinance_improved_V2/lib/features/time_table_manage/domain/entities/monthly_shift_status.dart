import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_shift_data.dart';

part 'monthly_shift_status.freezed.dart';
part 'monthly_shift_status.g.dart';

/// Monthly Shift Status Entity
///
/// Represents shift status data for a month in manager view.
@freezed
class MonthlyShiftStatus with _$MonthlyShiftStatus {
  const MonthlyShiftStatus._();

  const factory MonthlyShiftStatus({
    /// Month in yyyy-MM format
    required String month,
    @JsonKey(name: 'daily_shifts', defaultValue: <DailyShiftData>[])
    required List<DailyShiftData> dailyShifts,
    @JsonKey(defaultValue: <String, dynamic>{})
    required Map<String, dynamic> statistics,
  }) = _MonthlyShiftStatus;

  /// Create from JSON
  factory MonthlyShiftStatus.fromJson(Map<String, dynamic> json) =>
      _$MonthlyShiftStatusFromJson(json);

  /// Get total number of shifts in the month
  int get totalShifts {
    return dailyShifts.fold(0, (sum, day) => sum + day.shiftCount);
  }

  /// Get total pending requests in the month
  int get totalPendingRequests {
    return dailyShifts.fold(0, (sum, day) => sum + day.totalPendingRequests);
  }

  /// Get total approved requests in the month
  int get totalApprovedRequests {
    return dailyShifts.fold(0, (sum, day) => sum + day.totalApprovedRequests);
  }

  /// Get dates with pending requests
  List<String> get datesWithPendingRequests {
    return dailyShifts
        .where((day) => day.hasPendingRequests)
        .map((day) => day.date)
        .toList();
  }

  /// Get dates with under-staffed shifts
  List<String> get datesWithUnderStaffedShifts {
    return dailyShifts
        .where((day) => day.hasUnderStaffedShifts)
        .map((day) => day.date)
        .toList();
  }

  /// Find daily data by date
  DailyShiftData? findByDate(String date) {
    try {
      return dailyShifts.firstWhere((day) => day.date == date);
    } catch (e) {
      return null;
    }
  }
}
