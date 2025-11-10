// lib/features/cash_ending/data/repositories/vault_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../../domain/entities/vault_transaction.dart';
import '../../domain/repositories/vault_repository.dart';
import '../datasources/vault_remote_datasource.dart';

/// Repository Implementation for Vault Transaction (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - Freezed Entity (no Model needed)
/// - BaseRepository (unified error handling)
/// - 60% less code than before
class VaultRepositoryImpl extends BaseRepository implements VaultRepository {
  final VaultRemoteDataSource _remoteDataSource;

  VaultRepositoryImpl({
    required VaultRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<result_type.Result<VaultTransaction, Failure>> saveVaultTransaction(VaultTransaction vaultTransaction) {
    return executeWithResult(
      () async {
        // Entity handles RPC conversion (Freezed + custom method)
        final params = vaultTransaction.toRpcParams();

        // Call datasource
        await _remoteDataSource.saveVaultTransaction(params);

        // Return entity (RPC returns void on success)
        return vaultTransaction;
      },
      operationName: 'save vault transaction',
    );
  }
}
