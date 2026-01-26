import '../entities/role.dart';
import '../entities/role_member.dart';
import '../entities/role_permission_info.dart';

/// Abstract repository for Role management
abstract class RoleRepository {
  /// Get all roles for a company
  Future<List<Role>> getAllCompanyRoles(String companyId, String? currentUserId);

  // getRoleById removed - data already available from get_company_roles_optimized RPC

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

  /// Delete a role (soft delete with audit trail)
  Future<void> deleteRole({
    required String roleId,
    required String companyId,
    required String deletedBy,
  });

  /// Get role permissions with categorized features
  Future<RolePermissionInfo> getRolePermissions(String roleId);

  /// Update role permissions
  Future<void> updateRolePermissions(String roleId, Set<String> permissions);

  /// Get role members as typed entities
  Future<List<RoleMember>> getRoleMembers(String roleId);

  /// Assign user to role
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  });
}
