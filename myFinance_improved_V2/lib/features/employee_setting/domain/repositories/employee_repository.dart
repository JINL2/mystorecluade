import '../entities/currency_type.dart';
import '../entities/employee_salary.dart';
import '../entities/shift_audit_log.dart';
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

  /// Check if the current user is the owner of the company
  Future<bool> isCurrentUserOwner(String companyId);

  /// Validate employee deletion before executing
  Future<Map<String, dynamic>> validateEmployeeDelete({
    required String companyId,
    required String employeeUserId,
  });

  /// Delete employee from company (soft delete)
  Future<Map<String, dynamic>> deleteEmployee({
    required String companyId,
    required String employeeUserId,
    bool deleteSalary = true,
  });

  /// Get employee shift audit logs with pagination
  Future<List<ShiftAuditLog>> getEmployeeShiftAuditLogs({
    required String userId,
    required String companyId,
    int limit = 20,
    int offset = 0,
  });
}
