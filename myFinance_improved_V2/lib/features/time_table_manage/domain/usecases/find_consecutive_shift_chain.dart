import '../entities/daily_shift_data.dart';

/// Find Consecutive Shift Chain UseCase
///
/// Business logic to find all shifts connected in a consecutive chain.
/// Consecutive shifts are connected when:
/// - Previous shift's endTime == Current shift's startTime
/// - Current shift's endTime == Next shift's startTime
class FindConsecutiveShiftChainUseCase {
  /// Find the consecutive shift chain for a given shift
  ///
  /// [allDailyShifts] - List of daily shift data
  /// [currentShift] - The shift to find the chain for
  ///
  /// Returns list of [ShiftWithRequests] in the chain, ordered by start time
  List<ShiftWithRequests> call(
    List<DailyShiftData> allDailyShifts,
    ShiftWithRequests currentShift,
  ) {
    // Get all shifts flattened and sorted by start time
    final allShifts = allDailyShifts
        .expand((daily) => daily.shifts)
        .toList()
      ..sort((a, b) => a.shift.planStartTime.compareTo(b.shift.planStartTime));

    if (allShifts.isEmpty) return [currentShift];

    // Find current shift index
    final currentIndex = allShifts.indexWhere(
      (s) => s.shift.shiftId == currentShift.shift.shiftId,
    );
    if (currentIndex == -1) return [currentShift];

    final List<ShiftWithRequests> chain = [currentShift];

    // Look backwards for consecutive shifts
    for (int i = currentIndex - 1; i >= 0; i--) {
      final prevShift = allShifts[i];
      final nextInChain = chain.first;

      // Check if previous shift's end time matches next shift's start time
      if (_isConsecutive(prevShift.shift.planEndTime, nextInChain.shift.planStartTime)) {
        chain.insert(0, prevShift);
      } else {
        break; // Chain broken
      }
    }

    // Look forwards for consecutive shifts
    for (int i = currentIndex + 1; i < allShifts.length; i++) {
      final nextShift = allShifts[i];
      final prevInChain = chain.last;

      // Check if previous shift's end time matches next shift's start time
      if (_isConsecutive(prevInChain.shift.planEndTime, nextShift.shift.planStartTime)) {
        chain.add(nextShift);
      } else {
        break; // Chain broken
      }
    }

    return chain;
  }

  /// Check if two times are consecutive (exactly equal)
  bool _isConsecutive(DateTime endTime, DateTime startTime) {
    return endTime.hour == startTime.hour &&
        endTime.minute == startTime.minute &&
        endTime.year == startTime.year &&
        endTime.month == startTime.month &&
        endTime.day == startTime.day;
  }
}
