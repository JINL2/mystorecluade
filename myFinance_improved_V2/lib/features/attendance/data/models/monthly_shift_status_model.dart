import '../../domain/entities/monthly_shift_status.dart';

/// Monthly Shift Status Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for MonthlyShiftStatus entity.
class MonthlyShiftStatusModel {
  final MonthlyShiftStatus _entity;

  MonthlyShiftStatusModel(this._entity);

  /// Create from Entity
  factory MonthlyShiftStatusModel.fromEntity(MonthlyShiftStatus entity) {
    return MonthlyShiftStatusModel(entity);
  }

  /// Convert to Entity
  MonthlyShiftStatus toEntity() => _entity;

  /// Create from JSON (from RPC: get_monthly_shift_status_manager_v2)
  factory MonthlyShiftStatusModel.fromJson(Map<String, dynamic> json) {
    // Parse shifts
    final shiftsJson = json['shifts'] as List? ?? [];
    final shifts = shiftsJson
        .map((e) => _parseDailyShift(e as Map<String, dynamic>))
        .toList();

    return MonthlyShiftStatusModel(
      MonthlyShiftStatus(
        requestDate: json['request_date'] as String? ?? '',
        totalPending: json['total_pending'] as int? ?? 0,
        totalApproved: json['total_approved'] as int? ?? 0,
        shifts: shifts,
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'request_date': _entity.requestDate,
      'total_pending': _entity.totalPending,
      'total_approved': _entity.totalApproved,
      'shifts': _entity.shifts
          .map((s) => _dailyShiftToJson(s))
          .toList(),
    };
  }

  // ========================================
  // Private Helper Methods
  // ========================================

  /// Parse DailyShift from JSON
  static DailyShift _parseDailyShift(Map<String, dynamic> json) {
    // Parse pending employees
    final pendingEmployeesJson = json['pending_employees'] as List? ?? [];
    final pendingEmployees = pendingEmployeesJson
        .map((e) => _parseEmployeeStatus(e as Map<String, dynamic>))
        .toList();

    // Parse approved employees
    final approvedEmployeesJson = json['approved_employees'] as List? ?? [];
    final approvedEmployees = approvedEmployeesJson
        .map((e) => _parseEmployeeStatus(e as Map<String, dynamic>))
        .toList();

    return DailyShift(
      shiftId: (json['shift_id'] ?? json['id'] ?? json['store_shift_id'])?.toString() ?? '',
      shiftName: json['shift_name'] as String?,
      shiftType: json['shift_type'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      pendingEmployees: pendingEmployees,
      approvedEmployees: approvedEmployees,
    );
  }

  /// Convert DailyShift to JSON
  static Map<String, dynamic> _dailyShiftToJson(DailyShift shift) {
    return {
      'shift_id': shift.shiftId,
      'shift_name': shift.shiftName,
      'shift_type': shift.shiftType,
      'start_time': shift.startTime,
      'end_time': shift.endTime,
      'pending_employees': shift.pendingEmployees
          .map((e) => _employeeStatusToJson(e))
          .toList(),
      'approved_employees': shift.approvedEmployees
          .map((e) => _employeeStatusToJson(e))
          .toList(),
    };
  }

  /// Parse EmployeeStatus from JSON
  static EmployeeStatus _parseEmployeeStatus(Map<String, dynamic> json) {
    return EmployeeStatus(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      userEmail: json['user_email'] as String?,
      userPhone: json['user_phone'] as String?,
      profileImage: json['profile_image'] as String?,
      shiftRequestId: json['shift_request_id'] as String?,
      requestTime: _parseDateTime(json['request_time']),
      isApproved: json['is_approved'] as bool?,
      approvedBy: json['approved_by'] as String?,
    );
  }

  /// Convert EmployeeStatus to JSON
  static Map<String, dynamic> _employeeStatusToJson(EmployeeStatus employee) {
    return {
      'user_id': employee.userId,
      'user_name': employee.userName,
      'user_email': employee.userEmail,
      'user_phone': employee.userPhone,
      'profile_image': employee.profileImage,
      'shift_request_id': employee.shiftRequestId,
      'request_time': employee.requestTime?.toIso8601String(),
      'is_approved': employee.isApproved,
      'approved_by': employee.approvedBy,
    };
  }

  /// Parse DateTime from JSON string
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
