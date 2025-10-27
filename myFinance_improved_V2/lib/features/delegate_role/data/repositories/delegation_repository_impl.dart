import '../../domain/entities/delegation_audit.dart';
import '../../domain/entities/role_delegation.dart';
import '../../domain/repositories/delegation_repository.dart';
import '../datasources/delegation_remote_data_source.dart';

/// Implementation of DelegationRepository
class DelegationRepositoryImpl implements DelegationRepository {
  final DelegationRemoteDataSource _remoteDataSource;

  DelegationRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<RoleDelegation>> getActiveDelegations(
    String userId,
    String companyId,
  ) async {
    final models = await _remoteDataSource.getActiveDelegations(
      userId,
      companyId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<DelegationAudit>> getDelegationHistory(String companyId) async {
    final models = await _remoteDataSource.getDelegationHistory(companyId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createDelegation({
    required String delegateId,
    required String roleId,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _remoteDataSource.createDelegation(
      delegateId: delegateId,
      roleId: roleId,
      permissions: permissions,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> revokeDelegation(String delegationId) async {
    return await _remoteDataSource.revokeDelegation(delegationId);
  }
}
