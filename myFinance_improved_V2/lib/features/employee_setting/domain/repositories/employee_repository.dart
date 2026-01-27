import '../entities/employee_setting_data.dart';
import '../entities/shift_audit_log.dart';
import '../value_objects/employee_update_request.dart';
import '../value_objects/salary_update_request.dart';

/// Domain Repository Interface: Employee Repository
///
/// Abstract interface for employee data operations.
/// This defines the contract that data layer must implement.
abstract class EmployeeRepository {
  /// Update employee salary information
  Future<void> updateSalary(SalaryUpdateRequest request);

  /// Validate employee deletion before executing
  ///
  /// Uses RPC: employee_setting_validate_employee_delete (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Self-deletion prevention (via auth.uid())
  /// - Returns data impact summary (will_soft_delete, will_preserve)
  Future<Map<String, dynamic>> validateEmployeeDelete({
    required String companyId,
    required String employeeUserId,
  });

  /// Delete employee from company (soft delete)
  ///
  /// Uses RPC: employee_setting_delete_employee (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Soft deletes: user_companies, user_stores, user_roles
  /// - Preserves: user_salaries (filtered by v_user_salary view automatically)
  /// - Owner data protection (cannot delete company owner)
  /// - Self-deletion prevention (via auth.uid())
  Future<EmployeeDeleteResult> deleteEmployee({
    required String companyId,
    required String employeeUserId,
  });

  /// Get employee shift audit logs with pagination
  ///
  /// Uses RPC: employee_setting_get_employee_shift_audit_logs
  /// Returns logs with pagination metadata (totalCount, hasMore)
  Future<ShiftAuditLogsResult> getEmployeeShiftAuditLogs({
    required String companyId,
    required String employeeUserId,
    int limit = 20,
    int offset = 0,
  });

  /// Assign or unassign a work schedule template to an employee
  ///
  /// Uses RPC: employee_setting_assign_work_schedule_template (v1.1)
  /// - No permission check (page-level access control assumed)
  /// - Pass null for templateId to unassign the current template
  /// - Returns warning for non-monthly salary types
  Future<WorkScheduleAssignResult> assignWorkScheduleTemplate({
    required String companyId,
    required String employeeUserId,
    String? templateId,
  });

  /// Get all employee setting data in a single RPC call
  ///
  /// Uses RPC: employee_setting_employee_data
  /// This replaces 11 individual queries with one unified RPC
  /// Returns: employees, currencies, roles
  ///
  /// Note: No permission check - accessible to all authenticated users
  /// Use appState.isCurrentCompanyOwner for owner-only UI features
  Future<EmployeeSettingData> getEmployeeSettingData({
    required String companyId,
    String? searchQuery,
    String? storeId,
  });
}
