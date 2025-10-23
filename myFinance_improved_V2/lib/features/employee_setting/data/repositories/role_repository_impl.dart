import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/role_remote_datasource.dart';

/// Repository Implementation: Role Repository
///
/// Implements the domain repository interface using the remote data source.
/// This layer converts between data models and domain entities.
class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource _remoteDataSource;

  RoleRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Role>> getAllRoles() async {
    final models = await _remoteDataSource.getAllRoles();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Role>> getRolesByCompany(String companyId) async {
    final models = await _remoteDataSource.getRolesByCompany(companyId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateUserRole(String userId, String roleId) async {
    await _remoteDataSource.updateUserRole(userId, roleId);
  }

  @override
  Future<Role?> getRoleById(String roleId) async {
    final model = await _remoteDataSource.getRoleById(roleId);
    return model?.toEntity();
  }

  @override
  Future<Role?> getRoleByName(String roleName) async {
    final model = await _remoteDataSource.getRoleByName(roleName);
    return model?.toEntity();
  }
}
