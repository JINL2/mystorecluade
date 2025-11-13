import '../entities/delegatable_role.dart';
import '../entities/role.dart';

/// Abstract repository for Role management
abstract class RoleRepository {
  /// Get all roles for a company
  Future<List<Role>> getAllCompanyRoles(String companyId, String? currentUserId);

  /// Get a single role by ID
  Future<Role> getRoleById(String roleId);

  /// Create a new role
  Future<String> createRole({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  });

  /// Update role details (name, description, tags)
  Future<void> updateRoleDetails({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  });

  /// Delete a role
  Future<void> deleteRole(String roleId, String companyId);

  /// Get role permissions
  Future<Map<String, dynamic>> getRolePermissions(String roleId);

  /// Update role permissions
  Future<void> updateRolePermissions(String roleId, Set<String> permissions);

  /// Get roles that can be delegated by current user
  Future<List<DelegatableRole>> getDelegatableRoles(String companyId);

  /// Get role members
  Future<List<Map<String, dynamic>>> getRoleMembers(String roleId);

  /// Assign user to role
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  });
}
