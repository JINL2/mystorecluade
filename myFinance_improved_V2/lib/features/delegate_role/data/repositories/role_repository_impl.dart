import '../../domain/entities/delegatable_role.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/role_remote_data_source.dart';

/// Implementation of RoleRepository
class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource _remoteDataSource;

  RoleRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Role>> getAllCompanyRoles(
    String companyId,
    String? currentUserId,
  ) async {
    final models = await _remoteDataSource.getAllCompanyRoles(
      companyId,
      currentUserId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Role> getRoleById(String roleId) async {
    final model = await _remoteDataSource.getRoleById(roleId);
    return model.toEntity();
  }

  @override
  Future<String> createRole({
    required String companyId,
    required String roleName,
    String? description,
    String roleType = 'custom',
    List<String>? tags,
  }) async {
    return await _remoteDataSource.createRole(
      companyId: companyId,
      roleName: roleName,
      description: description,
      roleType: roleType,
      tags: tags,
    );
  }

  @override
  Future<void> updateRoleDetails({
    required String roleId,
    required String roleName,
    String? description,
    List<String>? tags,
  }) async {
    return await _remoteDataSource.updateRoleDetails(
      roleId: roleId,
      roleName: roleName,
      description: description,
      tags: tags,
    );
  }

  @override
  Future<void> deleteRole(String roleId, String companyId) async {
    return await _remoteDataSource.deleteRole(roleId, companyId);
  }

  @override
  Future<Map<String, dynamic>> getRolePermissions(String roleId) async {
    return await _remoteDataSource.getRolePermissions(roleId);
  }

  @override
  Future<void> updateRolePermissions(
    String roleId,
    Set<String> permissions,
  ) async {
    return await _remoteDataSource.updateRolePermissions(roleId, permissions);
  }

  @override
  Future<List<DelegatableRole>> getDelegatableRoles(String companyId) async {
    // Note: This needs current user role, but we don't have it in domain
    // For now, return empty list - needs refactoring
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> getRoleMembers(String roleId) async {
    return await _remoteDataSource.getRoleMembers(roleId);
  }

  @override
  Future<void> assignUserToRole({
    required String userId,
    required String roleId,
    required String companyId,
  }) async {
    return await _remoteDataSource.assignUserToRole(
      userId: userId,
      roleId: roleId,
      companyId: companyId,
    );
  }
}
