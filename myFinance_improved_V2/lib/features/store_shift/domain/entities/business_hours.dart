/// Time range helper class for coverage calculations
class TimeRange {
  final int startMinutes; // Minutes from midnight (0-1439)
  final int endMinutes; // Minutes from midnight (can exceed 1440 for overnight)

  const TimeRange(this.startMinutes, this.endMinutes);

  /// Create from HH:mm string
  factory TimeRange.fromTimeStrings(String start, String end) {
    final startMins = _parseTimeToMinutes(start);
    var endMins = _parseTimeToMinutes(end);

    // Handle overnight shifts (e.g., 22:00-02:00)
    if (endMins <= startMins) {
      endMins += 1440; // Add 24 hours
    }

    return TimeRange(startMins, endMins);
  }

  /// Create from HH:mm string with explicit overnight flag
  factory TimeRange.fromTimeStringsWithOvernight(String start, String end, bool closesNextDay) {
    final startMins = _parseTimeToMinutes(start);
    var endMins = _parseTimeToMinutes(end);

    // Use closesNextDay flag if provided, otherwise auto-detect
    if (closesNextDay || endMins <= startMins) {
      endMins += 1440; // Add 24 hours
    }

    return TimeRange(startMins, endMins);
  }

  static int _parseTimeToMinutes(String time) {
    // Handle formats like "10:00:00+07" or "10:00"
    final cleanTime = time.split('+')[0].split('-')[0]; // Remove timezone
    final parts = cleanTime.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// Check if this range overlaps with another
  bool overlaps(TimeRange other) {
    return startMinutes < other.endMinutes && endMinutes > other.startMinutes;
  }

  /// Check if this range fully contains a point in time
  bool contains(int minutes) {
    return minutes >= startMinutes && minutes < endMinutes;
  }

  /// Get the duration in minutes
  int get duration => endMinutes - startMinutes;

  /// Merge overlapping ranges and return sorted list
  ///
  /// Example: [(10:00-14:00), (12:00-18:00)] → [(10:00-18:00)]
  static List<TimeRange> mergeRanges(List<TimeRange> ranges) {
    if (ranges.isEmpty) return [];

    // Sort by start time
    final sorted = List<TimeRange>.from(ranges)
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    final merged = <TimeRange>[sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final last = merged.last;

      // Check if current overlaps or is adjacent to last
      if (current.startMinutes <= last.endMinutes) {
        // Merge by extending the end time
        merged[merged.length - 1] = TimeRange(
          last.startMinutes,
          current.endMinutes > last.endMinutes ? current.endMinutes : last.endMinutes,
        );
      } else {
        // No overlap - add as new range
        merged.add(current);
      }
    }

    return merged;
  }

  /// Find gaps between merged coverage and required range
  ///
  /// Example:
  /// - businessHours: 10:00-02:00 (next day) = 600-1560
  /// - coverage: [(10:00-14:00), (14:00-20:00)] = [(600-840), (840-1200)]
  /// - gaps: [(20:00-02:00)] = [(1200-1560)]
  static List<TimeRange> findGaps(TimeRange required, List<TimeRange> coverage) {
    if (coverage.isEmpty) {
      return [required];
    }

    final merged = mergeRanges(coverage);
    final gaps = <TimeRange>[];

    int currentStart = required.startMinutes;

    for (final range in merged) {
      // Skip ranges that don't overlap with required
      if (range.endMinutes <= required.startMinutes) continue;
      if (range.startMinutes >= required.endMinutes) break;

      // Clamp to required range
      final effectiveStart = range.startMinutes < required.startMinutes
          ? required.startMinutes
          : range.startMinutes;
      final effectiveEnd = range.endMinutes > required.endMinutes
          ? required.endMinutes
          : range.endMinutes;

      // Gap exists from currentStart to effectiveStart
      if (effectiveStart > currentStart) {
        gaps.add(TimeRange(currentStart, effectiveStart));
      }

      // Move currentStart past this coverage
      currentStart = effectiveEnd;
    }

    // Final gap if coverage doesn't reach required end
    if (currentStart < required.endMinutes) {
      gaps.add(TimeRange(currentStart, required.endMinutes));
    }

    return gaps;
  }

  /// Format as HH:mm string
  String toTimeString() {
    final hours = (startMinutes ~/ 60) % 24;
    final mins = startMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  /// Format end time as HH:mm string
  String toEndTimeString() {
    final hours = (endMinutes ~/ 60) % 24;
    final mins = endMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  @override
  String toString() => 'TimeRange($startMinutes-$endMinutes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeRange &&
        other.startMinutes == startMinutes &&
        other.endMinutes == endMinutes;
  }

  @override
  int get hashCode => startMinutes.hashCode ^ endMinutes.hashCode;
}

/// Coverage Gap information for a specific date
class CoverageGap {
  final DateTime date;
  final TimeRange businessHours;
  final List<TimeRange> coveredRanges;
  final List<TimeRange> gaps;

  const CoverageGap({
    required this.date,
    required this.businessHours,
    required this.coveredRanges,
    required this.gaps,
  });

  /// Whether there are any uncovered time slots
  bool get hasGaps => gaps.isNotEmpty;

  /// Total gap duration in minutes
  int get totalGapMinutes => gaps.fold(0, (sum, gap) => sum + gap.duration);

  /// Format gap summary (e.g., "20:00-02:00 uncovered")
  String get gapSummary {
    if (gaps.isEmpty) return 'Fully covered';
    return gaps.map((g) => '${g.toTimeString()}-${g.toEndTimeString()}').join(', ');
  }

  @override
  String toString() => 'CoverageGap(date: $date, gaps: $gaps)';
}

/// Business Hours Entity
///
/// Represents operating hours for a specific day of the week.
/// Maps to store_business_hours table in database.
class BusinessHours {
  final int dayOfWeek; // 0=Sunday, 1=Monday, ..., 6=Saturday
  final String dayName; // "Sunday", "Monday", etc.
  final bool isOpen;
  final String? openTime; // HH:mm format (e.g., "09:00")
  final String? closeTime; // HH:mm format (e.g., "22:00")
  final bool closesNextDay; // True if close_time is on the next day (overnight)

  const BusinessHours({
    required this.dayOfWeek,
    required this.dayName,
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.closesNextDay = false,
  });

  /// Day name to day of week mapping
  static const Map<String, int> dayNameToNumber = {
    'Sunday': 0,
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
  };

  /// Day of week to name mapping
  static const Map<int, String> dayNumberToName = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
  };

  /// Create a copy with optional field updates
  BusinessHours copyWith({
    int? dayOfWeek,
    String? dayName,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    bool? closesNextDay,
  }) {
    return BusinessHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayName: dayName ?? this.dayName,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      closesNextDay: closesNextDay ?? this.closesNextDay,
    );
  }

