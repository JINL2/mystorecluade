import '../../domain/entities/employee_setting_data.dart';
import '../models/currency_type_model.dart';
import '../models/employee_salary_model.dart';
import '../models/role_model.dart';

/// Data Model: Employee Setting Data
///
/// Response model for the unified employee_setting_employee_data RPC.
/// Contains all data needed for the Employee Setting page in a single response.
///
/// Replaces 11 separate queries:
/// 1. v_user_salary employee list
/// 2. v_user_salary with search filter
/// 3. currency_types list
/// 4. currency_types code→UUID lookup
/// 5. roles full list
/// 6. roles by company
/// 7. user_roles lookup
/// 8. user_salaries existence check
/// 9. roles by ID lookup
/// 10. roles by name lookup
///
/// Note: isOwner check removed in v1.1 - use appState.isCurrentCompanyOwner
class EmployeeSettingDataModel {
  final bool success;
  final List<EmployeeSalaryModel> employees;
  final List<CurrencyTypeModel> currencies;
  final List<RoleModel> roles;

  const EmployeeSettingDataModel({
    required this.success,
    required this.employees,
    required this.currencies,
    required this.roles,
  });

  /// Create model from RPC JSON response
  factory EmployeeSettingDataModel.fromJson(Map<String, dynamic> json) {
    // Parse employees
    final employeesList = json['employees'] as List<dynamic>? ?? [];
    final employees = employeesList
        .map((e) {
          try {
            return EmployeeSalaryModel.fromJson(e as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<EmployeeSalaryModel>()
        .toList();

    // Parse currencies
    final currenciesList = json['currencies'] as List<dynamic>? ?? [];
    final currencies = currenciesList
        .map((c) {
          try {
            return CurrencyTypeModel.fromJson(c as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<CurrencyTypeModel>()
        .toList();

    // Parse roles
    final rolesList = json['roles'] as List<dynamic>? ?? [];
    final roles = rolesList
        .map((r) {
          try {
            return RoleModel.fromRpcJson(r as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<RoleModel>()
        .toList();

    return EmployeeSettingDataModel(
      success: json['success'] as bool? ?? false,
      employees: employees,
      currencies: currencies,
      roles: roles,
    );
  }

  /// Empty model for error/loading states
  static const empty = EmployeeSettingDataModel(
    success: false,
    employees: [],
    currencies: [],
    roles: [],
  );

  /// Convert model to domain entity
  EmployeeSettingData toEntity() {
    return EmployeeSettingData(
      success: success,
      employees: employees.map((e) => e.toEntity()).toList(),
      currencies: currencies.map((c) => c.toEntity()).toList(),
      roles: roles.map((r) => r.toEntity()).toList(),
    );
  }

  @override
  String toString() {
    return 'EmployeeSettingDataModel('
        'success: $success, '
        'employees: ${employees.length}, '
        'currencies: ${currencies.length}, '
        'roles: ${roles.length})';
  }
}
