import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../store_shift/domain/entities/business_hours.dart';
import '../../../../store_shift/presentation/providers/store_shift_providers.dart';
import '../../../domain/entities/daily_shift_data.dart';
import 'monthly_shift_status_provider.dart';

/// Key for coverage gap provider (storeId + date range)
class CoverageGapKey {
  final String storeId;
  final DateTime startDate;
  final DateTime endDate;
  /// If true, for TODAY only check gaps AFTER current time
  final bool filterByCurrentTime;

  const CoverageGapKey({
    required this.storeId,
    required this.startDate,
    required this.endDate,
    this.filterByCurrentTime = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoverageGapKey &&
        other.storeId == storeId &&
        other.startDate.year == startDate.year &&
        other.startDate.month == startDate.month &&
        other.startDate.day == startDate.day &&
        other.endDate.year == endDate.year &&
        other.endDate.month == endDate.month &&
        other.endDate.day == endDate.day &&
        other.filterByCurrentTime == filterByCurrentTime;
  }

  @override
  int get hashCode =>
      storeId.hashCode ^
      startDate.year.hashCode ^
      startDate.month.hashCode ^
      startDate.day.hashCode ^
      endDate.year.hashCode ^
      endDate.month.hashCode ^
      endDate.day.hashCode ^
      filterByCurrentTime.hashCode;

  @override
  String toString() =>
      'CoverageGapKey(storeId: $storeId, start: $startDate, end: $endDate, filterByTime: $filterByCurrentTime)';
}

/// Coverage gap data for a specific date
class DateCoverageInfo {
  final DateTime date;
  final bool hasGap;
  final List<TimeRange> gaps;
  final String gapSummary;

  const DateCoverageInfo({
    required this.date,
    required this.hasGap,
    required this.gaps,
    required this.gapSummary,
  });

  factory DateCoverageInfo.noGap(DateTime date) {
    return DateCoverageInfo(
      date: date,
      hasGap: false,
      gaps: const [],
      gapSummary: 'Fully covered',
    );
  }

  factory DateCoverageInfo.closed(DateTime date) {
    return DateCoverageInfo(
      date: date,
      hasGap: false,
      gaps: const [],
      gapSummary: 'Closed',
    );
  }
}

/// Coverage gap state containing gap info for multiple dates
class CoverageGapState {
  final Map<DateTime, DateCoverageInfo> gapsByDate;
  final int totalGapCount;
  final bool isLoading;
  final String? error;

  const CoverageGapState({
    required this.gapsByDate,
    required this.totalGapCount,
    this.isLoading = false,
    this.error,
  });

  factory CoverageGapState.initial() {
    return const CoverageGapState(
      gapsByDate: {},
      totalGapCount: 0,
      isLoading: true,
    );
  }

  factory CoverageGapState.loading() {
    return const CoverageGapState(
      gapsByDate: {},
      totalGapCount: 0,
      isLoading: true,
    );
  }

  /// Get dates with coverage gaps (for Need Attention)
  List<DateTime> get datesWithGaps {
    return gapsByDate.entries
        .where((e) => e.value.hasGap)
        .map((e) => e.key)
        .toList()
      ..sort();
  }

  /// Check if a specific date has coverage gap
  bool hasGapOnDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return gapsByDate[normalized]?.hasGap ?? false;
  }

  /// Get gap info for a specific date
  DateCoverageInfo? getGapInfo(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return gapsByDate[normalized];
  }

