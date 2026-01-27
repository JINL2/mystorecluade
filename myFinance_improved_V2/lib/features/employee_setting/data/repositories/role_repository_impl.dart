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
  Future<void> updateUserRole({
    required String companyId,
    required String userId,
    required String roleId,
  }) async {
    await _remoteDataSource.updateUserRole(
      companyId: companyId,
      userId: userId,
      roleId: roleId,
    );
  }
}
