import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_shift_status.freezed.dart';

/// Monthly Shift Status Entity - Represents daily shift status
///
/// Represents shift status for a specific date from RPC: get_monthly_shift_status_manager_v4
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

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static MonthlyShiftStatus mock() => MonthlyShiftStatus(
        requestDate: '2025-01-01',
        totalPending: 2,
        totalApproved: 5,
        shifts: DailyShift.mockList(2),
      );

  static List<MonthlyShiftStatus> mockList([int count = 3]) =>
      List.generate(count, (_) => mock());
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
    @Default(0) int requiredEmployees,
    @Default(0) int pendingCount,
    @Default(0) int approvedCount,
    @Default([]) List<EmployeeStatus> pendingEmployees,
    @Default([]) List<EmployeeStatus> approvedEmployees,
  }) = _DailyShift;

  /// Total employees in this shift
  int get totalEmployees => pendingEmployees.length + approvedEmployees.length;

  /// Has any employees
  bool get hasEmployees => totalEmployees > 0;

  /// Check if shift has available slots
  bool get hasAvailableSlots => approvedCount < requiredEmployees;

  /// Available slots count
  int get availableSlots =>
      requiredEmployees > approvedCount ? requiredEmployees - approvedCount : 0;

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static DailyShift mock() => DailyShift(
        shiftId: 'mock-shift-id',
        shiftName: 'Morning Shift',
        shiftType: 'regular',
        startTime: '09:00',
        endTime: '17:00',
        requiredEmployees: 3,
        pendingCount: 1,
        approvedCount: 2,
        pendingEmployees: EmployeeStatus.mockList(1),
        approvedEmployees: EmployeeStatus.mockList(2),
      );

  static List<DailyShift> mockList([int count = 2]) =>
      List.generate(count, (_) => mock());
}

/// Employee Status Entity
///
/// Represents employee status within monthly shift
@freezed
class EmployeeStatus with _$EmployeeStatus {
  const EmployeeStatus._();

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

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static EmployeeStatus mock() => const EmployeeStatus(
        userId: 'mock-user-id',
        userName: 'Employee Name',
        userEmail: 'employee@example.com',
        isApproved: true,
      );

  static List<EmployeeStatus> mockList([int count = 2]) =>
      List.generate(count, (_) => mock());
}
