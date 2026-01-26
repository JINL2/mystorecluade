import '../../domain/entities/role.dart';
import '../../domain/entities/role_member.dart';
import '../../domain/entities/role_permission_info.dart';
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

  // getRoleById removed - data already available from get_company_roles_optimized RPC

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
  Future<void> deleteRole({
    required String roleId,
    required String companyId,
    required String deletedBy,
  }) async {
    return await _remoteDataSource.deleteRole(
      roleId: roleId,
      companyId: companyId,
      deletedBy: deletedBy,
    );
  }

  @override
  Future<RolePermissionInfo> getRolePermissions(String roleId) async {
    final data = await _remoteDataSource.getRolePermissions(roleId);

    // Convert raw data to typed entities
    final currentPermissions = data['currentPermissions'] as Set<String>? ?? {};
    final categoriesData = data['categories'] as List<dynamic>? ?? [];

    final categories = categoriesData.map((cat) {
      final catMap = cat as Map<String, dynamic>;
      final featuresData = catMap['features'] as List<dynamic>? ?? [];

      final features = featuresData.map((f) {
        final featureMap = f as Map<String, dynamic>;
        return Feature(
          featureId: featureMap['feature_id'] as String,
          featureName: featureMap['feature_name'] as String,
          description: featureMap['description'] as String?,
        );
      }).toList();

      return FeatureCategory(
        categoryId: catMap['category_id'] as String,
        categoryName: catMap['category_name'] as String,
        description: catMap['description'] as String?,
        features: features,
      );
    }).toList();

    return RolePermissionInfo(
      currentPermissions: currentPermissions,
      categories: categories,
    );
  }

  @override
  Future<void> updateRolePermissions(
    String roleId,
    Set<String> permissions,
  ) async {
    return await _remoteDataSource.updateRolePermissions(roleId, permissions);
  }

  @override
  Future<List<RoleMember>> getRoleMembers(String roleId) async {
    final data = await _remoteDataSource.getRoleMembers(roleId);

    return data.map((memberMap) {
      return RoleMember(
        userId: memberMap['user_id'] as String,
        name: memberMap['name'] as String,
        email: memberMap['email'] as String,
        assignedAt: memberMap['created_at'] != null
            ? DateTime.tryParse(memberMap['created_at'] as String)
            : null,
      );
    }).toList();
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
