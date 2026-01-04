import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/shift_card.dart';
import '../../providers/states/time_table_state.dart';

/// Mixin providing helper methods for OverviewTab
///
/// Includes caching logic and utility functions for time/date formatting
mixin OverviewHelpersMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// Cached all cards from manager cards state (expensive to compute)
  List<ShiftCard>? cachedAllCards;

  /// Hash of the last manager cards state to detect changes
  int lastCardsStateHash = 0;

  /// Cached cards by shift lookup (Map<"shiftDate_shiftName", List<ShiftCard>>)
  Map<String, List<ShiftCard>>? cachedCardsByShift;

  /// Get all cards with caching (avoids repeated .expand() and .toList())
  ///
  /// IMPORTANT: Cache is invalidated when:
  /// 1. Number of months or total cards changes
  /// 2. Problem status on any card changes (detected via problemHash)
  List<ShiftCard> getAllCards(ManagerShiftCardsState? cardsState) {
    if (cardsState == null) return [];

    // Create a hash that includes:
    // 1. Number of months and total cards
    // 2. Problem status (problemCount + unsolved count) for cache invalidation
    final countHash = cardsState.dataByMonth.length * 1000 +
        cardsState.dataByMonth.values
            .fold<int>(0, (sum, m) => sum + m.cards.length);

    // Include problem status in hash to detect isSolved changes
    final problemHash = cardsState.dataByMonth.values
        .expand((m) => m.cards)
        .where((c) => c.isApproved && c.problemDetails != null)
        .fold<int>(0, (sum, c) {
      final pd = c.problemDetails!;
      final unsolvedCount = pd.problems.where((p) => p.isSolved != true).length;
      return sum + pd.problemCount * 10 + unsolvedCount;
    });

    final currentHash = countHash * 1000 + problemHash;

    if (cachedAllCards != null && lastCardsStateHash == currentHash) {
      return cachedAllCards!;
    }

    // Compute and cache
    cachedAllCards = cardsState.dataByMonth.values
        .expand((managerCards) => managerCards.cards)
        .toList();
    lastCardsStateHash = currentHash;

    // Also rebuild the cards-by-shift lookup
    cachedCardsByShift = {};
    for (final card in cachedAllCards!) {
      if (!card.isApproved) continue;
      final key = '${card.shiftDate}_${card.shift.shiftName}';
      cachedCardsByShift!.putIfAbsent(key, () => []).add(card);
    }

    return cachedAllCards!;
  }

  /// Get cards for a specific shift from manager cards data
  ///
  /// OPTIMIZED: Uses cached lookup map instead of filtering all cards each time
  /// Note: RPC doesn't return shift_id, so we match by:
  /// - shiftDate (exact match)
  /// - shiftName (exact match)
  /// - isApproved = true (only approved cards)
  List<ShiftCard> getCardsForShift(
    ManagerShiftCardsState? cardsState,
    String shiftName,
    String shiftDate,
  ) {
    if (cardsState == null) return [];

    // Ensure cache is populated
    getAllCards(cardsState);

    // O(1) lookup instead of O(n) filtering
    final key = '${shiftDate}_$shiftName';
    return cachedCardsByShift?[key] ?? [];
  }

  /// Format date for display (e.g., "Tue, 18 Jun 2025")
  String formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, ${date.day} $month ${date.year}';
  }

  /// Format time range (e.g., "09:00 – 13:00")
  String formatTimeRange(DateTime start, DateTime end) {
    final startStr =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endStr =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startStr – $endStr';
  }

  /// Parse shift end time string to DateTime
  /// Format: "2025-12-08 18:00" or "2025-12-08T18:00"
  DateTime? parseShiftEndTime(String? shiftEndTimeStr) {
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

  /// Find the last consecutive shift end time for a staff member on a given date
  /// Returns the end time of the last shift of the day for this staff member
  DateTime? findConsecutiveEndTime({
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
      final endTime = parseShiftEndTime(card.shiftEndTime);
      if (endTime != null) {
        shiftEndTimes.add(endTime);
      }
    }

    if (shiftEndTimes.isEmpty) return currentShiftEndTime;

    // Sort by time and return the latest
    shiftEndTimes.sort();
    return shiftEndTimes.last;
  }

  /// Extract stores from user data for the currently selected company
  List<dynamic> extractStores(
      Map<String, dynamic> userData, String selectedCompanyId) {
    if (userData.isEmpty || selectedCompanyId.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      // Find the company matching the selected company ID
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        final companyId = companyMap['company_id']?.toString() ?? '';
        if (companyId == selectedCompanyId) {
          final stores = companyMap['stores'] as List<dynamic>?;
          return stores ?? [];
        }
      }

      // Fallback: if no matching company found, return empty
      return [];
    } catch (e) {
      return [];
    }
  }
}
