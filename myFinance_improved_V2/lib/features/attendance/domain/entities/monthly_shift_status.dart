import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_shift_status.freezed.dart';

/// Monthly Shift Status Entity - Pure business object
///
/// Represents shift status for the month from RPC: get_monthly_shift_status_manager_v2
/// Does NOT contain JSON serialization - that's handled by MonthlyShiftStatusModel in Data layer.
@freezed
class MonthlyShiftStatus with _$MonthlyShiftStatus {
  const MonthlyShiftStatus._();

  const factory MonthlyShiftStatus({
    required String requestDate,
    required String shiftId,
    String? shiftName,
    String? shiftType,
    @Default([]) List<EmployeeStatus> pendingEmployees,
    @Default([]) List<EmployeeStatus> approvedEmployees,
  }) = _MonthlyShiftStatus;

  // ========================================
  // Business Logic Methods
  // ========================================

  /// Total employees count
  int get totalEmployees => pendingEmployees.length + approvedEmployees.length;

  /// Has any employees
  bool get hasEmployees => totalEmployees > 0;

  /// Get approval rate
  double get approvalRate {
    if (totalEmployees == 0) return 0.0;
    return approvedEmployees.length / totalEmployees;
  }

  /// Check if all employees are approved
  bool get isFullyApproved => pendingEmployees.isEmpty && approvedEmployees.isNotEmpty;

  /// Check if has pending employees
  bool get hasPendingEmployees => pendingEmployees.isNotEmpty;
}

/// Employee Status Entity
///
/// Represents employee status within monthly shift
@freezed
class EmployeeStatus with _$EmployeeStatus {
  const factory EmployeeStatus({
    required String userId,
    required String userName,
    String? userEmail,
    String? userPhone,
    DateTime? requestTime,
    bool? isApproved,
    String? approvedBy,
  }) = _EmployeeStatus;
}
