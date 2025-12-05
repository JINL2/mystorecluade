import '../entities/daily_shift_data.dart';

/// Find Current Activity Shift UseCase
///
/// Business logic to find the current or nearest shift.
/// - If current time is within shift_start_time ~ shift_end_time, return that shift
/// - Otherwise, return the shift with smallest time difference to now
class FindCurrentShiftUseCase {
  /// Find the current activity shift from daily shifts data
  ///
  /// [allDailyShifts] - List of daily shift data
  /// [referenceTime] - Reference time (defaults to now)
  ///
  /// Returns the current or nearest [ShiftWithRequests], or null if none found
  ShiftWithRequests? call(
    List<DailyShiftData> allDailyShifts, {
    DateTime? referenceTime,
  }) {
    if (allDailyShifts.isEmpty) return null;

    final now = referenceTime ?? DateTime.now();
    ShiftWithRequests? currentShift;
    Duration? smallestDiff;

    for (final dailyData in allDailyShifts) {
      for (final shiftWithReqs in dailyData.shifts) {
        final startTime = shiftWithReqs.shift.planStartTime;
        final endTime = shiftWithReqs.shift.planEndTime;

        // If now is within the shift time range, this is the current activity
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          return shiftWithReqs;
        }

        // Calculate time difference from shift_start_time to now
        final diff = startTime.difference(now).abs();

        if (smallestDiff == null || diff < smallestDiff) {
          smallestDiff = diff;
          currentShift = shiftWithReqs;
        }
      }
    }

    return currentShift;
  }
}
