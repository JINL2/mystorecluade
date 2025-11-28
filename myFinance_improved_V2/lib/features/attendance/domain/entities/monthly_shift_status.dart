import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_shift_status.freezed.dart';
part 'monthly_shift_status.g.dart';

/// Monthly Shift Status Entity - Represents daily shift status
///
/// Represents shift status for a specific date from RPC: get_monthly_shift_status_manager_v2
/// Contains all shifts for a given day with their pending and approved employees.
@freezed
class MonthlyShiftStatus with _$MonthlyShiftStatus {
  const MonthlyShiftStatus._();

  const factory MonthlyShiftStatus({
    required String requestDate,
    @Default(0) int totalPending,
    @Default(0) int totalApproved,
    @Default([]) List<DailyShift> shifts,
  }) = _MonthlyShiftStatus;

  /// JSON serialization support
  factory MonthlyShiftStatus.fromJson(Map<String, dynamic> json) =>
      _$MonthlyShiftStatusFromJson(json);

  // ========================================
  // Business Logic Methods
  // ========================================

  /// Total employees count
  int get totalEmployees => totalPending + totalApproved;

  /// Has any employees
  bool get hasEmployees => totalEmployees > 0;

  /// Get approval rate
  double get approvalRate {
    if (totalEmployees == 0) return 0.0;
    return totalApproved / totalEmployees;
  }

  /// Check if all employees are approved
  bool get isFullyApproved => totalPending == 0 && totalApproved > 0;

  /// Check if has pending employees
  bool get hasPendingEmployees => totalPending > 0;

  /// Get shift by ID
  DailyShift? getShiftById(String shiftId) {
    try {
      return shifts.firstWhere((s) => s.shiftId == shiftId);
    } catch (e) {
      return null;
    }
  }
}

/// Daily Shift Entity - Represents a single shift within a day
@freezed
class DailyShift with _$DailyShift {
  const DailyShift._();

  const factory DailyShift({
    required String shiftId,
    String? shiftName,
    String? shiftType,
    String? startTime,
    String? endTime,
    @Default([]) List<EmployeeStatus> pendingEmployees,
    @Default([]) List<EmployeeStatus> approvedEmployees,
  }) = _DailyShift;

  /// JSON serialization support
  factory DailyShift.fromJson(Map<String, dynamic> json) =>
      _$DailyShiftFromJson(json);

  /// Total employees in this shift
  int get totalEmployees => pendingEmployees.length + approvedEmployees.length;

  /// Has any employees
  bool get hasEmployees => totalEmployees > 0;
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
    String? profileImage,
    String? shiftRequestId,
    DateTime? requestTime,
    bool? isApproved,
    String? approvedBy,
  }) = _EmployeeStatus;

  /// JSON serialization support
  factory EmployeeStatus.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStatusFromJson(json);
}
