import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/shift.dart';

/// Shift Model (DTO + Mapper)
///
/// Data Transfer Object for Shift entity with JSON serialization.
class ShiftModel {
  final String shiftId;
  final String storeId;
  final String shiftDate;
  final String planStartTime;
  final String planEndTime;
  final int targetCount;
  final int currentCount;
  final List<String> tags;
  final String? shiftName;

  const ShiftModel({
    required this.shiftId,
    required this.storeId,
    required this.shiftDate,
    required this.planStartTime,
    required this.planEndTime,
    required this.targetCount,
    required this.currentCount,
    this.tags = const [],
    this.shiftName,
  });

  /// Create from JSON
  factory ShiftModel.fromJson(Map<String, dynamic> json) {

    return ShiftModel(
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      shiftDate: json['shift_date'] as String? ?? '',
      planStartTime: json['plan_start_time'] as String? ?? '',
      planEndTime: json['plan_end_time'] as String? ?? '',
      targetCount: json['target_count'] as int? ?? 0,
      currentCount: json['current_count'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      shiftName: json['shift_name'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_id': shiftId,
      'store_id': storeId,
      'shift_date': shiftDate,
      'plan_start_time': planStartTime,
      'plan_end_time': planEndTime,
      'target_count': targetCount,
      'current_count': currentCount,
      'tags': tags,
      if (shiftName != null) 'shift_name': shiftName,
    };
  }

  /// Map to Domain Entity
  Shift toEntity() {
    // Handle empty strings for time fields
    DateTime parsedStartTime;
    DateTime parsedEndTime;

    try {
      parsedStartTime = planStartTime.isNotEmpty
          ? _parseTimeString(planStartTime, shiftDate)
          : DateTime.now(); // Fallback to current time
    } catch (e) {
      parsedStartTime = DateTime.now();
    }

    try {
      parsedEndTime = planEndTime.isNotEmpty
          ? _parseTimeString(planEndTime, shiftDate)
          : DateTime.now(); // Fallback to current time
    } catch (e) {
      parsedEndTime = DateTime.now();
    }

    return Shift(
      shiftId: shiftId,
      storeId: storeId,
      shiftDate: shiftDate,
      planStartTime: parsedStartTime,
      planEndTime: parsedEndTime,
      targetCount: targetCount,
      currentCount: currentCount,
      tags: tags,
      shiftName: shiftName,
    );
  }

  /// Parse time string - handles both full ISO8601 and "HH:mm" format
  static DateTime _parseTimeString(String timeStr, String dateStr) {
    // Handle empty or "null" string
    if (timeStr.isEmpty || timeStr == 'null') {
      return DateTime.now();
    }

    // If it's a full ISO8601 or timestamp string, use DateTimeUtils
    if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10) || timeStr.contains('Z')) {
      return DateTimeUtils.toLocal(timeStr);
    }

    // If it's just "HH:mm" format, combine with shift date
    // NOTE: RPC returns shift_time in UTC (e.g., "10:00-14:00" is 10:00 UTC)
    // We create as UTC then convert to local time for display
    final timeParts = timeStr.split(':');
    if (timeParts.length == 2) {
      try {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        // Parse shift date (yyyy-MM-dd)
        DateTime baseDate;
        if (dateStr.isNotEmpty && dateStr != 'null' && dateStr.length >= 10) {
          final dateParts = dateStr.substring(0, 10).split('-');
          // Create as UTC because RPC returns UTC time
          baseDate = DateTime.utc(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            hour,
            minute,
          );
        } else {
          // If no valid date, use today in UTC
          final now = DateTime.now().toUtc();
          baseDate = DateTime.utc(now.year, now.month, now.day, hour, minute);
        }

        // Convert to local time for display
        return baseDate.toLocal();
      } catch (e) {
        return DateTime.now();
      }
    }

    // Fallback
    return DateTime.now();
  }

  /// Create from Domain Entity
  factory ShiftModel.fromEntity(Shift entity) {
    return ShiftModel(
      shiftId: entity.shiftId,
      storeId: entity.storeId,
      shiftDate: entity.shiftDate,
      planStartTime: DateTimeUtils.toUtc(entity.planStartTime),
      planEndTime: DateTimeUtils.toUtc(entity.planEndTime),
      targetCount: entity.targetCount,
      currentCount: entity.currentCount,
      tags: entity.tags,
      shiftName: entity.shiftName,
    );
  }
}