  /// Default business hours for all 7 days
  static List<BusinessHours> defaultHours() {
    return [
      const BusinessHours(dayOfWeek: 0, dayName: 'Sunday', isOpen: true, openTime: '10:00', closeTime: '21:00'),
      const BusinessHours(dayOfWeek: 1, dayName: 'Monday', isOpen: true, openTime: '09:00', closeTime: '22:00'),
      const BusinessHours(dayOfWeek: 2, dayName: 'Tuesday', isOpen: true, openTime: '09:00', closeTime: '22:00'),
      const BusinessHours(dayOfWeek: 3, dayName: 'Wednesday', isOpen: true, openTime: '09:00', closeTime: '22:00'),
      const BusinessHours(dayOfWeek: 4, dayName: 'Thursday', isOpen: true, openTime: '09:00', closeTime: '22:00'),
      const BusinessHours(dayOfWeek: 5, dayName: 'Friday', isOpen: true, openTime: '09:00', closeTime: '23:00'),
      const BusinessHours(dayOfWeek: 6, dayName: 'Saturday', isOpen: true, openTime: '10:00', closeTime: '23:00'),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BusinessHours &&
        other.dayOfWeek == dayOfWeek &&
        other.dayName == dayName &&
        other.isOpen == isOpen &&
        other.openTime == openTime &&
        other.closeTime == closeTime &&
        other.closesNextDay == closesNextDay;
  }

  @override
  int get hashCode {
    return dayOfWeek.hashCode ^
        dayName.hashCode ^
        isOpen.hashCode ^
        openTime.hashCode ^
        closeTime.hashCode ^
        closesNextDay.hashCode;
  }

  @override
  String toString() {
    return 'BusinessHours(dayOfWeek: $dayOfWeek, dayName: $dayName, isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime, closesNextDay: $closesNextDay)';
  }

  /// Convert business hours to TimeRange for calculations
  ///
  /// Returns null if store is closed or times are not set
  TimeRange? toTimeRange() {
    if (!isOpen || openTime == null || closeTime == null) {
      return null;
    }
    return TimeRange.fromTimeStringsWithOvernight(openTime!, closeTime!, closesNextDay);
  }

  /// Get BusinessHours for a specific date from a list
  ///
  /// Uses the day of week from the provided date to find matching hours
  static BusinessHours? getForDate(List<BusinessHours> hours, DateTime date) {
    // DateTime.weekday: Monday=1, Sunday=7
    // BusinessHours.dayOfWeek: Sunday=0, Monday=1, ..., Saturday=6
    final dayOfWeek = date.weekday == 7 ? 0 : date.weekday;
    return hours.where((h) => h.dayOfWeek == dayOfWeek).firstOrNull;
  }

  /// Calculate coverage gaps for a specific date
  ///
  /// Compares business hours against a list of approved shift time ranges
  /// to find uncovered time slots.
  ///
  /// [shiftRanges]: List of TimeRange from approved shifts (already merged if needed)
  ///
  /// Returns CoverageGap with gap information, or null if store is closed
  static CoverageGap? calculateCoverageGap({
    required DateTime date,
    required List<BusinessHours> businessHours,
    required List<TimeRange> shiftRanges,
  }) {
    final dayHours = getForDate(businessHours, date);

    // If no business hours or closed, no coverage needed
    if (dayHours == null || !dayHours.isOpen) {
      return null;
    }

    final businessRange = dayHours.toTimeRange();
    if (businessRange == null) {
      return null;
    }

    // Find gaps
    final gaps = TimeRange.findGaps(businessRange, shiftRanges);

    return CoverageGap(
      date: date,
      businessHours: businessRange,
      coveredRanges: shiftRanges,
      gaps: gaps,
    );
  }
}
