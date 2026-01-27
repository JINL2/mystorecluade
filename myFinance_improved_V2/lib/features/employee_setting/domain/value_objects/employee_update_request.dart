/// Value Object: Employee Update Request
///
/// Request object for updating employee data (salary and/or role)
/// Used with RPC: employee_setting_update_employee
class EmployeeUpdateRequest {
  /// Company ID (required for authorization)
  final String companyId;

  /// Target employee's user ID (required)
  final String targetUserId;

  /// Salary record ID (optional, required for salary update)
  final String? salaryId;

  /// New salary amount (optional)
  final double? salaryAmount;

  /// Salary type: 'hourly', 'monthly', 'yearly', etc. (optional)
  final String? salaryType;

  /// Currency UUID (optional, takes precedence over currencyCode)
  final String? currencyId;

  /// Currency code: 'USD', 'VND', 'KRW', etc. (optional)
  final String? currencyCode;

  /// New role ID to assign (optional)
  final String? newRoleId;

  const EmployeeUpdateRequest({
    required this.companyId,
    required this.targetUserId,
    this.salaryId,
    this.salaryAmount,
    this.salaryType,
    this.currencyId,
    this.currencyCode,
    this.newRoleId,
  });

  /// Create request for salary update only
  factory EmployeeUpdateRequest.salary({
    required String companyId,
    required String targetUserId,
    required String salaryId,
    double? salaryAmount,
    String? salaryType,
    String? currencyId,
    String? currencyCode,
  }) {
    return EmployeeUpdateRequest(
      companyId: companyId,
      targetUserId: targetUserId,
      salaryId: salaryId,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
      currencyId: currencyId,
      currencyCode: currencyCode,
    );
  }

  /// Create request for role update only
  factory EmployeeUpdateRequest.role({
    required String companyId,
    required String targetUserId,
    required String newRoleId,
  }) {
    return EmployeeUpdateRequest(
      companyId: companyId,
      targetUserId: targetUserId,
      newRoleId: newRoleId,
    );
  }

  /// Create request for both salary and role update
  factory EmployeeUpdateRequest.both({
    required String companyId,
    required String targetUserId,
    required String salaryId,
    double? salaryAmount,
    String? salaryType,
    String? currencyId,
    String? currencyCode,
    required String newRoleId,
  }) {
    return EmployeeUpdateRequest(
      companyId: companyId,
      targetUserId: targetUserId,
      salaryId: salaryId,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
      currencyId: currencyId,
      currencyCode: currencyCode,
      newRoleId: newRoleId,
    );
  }

  /// Check if this request updates salary
  bool get updatesSalary => salaryId != null;

  /// Check if this request updates role
  bool get updatesRole => newRoleId != null;

  @override
  String toString() {
    return 'EmployeeUpdateRequest('
        'companyId: $companyId, '
        'targetUserId: $targetUserId, '
        'salaryId: $salaryId, '
        'salaryAmount: $salaryAmount, '
        'salaryType: $salaryType, '
        'currencyId: $currencyId, '
        'currencyCode: $currencyCode, '
        'newRoleId: $newRoleId)';
  }
}

/// Result of employee update operation
///
/// Returned by RPC: employee_setting_update_employee
class EmployeeUpdateResult {
  /// Whether salary was updated
  final bool salaryUpdated;

  /// Whether role was updated
  final bool roleUpdated;

  /// Target user ID that was updated
  final String? targetUserId;

  /// New user_role record ID (if role was changed)
  final String? newUserRoleId;

  const EmployeeUpdateResult({
    required this.salaryUpdated,
    required this.roleUpdated,
    this.targetUserId,
    this.newUserRoleId,
  });

  /// Check if any update was made
  bool get hasUpdates => salaryUpdated || roleUpdated;

  @override
  String toString() {
    return 'EmployeeUpdateResult('
        'salaryUpdated: $salaryUpdated, '
        'roleUpdated: $roleUpdated, '
        'targetUserId: $targetUserId, '
        'newUserRoleId: $newUserRoleId)';
  }
}

/// Result of employee delete operation
///
/// Returned by RPC: employee_setting_delete_employee
/// Contains information about the deleted employee and affected records
class EmployeeDeleteResult {
  /// The deleted employee's user ID
  final String? employeeId;

  /// The company ID
  final String? companyId;

  /// Timestamp of deletion (UTC)
  final String? deletedAt;

  /// Number of user_companies records soft-deleted
  final int affectedUserCompanies;

  /// Number of user_stores records soft-deleted
  final int affectedUserStores;

  /// Number of user_roles records soft-deleted
  final int affectedUserRoles;

  const EmployeeDeleteResult({
    this.employeeId,
    this.companyId,
    this.deletedAt,
    this.affectedUserCompanies = 0,
    this.affectedUserStores = 0,
    this.affectedUserRoles = 0,
  });

  /// Total number of affected records
  int get totalAffected =>
      affectedUserCompanies + affectedUserStores + affectedUserRoles;

  @override
  String toString() {
    return 'EmployeeDeleteResult('
        'employeeId: $employeeId, '
        'companyId: $companyId, '
        'deletedAt: $deletedAt, '
        'affected: {companies: $affectedUserCompanies, '
        'stores: $affectedUserStores, roles: $affectedUserRoles})';
  }
}

/// Result of work schedule template assignment
///
/// Returned by RPC: employee_setting_assign_work_schedule_template
class WorkScheduleAssignResult {
  /// The employee's user ID
  final String employeeUserId;

  /// Assigned template ID (null if unassigned)
  final String? templateId;

  /// Assigned template name (null if unassigned)
  final String? templateName;

  /// Employee's salary type (monthly, hourly, etc.)
  final String salaryType;

  /// Action performed: "assigned" or "unassigned"
  final String action;

  /// Warning message (e.g., for non-monthly employees)
  final String? warning;

  const WorkScheduleAssignResult({
    required this.employeeUserId,
    this.templateId,
    this.templateName,
    required this.salaryType,
    required this.action,
    this.warning,
  });

  /// Check if template was assigned (not unassigned)
  bool get isAssigned => action == 'assigned';

  /// Check if there's a warning message
  bool get hasWarning => warning != null && warning!.isNotEmpty;

  @override
  String toString() {
    return 'WorkScheduleAssignResult('
        'employeeUserId: $employeeUserId, '
        'templateId: $templateId, '
        'templateName: $templateName, '
        'salaryType: $salaryType, '
        'action: $action, '
        'warning: $warning)';
  }
}
