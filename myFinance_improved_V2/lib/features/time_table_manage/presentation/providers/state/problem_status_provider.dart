/// Problem Status Provider
///
/// Cached problem calculations for the Problems tab.
/// This provider computes problem status once and caches it,
/// avoiding redundant calculations on every build.
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/shift_card.dart';
import 'manager_shift_cards_provider.dart';

// ============================================================================
// Problem Status Data Class
// ============================================================================

/// Cached problem data for a store and month
class ProblemStatusData {
  /// Problem status for each date (for calendar dots)
  final Map<String, ProblemStatus> statusByDate;

  /// Problem count by filter type
  final int todayCount;
  final int thisWeekCount;
  final int thisMonthCount;

  /// Pre-computed shift end times by staff+date key
  /// Key: "${staffId}_${shiftDate}", Value: latest end time for that staff on that date
  final Map<String, DateTime> consecutiveEndTimeMap;

  const ProblemStatusData({
    required this.statusByDate,
    required this.todayCount,
    required this.thisWeekCount,
    required this.thisMonthCount,
    required this.consecutiveEndTimeMap,
  });

  static const empty = ProblemStatusData(
    statusByDate: {},
    todayCount: 0,
    thisWeekCount: 0,
    thisMonthCount: 0,
    consecutiveEndTimeMap: {},
  );
}

// ============================================================================
// Provider Key
// ============================================================================

/// Key for problem status provider: storeId + focusedMonth
class ProblemStatusKey {
  final String storeId;
  final DateTime focusedMonth;

  const ProblemStatusKey({
    required this.storeId,
    required this.focusedMonth,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProblemStatusKey &&
        other.storeId == storeId &&
        other.focusedMonth.year == focusedMonth.year &&
        other.focusedMonth.month == focusedMonth.month;
  }

  @override
  int get hashCode => Object.hash(storeId, focusedMonth.year, focusedMonth.month);
}

// ============================================================================
// Provider
// ============================================================================

/// Problem Status Provider
///
/// Computes and caches problem status data for a store and month.
/// Uses managerCardsProvider as the source of truth.
///
/// Key optimizations:
/// 1. Single pass through all cards (O(n) instead of O(n*k))
/// 2. Pre-computed consecutive end time map (O(n) instead of O(n²))
/// 3. Results cached by Riverpod until cards change
final problemStatusProvider =
    Provider.family<ProblemStatusData, ProblemStatusKey>((ref, key) {
  final managerCardsState = ref.watch(managerCardsProvider(key.storeId));

  // Get all cards for calculations
  final allCards = managerCardsState.dataByMonth.values
      .expand((managerCards) => managerCards.cards)
      .where((card) => card.isApproved)
      .toList();

  if (allCards.isEmpty) {
    return ProblemStatusData.empty;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Pre-compute consecutive end times for all staff+date combinations
  // This is O(n) instead of O(n²)
  final Map<String, DateTime> consecutiveEndTimeMap = {};
  final Map<String, List<DateTime>> staffDateEndTimes = {};

  for (final card in allCards) {
    final endTime = _parseShiftEndTime(card.shiftEndTime);
    if (endTime == null) continue;

    final mapKey = '${card.employee.userId}_${card.shiftDate}';
    staffDateEndTimes.putIfAbsent(mapKey, () => []).add(endTime);
  }

  // Find the latest end time for each staff+date
  for (final entry in staffDateEndTimes.entries) {
    entry.value.sort();
    consecutiveEndTimeMap[entry.key] = entry.value.last;
  }

  // Calculate all statuses in a single pass
  final Map<String, ProblemStatus> statusByDate = {};
  final Map<String, _DateProblemFlags> dateFlags = {};

  // Track problem counts
  final Set<String> todayProblems = {};
  final Set<String> thisWeekProblems = {};
  final Set<String> thisMonthProblems = {};

  // Get week start (Monday)
  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: 6));

  for (final card in allCards) {
    if (!card.isApproved) continue;

    final shiftDate = DateTime.tryParse(card.shiftDate);
    if (shiftDate == null) continue;

    final cardDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day);

    // Skip future dates
    if (cardDate.isAfter(today)) continue;

    // Check if shift is still in progress
    final mapKey = '${card.employee.userId}_${card.shiftDate}';
    final shiftEndTime = consecutiveEndTimeMap[mapKey];
    if (shiftEndTime != null && now.isBefore(shiftEndTime)) {
      continue; // Shift still in progress
    }

    // Determine problem status
    final (hasUnsolvedProblem, hasUnsolvedReport, hasSolved) =
        _checkCardProblemStatus(card);

    // Update date flags for calendar
    final dateKey = card.shiftDate;
    dateFlags.putIfAbsent(dateKey, () => _DateProblemFlags());
    if (hasUnsolvedProblem) dateFlags[dateKey]!.hasUnsolvedProblem = true;
    if (hasUnsolvedReport) dateFlags[dateKey]!.hasUnsolvedReport = true;
    if (hasSolved) dateFlags[dateKey]!.hasSolved = true;

    // Count problems by filter
    if (hasUnsolvedProblem || hasUnsolvedReport) {
      // Today
      if (cardDate.isAtSameMomentAs(today)) {
        todayProblems.add(card.shiftRequestId);
      }

      // This week
      if (!cardDate.isBefore(weekStart) && !cardDate.isAfter(weekEnd)) {
        thisWeekProblems.add(card.shiftRequestId);
      }

      // This month
      if (cardDate.year == now.year && cardDate.month == now.month) {
        thisMonthProblems.add(card.shiftRequestId);
      }
    }
  }

