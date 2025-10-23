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
    return Shift(
      shiftId: shiftId,
      storeId: storeId,
      shiftDate: shiftDate,
      planStartTime: DateTime.parse(planStartTime),
      planEndTime: DateTime.parse(planEndTime),
      targetCount: targetCount,
      currentCount: currentCount,
      tags: tags,
      shiftName: shiftName,
    );
  }

  /// Create from Domain Entity
  factory ShiftModel.fromEntity(Shift entity) {
    return ShiftModel(
      shiftId: entity.shiftId,
      storeId: entity.storeId,
      shiftDate: entity.shiftDate,
      planStartTime: entity.planStartTime.toIso8601String(),
      planEndTime: entity.planEndTime.toIso8601String(),
      targetCount: entity.targetCount,
      currentCount: entity.currentCount,
      tags: entity.tags,
      shiftName: entity.shiftName,
    );
  }
}
