import '../../domain/entities/daily_shift_data.dart';
import 'shift_model.dart';
import 'shift_request_model.dart';

/// Daily Shift Data Model (DTO + Mapper)
///
/// Data Transfer Object for DailyShiftData entity with JSON serialization.
class DailyShiftDataModel {
  final String date;
  final List<ShiftWithRequestsModel> shifts;

  const DailyShiftDataModel({
    required this.date,
    required this.shifts,
  });

  /// Create from JSON
  factory DailyShiftDataModel.fromJson(Map<String, dynamic> json) {
    return DailyShiftDataModel(
      date: json['date'] as String? ?? '',
      shifts: (json['shifts'] as List<dynamic>?)
              ?.map((e) =>
                  ShiftWithRequestsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'shifts': shifts.map((s) => s.toJson()).toList(),
    };
  }

  /// Map to Domain Entity
  DailyShiftData toEntity() {
    return DailyShiftData(
      date: date,
      shifts: shifts.map((s) => s.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory DailyShiftDataModel.fromEntity(DailyShiftData entity) {
    return DailyShiftDataModel(
      date: entity.date,
      shifts: entity.shifts
          .map((s) => ShiftWithRequestsModel.fromEntity(s))
          .toList(),
    );
  }
}

/// Shift with Requests Model
class ShiftWithRequestsModel {
  final ShiftModel shift;
  final List<ShiftRequestModel> pendingRequests;
  final List<ShiftRequestModel> approvedRequests;

  const ShiftWithRequestsModel({
    required this.shift,
    required this.pendingRequests,
    required this.approvedRequests,
  });

  /// Create from JSON
  factory ShiftWithRequestsModel.fromJson(Map<String, dynamic> json) {
    return ShiftWithRequestsModel(
      shift: ShiftModel.fromJson(json['shift'] as Map<String, dynamic>? ?? {}),
      pendingRequests: (json['pending_requests'] as List<dynamic>?)
              ?.map((e) =>
                  ShiftRequestModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      approvedRequests: (json['approved_requests'] as List<dynamic>?)
              ?.map((e) =>
                  ShiftRequestModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift': shift.toJson(),
      'pending_requests': pendingRequests.map((r) => r.toJson()).toList(),
      'approved_requests': approvedRequests.map((r) => r.toJson()).toList(),
    };
  }

  /// Map to Domain Entity
  ShiftWithRequests toEntity() {
    return ShiftWithRequests(
      shift: shift.toEntity(),
      pendingRequests: pendingRequests.map((r) => r.toEntity()).toList(),
      approvedRequests: approvedRequests.map((r) => r.toEntity()).toList(),
    );
  }

  /// Create from Domain Entity
  factory ShiftWithRequestsModel.fromEntity(ShiftWithRequests entity) {
    return ShiftWithRequestsModel(
      shift: ShiftModel.fromEntity(entity.shift),
      pendingRequests: entity.pendingRequests
          .map((r) => ShiftRequestModel.fromEntity(r))
          .toList(),
      approvedRequests: entity.approvedRequests
          .map((r) => ShiftRequestModel.fromEntity(r))
          .toList(),
    );
  }
}
