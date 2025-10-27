import '../entities/employee_salary.dart';
import '../entities/currency_type.dart';
import '../value_objects/salary_update_request.dart';

/// Domain Repository Interface: Employee Repository
///
/// Abstract interface for employee data operations.
/// This defines the contract that data layer must implement.
abstract class EmployeeRepository {
  /// Get all employees for a company
  Future<List<EmployeeSalary>> getEmployeeSalaries(String companyId);

  /// Search employees by query and optional filters
  Future<List<EmployeeSalary>> searchEmployees({
    required String companyId,
    String? searchQuery,
    String? storeId,
  });

  /// Get available currency types
  Future<List<CurrencyType>> getCurrencyTypes();

  /// Update employee salary information
  Future<void> updateSalary(SalaryUpdateRequest request);

  /// Watch real-time updates for employee salaries
  Stream<List<EmployeeSalary>> watchEmployeeSalaries(String companyId);
}
