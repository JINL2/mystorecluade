import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/store_shift.dart';

/// Store Shift Model (DTO + Mapper)
///
/// This model handles:
/// 1. Data Transfer Object (DTO) - serialization/deserialization
/// 2. Mapper - conversion between Model and Entity
class StoreShiftModel extends StoreShift {
  const StoreShiftModel({
    required super.shiftId,
    required super.shiftName,
    required super.startTime,
    required super.endTime,
    required super.shiftBonus,
    required super.isActive,
    super.numberShift = 1,
    super.isCanOvertime = false,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON (from Supabase response)
  ///
  /// **중요:** RPC 'get_shift_metadata_v2_utc'의 반환값을 파싱합니다.
  /// 반환 필드: shift_id, store_id, shift_name, start_time_utc, end_time_utc,
  ///           number_shift, is_active, is_can_overtime
  factory StoreShiftModel.fromJson(Map<String, dynamic> json) {
    // Support both old (start_time) and new (start_time_utc) column names
    final startTimeValue = json['start_time_utc'] ?? json['start_time'];
    final endTimeValue = json['end_time_utc'] ?? json['end_time'];

    // Support both old (created_at) and new (created_at_utc) column names
    // RPC may not return these fields, so fallback to current time
    final createdAtValue = json['created_at'] as String?;
    final updatedAtValue = json['updated_at'] as String?;

    return StoreShiftModel(
      shiftId: json['shift_id'] as String,
      shiftName: json['shift_name'] as String,
      // Parse timetz format (e.g., "14:00:00+07")
      startTime: _parseTimetzString(startTimeValue as String? ?? '00:00:00'),
      endTime: _parseTimetzString(endTimeValue as String? ?? '00:00:00'),
      // RPC may not return shift_bonus, default to 0
      shiftBonus: (json['shift_bonus'] as int?) ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      // RPC returns number_shift and is_can_overtime
      numberShift: (json['number_shift'] as int?) ?? 1,
      isCanOvertime: json['is_can_overtime'] as bool? ?? false,
      // RPC may not return created_at/updated_at, fallback to current time
      createdAt: createdAtValue != null
          ? DateTimeUtils.toLocal(createdAtValue)
          : DateTime.now(),
      updatedAt: updatedAtValue != null
          ? DateTimeUtils.toLocal(updatedAtValue)
          : DateTime.now(),
    );
  }

  /// Parse timetz string and return time in HH:mm:ss format
  ///
  /// Example: "14:00:00+09:00" → "14:00:00"
  /// PostgreSQL automatically converts timetz to client's timezone
  static String _parseTimetzString(String timetzString) {
    try {
      // Remove timezone offset if present (e.g., "14:00:00+09:00" → "14:00:00")
      String cleanedTime = timetzString;
      if (timetzString.contains('+') || timetzString.contains('-')) {
        // Find the position of timezone offset
        final plusIndex = timetzString.indexOf('+');
        final minusIndex = timetzString.lastIndexOf('-');
        final offsetIndex = plusIndex != -1 ? plusIndex : minusIndex;

        if (offsetIndex > 0) {
          cleanedTime = timetzString.substring(0, offsetIndex);
        }
      }

      return cleanedTime;
    } catch (e) {
      // If parsing fails, return the original string
    }
    return timetzString;
  }

  /// Convert model to JSON (for Supabase operations)
  Map<String, dynamic> toJson() {
    return {
      'shift_id': shiftId,
      'shift_name': shiftName,
      'start_time': startTime,
      'end_time': endTime,
      'shift_bonus': shiftBonus,
      'is_active': isActive,
      'number_shift': numberShift,
      'is_can_overtime': isCanOvertime,
    };
  }

  /// Convert model to entity (domain layer)
  StoreShift toEntity() {
    return StoreShift(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      shiftBonus: shiftBonus,
      isActive: isActive,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from entity (domain layer)
  factory StoreShiftModel.fromEntity(StoreShift entity) {
    return StoreShiftModel(
      shiftId: entity.shiftId,
      shiftName: entity.shiftName,
      startTime: entity.startTime,
      endTime: entity.endTime,
      shiftBonus: entity.shiftBonus,
      isActive: entity.isActive,
      numberShift: entity.numberShift,
      isCanOvertime: entity.isCanOvertime,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
