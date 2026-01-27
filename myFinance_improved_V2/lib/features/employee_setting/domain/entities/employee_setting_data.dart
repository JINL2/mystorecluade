import 'currency_type.dart';
import 'employee_salary.dart';
import 'role.dart';

/// Domain Entity: Employee Setting Data
///
/// Unified data structure containing all employee setting page data.
/// This entity represents the result of a single RPC call that replaces
/// 11 individual queries for better performance.
///
/// Note: isOwner check removed in v1.1 - use appState.isCurrentCompanyOwner
class EmployeeSettingData {
  final bool success;
  final List<EmployeeSalary> employees;
  final List<CurrencyType> currencies;
  final List<Role> roles;

  const EmployeeSettingData({
    required this.success,
    required this.employees,
    required this.currencies,
    required this.roles,
  });

  /// Create an empty instance for initial state
  factory EmployeeSettingData.empty() {
    return const EmployeeSettingData(
      success: false,
      employees: [],
      currencies: [],
      roles: [],
    );
  }

  /// Create a copy with updated fields
  EmployeeSettingData copyWith({
    bool? success,
    List<EmployeeSalary>? employees,
    List<CurrencyType>? currencies,
    List<Role>? roles,
  }) {
    return EmployeeSettingData(
      success: success ?? this.success,
      employees: employees ?? this.employees,
      currencies: currencies ?? this.currencies,
      roles: roles ?? this.roles,
    );
  }
}
