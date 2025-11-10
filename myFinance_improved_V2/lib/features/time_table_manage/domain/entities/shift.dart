import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/datetime_utils.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

/// Parse start time string - handles both full ISO8601 and "HH:mm" format
/// Throws FormatException if parsing fails - NO SILENT FALLBACKS
DateTime? _parseStartTime(dynamic json) {
  if (json == null) return null;
  if (json is DateTime) return json;

  // Extract shift_date from the current JSON context if available
  // Note: In Freezed, we can't access other fields during deserialization,
  // so we'll extract shift_date from the raw JSON if needed
  final String timeStr = json as String;

  // If full ISO8601 timestamp, parse directly
  if (timeStr.contains('T') || timeStr.contains('Z') || (timeStr.contains(' ') && timeStr.length > 10)) {
    try {
      return DateTimeUtils.toLocal(timeStr);
    } catch (e) {
      throw FormatException('Failed to parse ISO8601 time string "$timeStr": $e');
    }
  }

  // For HH:mm format, we need the shift_date which isn't available here
  // So we'll parse as a time-only and let the caller provide the date context
  throw FormatException(
    'Cannot parse time-only string "$timeStr" without date context. '
    'Use full ISO8601 format or parse manually with shift_date.',
  );
}

/// Parse end time string
DateTime? _parseEndTime(dynamic json) {
  return _parseStartTime(json); // Same logic
}

/// Serialize DateTime to UTC string
String? _serializeTime(DateTime? dateTime) {
  if (dateTime == null) return null;
  return DateTimeUtils.toUtc(dateTime);
}

/// Shift Entity
///
/// Represents a work shift with scheduling details and capacity information.
@freezed
class Shift with _$Shift {
  const Shift._();

  const factory Shift({
    @JsonKey(name: 'shift_id', defaultValue: '') required String shiftId,
    @JsonKey(name: 'store_id', defaultValue: '') required String storeId,
    @JsonKey(name: 'shift_date', defaultValue: '') required String shiftDate,
    @JsonKey(name: 'plan_start_time', fromJson: _parseStartTime, toJson: _serializeTime)
        DateTime? planStartTime,
    @JsonKey(name: 'plan_end_time', fromJson: _parseEndTime, toJson: _serializeTime)
        DateTime? planEndTime,
    @JsonKey(name: 'target_count', defaultValue: 0) required int targetCount,
    @JsonKey(name: 'current_count', defaultValue: 0) required int currentCount,
    @JsonKey(defaultValue: <String>[]) required List<String> tags,
    @JsonKey(name: 'shift_name') String? shiftName,
  }) = _Shift;

  /// Create from JSON
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  /// Check if shift is fully staffed
  bool get isFullyStaffed => currentCount >= targetCount;

  /// Check if shift is under-staffed
  bool get isUnderStaffed => currentCount < targetCount;

  /// Get remaining slots available
  int get remainingSlots => targetCount - currentCount;

  /// Check if shift has no approved employees
  bool get hasNoApproved => currentCount == 0;

  /// Get shift duration in hours
  double get durationInHours {
    if (planStartTime == null || planEndTime == null) return 0.0;
    final duration = planEndTime!.difference(planStartTime!);
    return duration.inMinutes / 60.0;
  }

  /// Parse time string with date context - handles "HH:mm" format
  /// Use this when you have both time string and date string
  static DateTime parseTimeWithDate(String timeStr, String dateStr) {
    // Handle empty or "null" string - FAIL LOUDLY
    if (timeStr.isEmpty || timeStr == 'null') {
      throw FormatException(
        'Invalid time string: "$timeStr". Cannot parse empty or null time.',
      );
    }

    // If it's a full ISO8601 or timestamp string, use DateTimeUtils
    if (timeStr.contains('T') ||
        (timeStr.contains(' ') && timeStr.length > 10) ||
        timeStr.contains('Z')) {
      try {
        return DateTimeUtils.toLocal(timeStr);
      } catch (e) {
        throw FormatException(
          'Failed to parse ISO8601 time string "$timeStr": $e',
        );
      }
    }

    // If it's just "HH:mm" format, combine with shift date
    // NOTE: RPC returns shift_time in UTC (e.g., "10:00-14:00" is 10:00 UTC)
    final timeParts = timeStr.split(':');
    if (timeParts.length != 2) {
      throw FormatException(
        'Invalid time format "$timeStr". Expected "HH:mm" or ISO8601.',
      );
    }

    try {
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Validate hour and minute ranges
      if (hour < 0 || hour > 23) {
        throw FormatException('Invalid hour: $hour. Must be 0-23.');
      }
      if (minute < 0 || minute > 59) {
        throw FormatException('Invalid minute: $minute. Must be 0-59.');
      }

      // Parse shift date (yyyy-MM-dd)
      if (dateStr.isEmpty || dateStr == 'null' || dateStr.length < 10) {
        throw FormatException(
          'Invalid date string "$dateStr". Cannot parse time without valid date.',
        );
      }

      final dateParts = dateStr.substring(0, 10).split('-');
      if (dateParts.length != 3) {
        throw FormatException(
            'Invalid date format "$dateStr". Expected "yyyy-MM-dd".');
      }

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Validate date components
      if (year < 1900 || year > 2100) {
        throw FormatException('Invalid year: $year. Must be 1900-2100.');
      }
      if (month < 1 || month > 12) {
        throw FormatException('Invalid month: $month. Must be 1-12.');
      }
      if (day < 1 || day > 31) {
        throw FormatException('Invalid day: $day. Must be 1-31.');
      }

      // Create as UTC because RPC returns UTC time
      final baseDate = DateTime.utc(year, month, day, hour, minute);

      // Convert to local time for display
      return baseDate.toLocal();
    } catch (e) {
      if (e is FormatException) rethrow;
      throw FormatException(
        'Failed to parse time "$timeStr" with date "$dateStr": $e',
      );
    }
  }

  /// Custom fromJson that handles time-only formats
  factory Shift.fromJsonWithTimeContext(Map<String, dynamic> json) {
    final shiftDate = json['shift_date'] as String? ?? '';
    final planStartTimeStr = json['plan_start_time'] as String? ?? '';
    final planEndTimeStr = json['plan_end_time'] as String? ?? '';

    return Shift(
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      shiftDate: shiftDate,
      planStartTime: parseTimeWithDate(planStartTimeStr, shiftDate),
      planEndTime: parseTimeWithDate(planEndTimeStr, shiftDate),
      targetCount: json['target_count'] as int? ?? 0,
      currentCount: json['current_count'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      shiftName: json['shift_name'] as String?,
    );
  }
}
