import 'package:freezed_annotation/freezed_annotation.dart';

import 'employee_info.dart';
import 'shift.dart';

part 'available_employees_data.freezed.dart';
part 'available_employees_data.g.dart';

/// Available Employees Data Entity
///
/// Contains information about available employees and existing shifts
/// for a specific store and date. Used when assigning employees to shifts.
@freezed
class AvailableEmployeesData with _$AvailableEmployeesData {
  const AvailableEmployeesData._();

  const factory AvailableEmployeesData({
    /// List of employees available for assignment
    @JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
    required List<EmployeeInfo> availableEmployees,

    /// List of existing shifts for the given date
    @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
    required List<Shift> existingShifts,

    /// The store ID this data is for
    @JsonKey(name: 'store_id')
    required String storeId,

    /// The shift date this data is for (yyyy-MM-dd format)
    @JsonKey(name: 'shift_date')
    required String shiftDate,
  }) = _AvailableEmployeesData;

  /// Create from JSON
  factory AvailableEmployeesData.fromJson(Map<String, dynamic> json) =>
      _$AvailableEmployeesDataFromJson(json);

  /// Get the count of available employees
  int get availableCount => availableEmployees.length;

  /// Check if there are any available employees
  bool get hasAvailableEmployees => availableEmployees.isNotEmpty;

  /// Get the count of existing shifts
  int get shiftsCount => existingShifts.length;

  /// Check if there are any existing shifts
  bool get hasExistingShifts => existingShifts.isNotEmpty;

  /// Get employee by user ID
  EmployeeInfo? getEmployeeById(String userId) {
    try {
      return availableEmployees.firstWhere((emp) => emp.userId == userId);
    } catch (_) {
      return null;
    }
  }

  /// Get shift by shift ID
  Shift? getShiftById(String shiftId) {
    try {
      return existingShifts.firstWhere((shift) => shift.shiftId == shiftId);
    } catch (_) {
      return null;
    }
  }

  /// Filter employees by name (case-insensitive)
  List<EmployeeInfo> filterEmployeesByName(String query) {
    if (query.isEmpty) return availableEmployees;

    final lowerQuery = query.toLowerCase();
    return availableEmployees
        .where((emp) => emp.userName.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
