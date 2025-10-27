import 'daily_shift_data.dart';

/// Monthly Shift Status Entity
///
/// Represents shift status data for a month in manager view.
class MonthlyShiftStatus {
  final String month; // yyyy-MM
  final List<DailyShiftData> dailyShifts;
  final Map<String, int> statistics;

  const MonthlyShiftStatus({
    required this.month,
    required this.dailyShifts,
    this.statistics = const {},
  });

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

  @override
  String toString() => 'MonthlyShiftStatus(month: $month, shifts: $totalShifts, pending: $totalPendingRequests)';
}
