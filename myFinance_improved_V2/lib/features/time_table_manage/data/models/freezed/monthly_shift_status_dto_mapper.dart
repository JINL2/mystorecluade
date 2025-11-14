import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_request.dart';
import 'monthly_shift_status_dto.dart';

/// Extension to map MonthlyShiftStatusDto → Domain Entity
///
/// Separates DTO (data layer) from Entity (domain layer)
extension MonthlyShiftStatusDtoMapper on MonthlyShiftStatusDto {
  /// Convert DTO to Domain Entity
  ///
  /// Note: RPC returns flat date records, we group by month
  MonthlyShiftStatus toEntity({required String month}) {
    // Create DailyShiftData for this date
    final dailyData = DailyShiftData(
      date: requestDate,
      shifts: shifts.map((s) => s.toEntity(requestDate)).toList(),
    );

    return MonthlyShiftStatus(
      month: month, // e.g., "2025-01"
      dailyShifts: [dailyData],
      statistics: {
        'total_required': totalRequired,
        'total_approved': totalApproved,
        'total_pending': totalPending,
      },
    );
  }
}

/// Extension to map ShiftWithEmployeesDto → ShiftWithRequests Entity
extension ShiftWithEmployeesDtoMapper on ShiftWithEmployeesDto {
  ShiftWithRequests toEntity(String requestDate) {
    // Create Shift entity
    final shift = Shift(
      shiftId: shiftId,
      storeId: '', // RPC doesn't return store_id at shift level
      shiftDate: requestDate,
      planStartTime: DateTime.now(), // RPC doesn't return times
      planEndTime: DateTime.now(), // RPC doesn't return times
      targetCount: requiredEmployees,
      currentCount: approvedCount,
      shiftName: shiftName,
    );

    // Map approved employees
    final approvedReqs = approvedEmployees
        .map((emp) => emp.toEntity(requestDate, shiftId, isApproved: true))
        .toList();

    // Map pending employees
    final pendingReqs = pendingEmployees
        .map((emp) => emp.toEntity(requestDate, shiftId, isApproved: false))
        .toList();

    return ShiftWithRequests(
      shift: shift,
      approvedRequests: approvedReqs,
      pendingRequests: pendingReqs,
    );
  }
}

/// Extension to map ShiftEmployeeDto → ShiftRequest Entity
extension ShiftEmployeeDtoMapper on ShiftEmployeeDto {
  ShiftRequest toEntity(
    String requestDate,
    String shiftId, {
    required bool isApproved,
  }) {
    return ShiftRequest(
      shiftRequestId: shiftRequestId,
      employee: EmployeeInfo(
        userId: userId,
        userName: userName,
        profileImage: profileImage,
      ),
      shiftId: shiftId,
      isApproved: isApproved,
      createdAt: DateTime.now(), // RPC doesn't return created_at for employees
      approvedAt: isApproved ? DateTime.now() : null, // Approximate based on approval status
    );
  }
}
