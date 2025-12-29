import '../../../../domain/entities/shift_card.dart';
import '../../../pages/shift_stats_tab.dart';
import '../../../providers/states/time_table_state.dart';

/// Stats Problem Calculator
///
/// Calculates problem counts from manager cards using problem_details_v2.
/// This ensures consistency with Problems tab counting logic.
class StatsProblemCalculator {
  StatsProblemCalculator._();

  /// Get problem counts from managerCardsProvider using problem_details_v2
  /// Returns (unsolvedCount, solvedCount) for the selected period
  static (int, int) getProblemCountsFromCards(
    ManagerShiftCardsState managerCardsState,
    StatsPeriod selectedPeriod,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get date range based on selected period
    late DateTime periodStart;
    late DateTime periodEnd;

    switch (selectedPeriod) {
      case StatsPeriod.today:
        periodStart = today;
        periodEnd = today;
      case StatsPeriod.thisMonth:
        periodStart = DateTime(now.year, now.month, 1);
        periodEnd = DateTime(now.year, now.month + 1, 0); // Last day of month
      case StatsPeriod.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        periodStart = lastMonth;
        periodEnd = DateTime(lastMonth.year, lastMonth.month + 1, 0);
    }

    // Track unique shift_request_ids (EXACT same as Problems tab)
    final Set<String> shiftsWithUnsolved = {};
    final Set<String> shiftsWithSolved = {};

    // Get all approved cards
    final List<ShiftCard> allCards = managerCardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .where((card) => card.isApproved)
        .toList();

    for (final ShiftCard card in allCards) {
      final shiftDate = DateTime.tryParse(card.shiftDate);
      if (shiftDate == null) continue;

      final cardDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day);

      // Check if card is within period
      if (cardDate.isBefore(periodStart) || cardDate.isAfter(periodEnd)) {
        continue;
      }

      // Skip future dates - can't have problems yet
      if (cardDate.isAfter(today)) {
        continue;
      }

      // Skip if shift is still in progress (EXACT same logic as Problems tab)
      final currentShiftEndTime = _parseShiftEndTime(card.shiftEndTime);
      final shiftEndTime = _findConsecutiveEndTime(
        staffId: card.employee.userId,
        shiftDate: card.shiftDate,
        currentShiftEndTime: currentShiftEndTime,
        allCards: allCards,
      );
      final isInProgress =
          shiftEndTime != null && DateTime.now().isBefore(shiftEndTime);
      if (isInProgress) {
        continue;
      }

      // Check if this shift has problems using problem_details_v2 exclusively
      // 1 shift = 1 unit (not individual problem items)
      // Use isFullySolved which checks both isSolved AND reported status
      final pd = card.problemDetails;
      if (pd != null && pd.problemCount > 0) {
        if (pd.isFullySolved) {
          shiftsWithSolved.add(card.shiftRequestId);
        } else {
          shiftsWithUnsolved.add(card.shiftRequestId);
        }
      }
    }
    return (shiftsWithUnsolved.length, shiftsWithSolved.length);
  }

  /// Parse shift end time string to DateTime
  /// Format: "2025-12-08 18:00" or "2025-12-08T18:00:00" or "HH:mm"
  static DateTime? _parseShiftEndTime(String? shiftEndTimeStr) {
    if (shiftEndTimeStr == null || shiftEndTimeStr.isEmpty) return null;
    try {
      // Normalize: replace 'T' with space if present
      final normalized = shiftEndTimeStr.replaceAll('T', ' ');
      final parts = normalized.split(' ');
      if (parts.length < 2) return null;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length < 3 || timeParts.length < 2) return null;

      return DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
        int.parse(timeParts[0]), // hour
        int.parse(timeParts[1]), // minute
      );
    } catch (e) {
      return null;
    }
  }

  /// Find the consecutive end time for a staff member on a given date
  static DateTime? _findConsecutiveEndTime({
    required String staffId,
    required String shiftDate,
    required DateTime? currentShiftEndTime,
    required List<ShiftCard> allCards,
  }) {
    if (currentShiftEndTime == null) return null;

    // Find all shifts for this staff member on the same date
    final staffShiftsOnDate = allCards
        .where((c) => c.employee.userId == staffId && c.shiftDate == shiftDate)
        .toList();

    if (staffShiftsOnDate.isEmpty) return currentShiftEndTime;

    // Parse all shift end times and sort
    final shiftEndTimes = <DateTime>[];
    for (final card in staffShiftsOnDate) {
      final endTime = _parseShiftEndTime(card.shiftEndTime);
      if (endTime != null) {
        shiftEndTimes.add(endTime);
      }
    }

    if (shiftEndTimes.isEmpty) return currentShiftEndTime;

    // Sort by time
    shiftEndTimes.sort();

    // Return the latest end time (last shift of the day for this staff)
    return shiftEndTimes.last;
  }

  /// Extract employee UUIDs from shift cards for a given month
  /// Returns Set of user IDs who have actual work history in that month
  static Set<String> extractEmployeeIdsFromCards(
    ManagerShiftCardsState cardsState,
    String monthKey,
  ) {
    final monthData = cardsState.dataByMonth[monthKey];
    if (monthData == null) {
      return {};
    }

    // Extract unique employee user IDs from shift cards
    // Only include non-empty user IDs
    return monthData.cards
        .map((card) => card.employee.userId)
        .where((userId) => userId.isNotEmpty)
        .toSet();
  }
}
