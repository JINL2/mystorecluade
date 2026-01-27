/// Domain Repository Interface: Role Repository
///
/// Abstract interface for role data operations.
/// This defines the contract that data layer must implement.
abstract class RoleRepository {
  /// Update user role assignment
  ///
  /// Uses RPC: employee_setting_update_employee
  /// Requires companyId for proper authorization check
  Future<void> updateUserRole({
    required String companyId,
    required String userId,
    required String roleId,
  });
}
