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
  factory StoreShiftModel.fromJson(Map<String, dynamic> json) {
    return StoreShiftModel(
      shiftId: json['shift_id'] as String,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,  // Time-only, no conversion
      endTime: json['end_time'] as String,      // Time-only, no conversion
      shiftBonus: json['shift_bonus'] as int,
      isActive: json['is_active'] as bool? ?? true,
      // Convert UTC timestamps to local time
      createdAt: DateTimeUtils.toLocal(json['created_at'] as String),
      updatedAt: DateTimeUtils.toLocal(json['updated_at'] as String),
    );
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
