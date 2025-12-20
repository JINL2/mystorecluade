import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../../../domain/entities/user_shift_stats.dart';
import '../../../providers/attendance_providers.dart';

/// Controller for AttendanceContent state and business logic
/// ✅ Clean Architecture: Uses Domain Entities instead of Map<String, dynamic>
class AttendanceContentController {
  final WidgetRef ref;

  // Cache for monthly stats data - key is "yyyy-MM" format
  final Map<String, UserShiftStats> _monthlyStatsCache = {};

  // Cache for monthly cards data - key is "yyyy-MM" format
  final Map<String, List<ShiftCard>> _monthlyCardsCache = {};

  // Track which months have been loaded
  final Set<String> _loadedMonths = {};

  // ALL shift cards accumulated across all loaded months
  List<ShiftCard> allShiftCards = [];

  // Current displayed month stats
  UserShiftStats? userShiftStats;

  String? currentDisplayedMonth;

  AttendanceContentController(this.ref);

  /// Get filtered cards for current view
  List<ShiftCard> get shiftCards => allShiftCards;

  /// Fetch month data with caching
  Future<Map<String, dynamic>> fetchMonthData(
    DateTime targetDate, {
    bool forceRefresh = false,
  }) async {
    final monthKey =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';

    // Check cache
    bool hasStats = _monthlyStatsCache.containsKey(monthKey);
    bool hasCards = _monthlyCardsCache.containsKey(monthKey);

    if (hasStats && hasCards && !forceRefresh) {
      // Return cached data
      userShiftStats = _monthlyStatsCache[monthKey];
      currentDisplayedMonth = monthKey;

      // Rebuild allShiftCards from cached data
      _rebuildAllShiftCards();

      return {
        'success': true,
        'fromCache': true,
        'shiftStatus': _calculateShiftStatus(monthKey),
      };
    }

    // Fetch fresh data
    try {
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      final appState = ref.read(appStateProvider);

      final getUserShiftCards = ref.read(getUserShiftCardsProvider);
      final getUserShiftStats = ref.read(getUserShiftStatsUseCaseProvider);

      final userId = user?.id;
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (userId == null || companyId.isEmpty || storeId.isEmpty) {
        return {
          'success': false,
          'error': 'Please select a company and store',
        };
      }

      // Calculate last day of month for RPC
      final lastDayOfMonth =
          DateTime(targetDate.year, targetDate.month + 1, 0, 23, 59, 59);
      final requestTime = DateTimeUtils.toLocalWithOffset(lastDayOfMonth);
      final timezone = DateTimeUtils.getLocalTimezone();

      // Parallel API calls
      final statsFuture = getUserShiftStats(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      final cardsFuture = getUserShiftCards(
        requestTime: requestTime,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

      final results = await Future.wait<dynamic>([
        statsFuture,
        cardsFuture,
      ]);

      final statsResult = results[0] as UserShiftStats;
      final cardsResult = results[1] as List<ShiftCard>;

      // Cache the data
      _monthlyStatsCache[monthKey] = statsResult;
      _monthlyCardsCache[monthKey] = cardsResult;
      _loadedMonths.add(monthKey);

      // Update current state
      userShiftStats = statsResult;
      currentDisplayedMonth = monthKey;

      // Rebuild all cards data
      _rebuildAllShiftCards();

      return {
        'success': true,
        'fromCache': false,
        'shiftStatus': _calculateShiftStatus(monthKey),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error loading data: ${e.toString()}',
      };
    }
  }

  /// Rebuild allShiftCards from all cached months
  void _rebuildAllShiftCards() {
    allShiftCards.clear();

    for (final cachedMonth in _monthlyCardsCache.keys) {
      final monthCards = _monthlyCardsCache[cachedMonth]!;
      allShiftCards.addAll(monthCards);
    }

    // Sort by date (descending)
    allShiftCards.sort((a, b) {
      return b.requestDate.compareTo(a.requestDate);
    });
  }

  /// Calculate shift status for current month
  String _calculateShiftStatus(String monthKey) {
    final now = DateTime.now();
    final currentMonthKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    if (monthKey != currentMonthKey) {
      return 'off_duty';
    }

    // Check today's shifts
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final todayShifts =
        allShiftCards.where((card) => card.requestDate == todayStr).toList();

    if (todayShifts.isEmpty) {
      return 'off_duty';
    }

    // Filter approved shifts
    final approvedShifts =
        todayShifts.where((shift) => shift.isApproved).toList();

    if (approvedShifts.isEmpty) {
      return 'scheduled';
    }

    // Check working status using Entity properties
    bool isCurrentlyWorking = approvedShifts.any(
      (shift) => shift.isCheckedIn && !shift.isCheckedOut,
    );

    bool allApprovedShiftsFinished = approvedShifts.every(
      (shift) => shift.isCheckedIn && shift.isCheckedOut,
    );

    bool anyApprovedShiftStarted = approvedShifts.any(
      (shift) => shift.isCheckedIn,
    );

    if (isCurrentlyWorking) {
      return 'working';
    } else if (allApprovedShiftsFinished && anyApprovedShiftStarted) {
      return 'finished';
    } else {
      return 'scheduled';
    }
  }

  /// Update local state after QR scan
  /// Note: This creates a temporary update until the next refresh
  void updateLocalStateAfterQRScan(Map<String, dynamic> scanResult) {
    final requestDate = scanResult['request_date'] as String? ?? '';
    final action = scanResult['action'] as String? ?? '';
    final timestamp =
        scanResult['timestamp'] as String? ?? DateTime.now().toIso8601String();
    final shiftRequestId = scanResult['shift_request_id'] as String? ?? '';

    // Find existing card
    final existingIndex = allShiftCards.indexWhere(
      (card) =>
          card.requestDate == requestDate &&
          card.shiftRequestId == shiftRequestId,
    );

    if (existingIndex != -1) {
      final existingCard = allShiftCards[existingIndex];

      // Create updated card with new times
      ShiftCard updatedCard;
      if (action == 'check_in') {
        updatedCard = existingCard.copyWith(
          actualStartTime: timestamp,
          confirmStartTime: timestamp,
        );
      } else if (action == 'check_out') {
        updatedCard = existingCard.copyWith(
          actualEndTime: timestamp,
          confirmEndTime: timestamp,
        );
      } else {
        return;
      }

      allShiftCards[existingIndex] = updatedCard;
    }
    // Note: If card doesn't exist, we don't create a new one
    // The next refresh will fetch the updated data from server
  }

  /// Clear all caches
  void clearCaches() {
    allShiftCards.clear();
    _monthlyStatsCache.clear();
    _monthlyCardsCache.clear();
    _loadedMonths.clear();
    userShiftStats = null;
    currentDisplayedMonth = null;
  }

  /// Get week schedule for center date
  List<WeekDaySchedule> getWeekSchedule(DateTime centerDate) {
    List<WeekDaySchedule> schedule = [];

    for (int i = -3; i <= 3; i++) {
      final date = centerDate.add(Duration(days: i));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final shiftsForDate = allShiftCards.where(
        (card) => card.requestDate == dateStr,
      ).toList();

      if (shiftsForDate.isNotEmpty) {
        final hasApprovedShift = shiftsForDate.any((card) => card.isApproved);
        final hasNonApprovedShift =
            shiftsForDate.any((card) => !card.isApproved);

        schedule.add(WeekDaySchedule(
          date: date,
          hasShift: true,
          shiftCount: shiftsForDate.length,
          hasApprovedShift: hasApprovedShift,
          hasNonApprovedShift: hasNonApprovedShift,
          shifts: shiftsForDate,
        ));
      } else {
        schedule.add(WeekDaySchedule(
          date: date,
          hasShift: false,
          shiftCount: 0,
          hasApprovedShift: false,
          hasNonApprovedShift: false,
          shifts: const [],
        ));
      }
    }

    return schedule;
  }
}

/// Week day schedule data class
class WeekDaySchedule {
  final DateTime date;
  final bool hasShift;
  final int shiftCount;
  final bool hasApprovedShift;
  final bool hasNonApprovedShift;
  final List<ShiftCard> shifts;

  const WeekDaySchedule({
    required this.date,
    required this.hasShift,
    required this.shiftCount,
    required this.hasApprovedShift,
    required this.hasNonApprovedShift,
    required this.shifts,
  });
}