  // Convert date flags to ProblemStatus
  // Priority: unsolvedProblem (red) > unsolvedReport (orange) > solved (green)
  for (final entry in dateFlags.entries) {
    final flags = entry.value;
    if (flags.hasUnsolvedProblem) {
      statusByDate[entry.key] = ProblemStatus.unsolvedProblem;
    } else if (flags.hasUnsolvedReport) {
      statusByDate[entry.key] = ProblemStatus.unsolvedReport;
    } else if (flags.hasSolved) {
      statusByDate[entry.key] = ProblemStatus.solved;
    }
  }

  return ProblemStatusData(
    statusByDate: statusByDate,
    todayCount: todayProblems.length,
    thisWeekCount: thisWeekProblems.length,
    thisMonthCount: thisMonthProblems.length,
    consecutiveEndTimeMap: consecutiveEndTimeMap,
  );
});

// ============================================================================
// Helper Classes
// ============================================================================

class _DateProblemFlags {
  bool hasUnsolvedProblem = false;
  bool hasUnsolvedReport = false;
  bool hasSolved = false;
}

// ============================================================================
// Helper Functions
// ============================================================================

/// Parse shift end time string to DateTime
DateTime? _parseShiftEndTime(String? shiftEndTimeStr) {
  if (shiftEndTimeStr == null || shiftEndTimeStr.isEmpty) return null;
  try {
    final normalized = shiftEndTimeStr.replaceAll('T', ' ');
    final parts = normalized.split(' ');
    if (parts.length < 2) return null;

    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    if (dateParts.length < 3 || timeParts.length < 2) return null;

    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  } catch (e) {
    return null;
  }
}

/// Check card problem status using problem_details_v2 exclusively
/// Returns (hasUnsolvedProblem, hasUnsolvedReport, hasSolved)
///
/// Logic: 1 shift = 1 unit
/// - If isFullySolved → hasSolved = true
/// - If !isFullySolved → check what's unsolved (report vs general problem)
(bool, bool, bool) _checkCardProblemStatus(ShiftCard card) {
  final pd = card.problemDetails;
  if (pd == null || pd.problemCount == 0) {
    return (false, false, false);
  }

  // 1 shift = 1 unit: check if fully solved
  if (pd.isFullySolved) {
    return (false, false, true); // hasSolved = true
  }

  // Not fully solved - determine what's unsolved for dot color
  bool hasUnsolvedProblem = false;
  bool hasUnsolvedReport = false;

  for (final problem in pd.problems) {
    if (!problem.isSolved) {
      if (problem.type == 'reported') {
        hasUnsolvedReport = true;
      } else {
        hasUnsolvedProblem = true;
      }
    }
  }

  return (hasUnsolvedProblem, hasUnsolvedReport, false);
}
