import '../entities/role.dart';

/// Domain Repository Interface: Role Repository
///
/// Abstract interface for role data operations.
/// This defines the contract that data layer must implement.
abstract class RoleRepository {
  /// Fetch all roles from the system
  Future<List<Role>> getAllRoles();

  /// Fetch roles for a specific company (includes global and company-specific roles)
  Future<List<Role>> getRolesByCompany(String companyId);

  /// Update user role assignment
  Future<void> updateUserRole(String userId, String roleId);

  /// Get role by ID
  Future<Role?> getRoleById(String roleId);

  /// Get role by name
  Future<Role?> getRoleByName(String roleName);
}
