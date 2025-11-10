import 'package:freezed_annotation/freezed_annotation.dart';

import 'employee_info.dart';
import 'shift.dart';

part 'schedule_data.freezed.dart';
part 'schedule_data.g.dart';

/// Schedule Data Entity
///
/// Contains complete schedule information including employees and shifts
/// for a specific store. Used for viewing and managing the overall schedule.
@freezed
class ScheduleData with _$ScheduleData {
  const ScheduleData._();

  const factory ScheduleData({
    /// List of all employees in the store
    @JsonKey(defaultValue: <EmployeeInfo>[])
    required List<EmployeeInfo> employees,

    /// List of all shifts in the store
    @JsonKey(defaultValue: <Shift>[])
    required List<Shift> shifts,

    /// The store ID this schedule data is for
    @JsonKey(name: 'store_id')
    required String storeId,
  }) = _ScheduleData;

  /// Create from JSON
  factory ScheduleData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataFromJson(json);

  /// Get the count of employees
  int get employeesCount => employees.length;

  /// Get the count of shifts
  int get shiftsCount => shifts.length;

  /// Check if there are any employees
  bool get hasEmployees => employees.isNotEmpty;

  /// Check if there are any shifts
  bool get hasShifts => shifts.isNotEmpty;

  /// Check if schedule data is empty
  bool get isEmpty => employees.isEmpty && shifts.isEmpty;

  /// Get employee by user ID
  EmployeeInfo? getEmployeeById(String userId) {
    try {
      return employees.firstWhere((emp) => emp.userId == userId);
    } catch (_) {
      return null;
    }
  }

  /// Get shift by shift ID
  Shift? getShiftById(String shiftId) {
    try {
      return shifts.firstWhere((shift) => shift.shiftId == shiftId);
    } catch (_) {
      return null;
    }
  }

  /// Get shifts for a specific date
  List<Shift> getShiftsByDate(String date) {
    return shifts.where((shift) => shift.shiftDate == date).toList();
  }

  /// Get fully staffed shifts
  List<Shift> get fullyStaffedShifts {
    return shifts.where((shift) => shift.isFullyStaffed).toList();
  }

  /// Get under-staffed shifts
  List<Shift> get underStaffedShifts {
    return shifts.where((shift) => shift.isUnderStaffed).toList();
  }
}
