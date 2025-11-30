import '../../domain/entities/shift_metadata.dart';

/// Shift Metadata Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftMetadata entity.
/// Clean Architecture: Data layer handles JSON, Domain stays pure.
class ShiftMetadataModel {
  final String shiftId;
  final String storeId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final bool isActive;
  final int? numberShift;
  final bool isCanOvertime;
  final double? shiftBonus;

  const ShiftMetadataModel({
    required this.shiftId,
    required this.storeId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    this.numberShift,
    required this.isCanOvertime,
    this.shiftBonus,
  });

  /// Create from JSON (from RPC: get_shift_metadata_v2)
  factory ShiftMetadataModel.fromJson(Map<String, dynamic> json) {
    return ShiftMetadataModel(
      shiftId: json['shift_id'] as String,
      storeId: json['store_id'] as String,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isActive: json['is_active'] as bool? ?? true,
      numberShift: json['number_shift'] as int?,
      isCanOvertime: json['is_can_overtime'] as bool? ?? false,
      shiftBonus: (json['shift_bonus'] as num?)?.toDouble(),
    );
  }

  /// Convert to Domain Entity
  ShiftMetadata toEntity() {
    return ShiftMetadata(
      shiftId: shiftId,
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      isActive: isActive,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    );
  }

  /// Create from Entity (for serialization)
  factory ShiftMetadataModel.fromEntity(ShiftMetadata entity) {
    return ShiftMetadataModel(
      shiftId: entity.shiftId,
      storeId: entity.storeId,
      shiftName: entity.shiftName,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isActive: entity.isActive,
      numberShift: entity.numberShift,
      isCanOvertime: entity.isCanOvertime,
      shiftBonus: entity.shiftBonus,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_id': shiftId,
      'store_id': storeId,
      'shift_name': shiftName,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'number_shift': numberShift,
      'is_can_overtime': isCanOvertime,
      'shift_bonus': shiftBonus,
    };
  }
}
