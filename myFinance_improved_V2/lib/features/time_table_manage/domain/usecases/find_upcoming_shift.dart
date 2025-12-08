import '../entities/daily_shift_data.dart';

/// Find Upcoming Shift UseCase
///
/// Business logic to find the next shift after current activity.
class FindUpcomingShiftUseCase {
  /// Find the upcoming shift (next shift after current activity)
  ///
  /// [allDailyShifts] - List of daily shift data
  /// [currentActivityShift] - The current activity shift (to exclude)
  /// [referenceTime] - Reference time (defaults to current shift start or now)
  ///
  /// Returns the next upcoming [ShiftWithRequests], or null if none found
  ShiftWithRequests? call(
    List<DailyShiftData> allDailyShifts,
    ShiftWithRequests? currentActivityShift, {
    DateTime? referenceTime,
  }) {
    if (allDailyShifts.isEmpty) return null;

    // Reference point: current activity's start time, or now if no current activity
    final refTime =
        referenceTime ?? currentActivityShift?.shift.planStartTime ?? DateTime.now();
    final currentShiftId = currentActivityShift?.shift.shiftId;

    ShiftWithRequests? upcomingShift;
    DateTime? earliestUpcoming;

    for (final dailyData in allDailyShifts) {
      for (final shiftWithReqs in dailyData.shifts) {
        final startTime = shiftWithReqs.shift.planStartTime;

        // Skip if this is the current activity shift
        if (currentShiftId != null && shiftWithReqs.shift.shiftId == currentShiftId) {
          continue;
        }

        // Skip if starts before or at the reference time
        if (startTime.isBefore(refTime) || startTime.isAtSameMomentAs(refTime)) {
          continue;
        }

        // Find the earliest shift after reference time
        if (earliestUpcoming == null || startTime.isBefore(earliestUpcoming)) {
          earliestUpcoming = startTime;
          upcomingShift = shiftWithReqs;
        }
      }
    }

    return upcomingShift;
  }
}
