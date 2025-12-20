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

  const CoverageGapKey({
    required this.storeId,
    required this.startDate,
    required this.endDate,
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
        other.endDate.day == endDate.day;
  }

  @override
  int get hashCode =>
      storeId.hashCode ^
      startDate.year.hashCode ^
      startDate.month.hashCode ^
      startDate.day.hashCode ^
      endDate.year.hashCode ^
      endDate.month.hashCode ^
      endDate.day.hashCode;

  @override
  String toString() =>
      'CoverageGapKey(storeId: $storeId, start: $startDate, end: $endDate)';
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

  // Now for filtering - only future dates
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

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

    // Get business hours for this day
    final dayHours = BusinessHours.getForDate(businessHours, normalizedDate);

    // If closed, no coverage needed
    if (dayHours == null || !dayHours.isOpen) {
      gapsByDate[normalizedDate] = DateCoverageInfo.closed(normalizedDate);
      currentDate = currentDate.add(const Duration(days: 1));
      continue;
    }

    // Get business hours time range
    final businessRange = dayHours.toTimeRange();
    if (businessRange == null) {
      gapsByDate[normalizedDate] = DateCoverageInfo.closed(normalizedDate);
      currentDate = currentDate.add(const Duration(days: 1));
      continue;
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

    if (gaps.isNotEmpty) {
      gapCount++;
      final gapSummary =
          gaps.map((g) => '${g.toTimeString()}-${g.toEndTimeString()}').join(', ');

      gapsByDate[normalizedDate] = DateCoverageInfo(
        date: normalizedDate,
        hasGap: true,
        gaps: gaps,
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
