import '../../domain/entities/shift_request.dart';
import 'employee_info_model.dart';

/// Shift Request Model (DTO + Mapper)
///
/// Data Transfer Object for ShiftRequest entity with JSON serialization.
class ShiftRequestModel {
  final String shiftRequestId;
  final String shiftId;
  final EmployeeInfoModel employee;
  final bool isApproved;
  final String createdAt;
  final String? approvedAt;

  const ShiftRequestModel({
    required this.shiftRequestId,
    required this.shiftId,
    required this.employee,
    required this.isApproved,
    required this.createdAt,
    this.approvedAt,
  });

  /// Create from JSON
  factory ShiftRequestModel.fromJson(Map<String, dynamic> json) {
    return ShiftRequestModel(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      shiftId: json['shift_id'] as String? ?? '',
      employee: EmployeeInfoModel.fromJson(
        json['employee'] as Map<String, dynamic>? ?? {},
      ),
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      approvedAt: json['approved_at'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'shift_id': shiftId,
      'employee': employee.toJson(),
      'is_approved': isApproved,
      'created_at': createdAt,
      if (approvedAt != null) 'approved_at': approvedAt,
    };
  }

  /// Map to Domain Entity
  ShiftRequest toEntity() {
    return ShiftRequest(
      shiftRequestId: shiftRequestId,
      shiftId: shiftId,
      employee: employee.toEntity(),
      isApproved: isApproved,
      createdAt: DateTime.parse(createdAt),
      approvedAt: approvedAt != null ? DateTime.parse(approvedAt!) : null,
    );
  }

  /// Create from Domain Entity
  factory ShiftRequestModel.fromEntity(ShiftRequest entity) {
    return ShiftRequestModel(
      shiftRequestId: entity.shiftRequestId,
      shiftId: entity.shiftId,
      employee: EmployeeInfoModel.fromEntity(entity.employee),
      isApproved: entity.isApproved,
      createdAt: entity.createdAt.toIso8601String(),
      approvedAt: entity.approvedAt?.toIso8601String(),
    );
  }
}
