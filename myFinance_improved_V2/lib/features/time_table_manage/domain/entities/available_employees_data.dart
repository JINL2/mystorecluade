import 'employee_info.dart';
import 'shift.dart';

/// Available Employees Data Entity
///
/// Contains information about available employees and existing shifts
/// for a specific store and date. Used when assigning employees to shifts.
class AvailableEmployeesData {
  /// List of employees available for assignment
  final List<EmployeeInfo> availableEmployees;

  /// List of existing shifts for the given date
  final List<Shift> existingShifts;

  /// The store ID this data is for
  final String storeId;

  /// The shift date this data is for (yyyy-MM-dd format)
  final String shiftDate;

  const AvailableEmployeesData({
    required this.availableEmployees,
    required this.existingShifts,
    required this.storeId,
    required this.shiftDate,
  });

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

  /// Copy with method for immutability
  AvailableEmployeesData copyWith({
    List<EmployeeInfo>? availableEmployees,
    List<Shift>? existingShifts,
    String? storeId,
    String? shiftDate,
  }) {
    return AvailableEmployeesData(
      availableEmployees: availableEmployees ?? this.availableEmployees,
      existingShifts: existingShifts ?? this.existingShifts,
      storeId: storeId ?? this.storeId,
      shiftDate: shiftDate ?? this.shiftDate,
    );
  }

  @override
  String toString() {
    return 'AvailableEmployeesData(employees: $availableCount, shifts: $shiftsCount, store: $storeId, date: $shiftDate)';
  }
}
