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
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON (from Supabase response)
  ///
  /// **중요:** DB에 저장된 UTC 시간을 로컬 시간으로 변환합니다.
  factory StoreShiftModel.fromJson(Map<String, dynamic> json) {
    return StoreShiftModel(
      shiftId: json['shift_id'] as String,
      shiftName: json['shift_name'] as String,
      // Convert UTC time to local time for display
      startTime: _convertUtcTimeToLocal(json['start_time'] as String),
      endTime: _convertUtcTimeToLocal(json['end_time'] as String),
      shiftBonus: json['shift_bonus'] as int,
      isActive: json['is_active'] as bool? ?? true,
      // Convert UTC timestamps to local time
      createdAt: DateTimeUtils.toLocal(json['created_at'] as String),
      updatedAt: DateTimeUtils.toLocal(json['updated_at'] as String),
    );
  }

  /// Convert UTC time string to local time string
  ///
  /// Example: UTC "06:15:00" → Local "15:15:00" (in KST, UTC+9)
  static String _convertUtcTimeToLocal(String utcTimeString) {
    try {
      // Parse "HH:mm" or "HH:mm:ss" format
      final parts = utcTimeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final second = parts.length >= 3 ? int.parse(parts[2]) : 0;

        // Create a UTC DateTime object with today's date and the parsed time
        final now = DateTime.now();
        final utcDateTime = DateTime.utc(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
          second,
        );

        // Convert to local time
        final localDateTime = utcDateTime.toLocal();

        // Return as time string in HH:mm:ss format
        final localHour = localDateTime.hour.toString().padLeft(2, '0');
        final localMinute = localDateTime.minute.toString().padLeft(2, '0');
        final localSecond = localDateTime.second.toString().padLeft(2, '0');
        return '$localHour:$localMinute:$localSecond';
      }
    } catch (e) {
      // If parsing fails, return the original string
    }
    return utcTimeString;
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
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