  CoverageGapState copyWith({
    Map<DateTime, DateCoverageInfo>? gapsByDate,
    int? totalGapCount,
    bool? isLoading,
    String? error,
  }) {
    return CoverageGapState(
      gapsByDate: gapsByDate ?? this.gapsByDate,
      totalGapCount: totalGapCount ?? this.totalGapCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider to calculate coverage gaps for a date range
///
/// Uses:
/// - Business hours from store_shift feature
/// - Approved shift data from monthly_shift_status
///
/// Logic:
/// 1. For each date in range (only future dates)
/// 2. Get business hours for that day of week
/// 3. Get approved shifts with employees for that date
/// 4. Calculate if shift coverage matches business hours
/// 5. Return dates with gaps
final coverageGapProvider = FutureProvider.autoDispose
    .family<CoverageGapState, CoverageGapKey>((ref, key) async {
  // Watch business hours
  final businessHoursAsync = ref.watch(businessHoursProvider);

  // Watch monthly shift status for approved shifts
  final monthlyStatusState =
      ref.watch(monthlyShiftStatusProvider(key.storeId));

  // If still loading, return loading state
  if (!businessHoursAsync.hasValue) {
    return CoverageGapState.loading();
  }

  final businessHours = businessHoursAsync.value ?? BusinessHours.defaultHours();

  // Get all daily shift data
  final allDailyShifts = monthlyStatusState.allMonthlyStatuses
      .expand((status) => status.dailyShifts)
      .toList();

  // Build a map of date -> daily shift data
  final dailyShiftMap = <String, DailyShiftData>{};
  for (final daily in allDailyShifts) {
    dailyShiftMap[daily.date] = daily;
  }

  // Now for filtering - only future dates (with current time filtering for TODAY)
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final currentTimeMinutes = now.hour * 60 + now.minute;

  final gapsByDate = <DateTime, DateCoverageInfo>{};
  int gapCount = 0;

  // Iterate through the date range
  var currentDate = key.startDate;
  while (!currentDate.isAfter(key.endDate)) {
    final normalizedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Skip past dates
    if (normalizedDate.isBefore(today)) {
      currentDate = currentDate.add(const Duration(days: 1));
      continue;
    }

    final isToday = normalizedDate.isAtSameMomentAs(today);

    // Get business hours for this day
    final dayHours = BusinessHours.getForDate(businessHours, normalizedDate);

    // If closed, no coverage needed
    if (dayHours == null || !dayHours.isOpen) {
      gapsByDate[normalizedDate] = DateCoverageInfo.closed(normalizedDate);
      currentDate = currentDate.add(const Duration(days: 1));
      continue;
    }

    // Get business hours time range
    var businessRange = dayHours.toTimeRange();
    if (businessRange == null) {
      gapsByDate[normalizedDate] = DateCoverageInfo.closed(normalizedDate);
      currentDate = currentDate.add(const Duration(days: 1));
      continue;
    }

    // OPTIMIZATION: For TODAY with filterByCurrentTime enabled, only check gaps AFTER current time
    // Example: If it's 14:00 and business hours are 10:00-22:00, only check 14:00-22:00
    if (isToday && key.filterByCurrentTime && currentTimeMinutes > businessRange.startMinutes) {
      // Adjust business range to start from current time
      if (currentTimeMinutes >= businessRange.endMinutes) {
        // Past close time - no gaps to report for today
        gapsByDate[normalizedDate] = DateCoverageInfo.noGap(normalizedDate);
        currentDate = currentDate.add(const Duration(days: 1));
        continue;
      }
      businessRange = TimeRange(currentTimeMinutes, businessRange.endMinutes);
    }

    // Get daily shift data for this date
    final dateStr = DateFormat('yyyy-MM-dd').format(normalizedDate);
    final dailyData = dailyShiftMap[dateStr];

    // Build coverage ranges from APPROVED shifts only
    final coverageRanges = <TimeRange>[];

    if (dailyData != null) {
      for (final shiftWithReqs in dailyData.shifts) {
        // Only count shifts that have at least 1 approved employee
        if (shiftWithReqs.approvedRequests.isNotEmpty) {
          // Get shift time range
          final shift = shiftWithReqs.shift;
          final startTime = _extractTimeString(shift.planStartTime);
          final endTime = _extractTimeString(shift.planEndTime);

          if (startTime != null && endTime != null) {
            coverageRanges.add(TimeRange.fromTimeStrings(startTime, endTime));
          }
        }
      }
    }

    // Calculate gaps
    final gaps = TimeRange.findGaps(businessRange, coverageRanges);

    // For TODAY: filter out gaps that are before current time
    final relevantGaps = isToday && key.filterByCurrentTime
        ? gaps.where((gap) => gap.endMinutes > currentTimeMinutes).toList()
        : gaps;

    if (relevantGaps.isNotEmpty) {
      gapCount++;
      final gapSummary =
          relevantGaps.map((g) => '${g.toTimeString()}-${g.toEndTimeString()}').join(', ');

      gapsByDate[normalizedDate] = DateCoverageInfo(
        date: normalizedDate,
        hasGap: true,
        gaps: relevantGaps,
        gapSummary: gapSummary,
      );
    } else {
      gapsByDate[normalizedDate] = DateCoverageInfo.noGap(normalizedDate);
    }

    currentDate = currentDate.add(const Duration(days: 1));
  }

  return CoverageGapState(
    gapsByDate: gapsByDate,
    totalGapCount: gapCount,
    isLoading: false,
  );
});

/// Extract HH:mm time string from DateTime
String? _extractTimeString(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

/// Simple provider to get coverage gap count for Need Attention badge
///
/// Shows count of upcoming dates (next 14 days) with coverage gaps
final coverageGapCountProvider = Provider.autoDispose.family<int, String>((ref, storeId) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final twoWeeksLater = today.add(const Duration(days: 14));

  final key = CoverageGapKey(
    storeId: storeId,
    startDate: today,
    endDate: twoWeeksLater,
  );

  final gapState = ref.watch(coverageGapProvider(key));

  return gapState.when(
    data: (state) => state.totalGapCount,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Key for week-based coverage gap provider (used by Schedule tab calendar)
class WeekCoverageGapKey {
  final String storeId;
  final DateTime weekStart;

  const WeekCoverageGapKey({
    required this.storeId,
    required this.weekStart,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeekCoverageGapKey &&
        other.storeId == storeId &&
        other.weekStart.year == weekStart.year &&
        other.weekStart.month == weekStart.month &&
        other.weekStart.day == weekStart.day;
  }

  @override
  int get hashCode =>
      storeId.hashCode ^
      weekStart.year.hashCode ^
      weekStart.month.hashCode ^
      weekStart.day.hashCode;
}

/// Provider for Schedule tab calendar - returns map of date -> has coverage gap
///
/// Uses centralized coverageGapProvider for consistent calculation
/// across Overview and Schedule tabs.
///
/// Returns Map<DateTime, bool> where:
/// - true = coverage gap exists (show red dot)
/// - false = no gap (no dot)
final weekCoverageGapMapProvider = Provider.autoDispose
    .family<Map<DateTime, bool>, WeekCoverageGapKey>((ref, key) {
  final weekEnd = key.weekStart.add(const Duration(days: 6));

  final gapKey = CoverageGapKey(
    storeId: key.storeId,
    startDate: key.weekStart,
    endDate: weekEnd,
    filterByCurrentTime: true,
  );

  final gapState = ref.watch(coverageGapProvider(gapKey));

  return gapState.when(
    data: (state) {
      final result = <DateTime, bool>{};
      state.gapsByDate.forEach((date, info) {
        result[date] = info.hasGap;
      });
      return result;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Key for month-based coverage gap provider (used for full month view)
class MonthCoverageGapKey {
  final String storeId;
  final int year;
  final int month;

  const MonthCoverageGapKey({
    required this.storeId,
    required this.year,
    required this.month,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthCoverageGapKey &&
        other.storeId == storeId &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode => storeId.hashCode ^ year.hashCode ^ month.hashCode;
}

/// Provider for full month coverage gaps - used by Overview timeline
///
/// Returns coverage gap data for entire month with current time filtering
final monthCoverageGapProvider = Provider.autoDispose
    .family<CoverageGapState, MonthCoverageGapKey>((ref, key) {
  // Calculate month start and end
  final monthStart = DateTime(key.year, key.month, 1);
  final monthEnd = DateTime(key.year, key.month + 1, 0); // Last day of month

  final gapKey = CoverageGapKey(
    storeId: key.storeId,
    startDate: monthStart,
    endDate: monthEnd,
    filterByCurrentTime: true,
  );

  final gapState = ref.watch(coverageGapProvider(gapKey));

  return gapState.when(
    data: (state) => state,
    loading: () => CoverageGapState.loading(),
    error: (_, __) => const CoverageGapState(
      gapsByDate: {},
      totalGapCount: 0,
      isLoading: false,
      error: 'Failed to load coverage gaps',
    ),
  );
});
