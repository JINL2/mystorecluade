// lib/features/cash_ending/data/repositories/vault_repository_impl.dart

import '../../domain/entities/vault_transaction.dart';
import '../../domain/repositories/vault_repository.dart';
import '../datasources/vault_remote_datasource.dart';
import '../models/freezed/vault_transaction_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Vault operations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
class VaultRepositoryImpl extends BaseRepository implements VaultRepository {
  final VaultRemoteDataSource _remoteDataSource;

  VaultRepositoryImpl({
    VaultRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? VaultRemoteDataSource();

  @override
  Future<void> saveVaultTransaction(VaultTransaction transaction) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = VaultTransactionDto.fromEntity(transaction);

        // Prepare RPC parameters
        final params = dto.toRpcParams();

        // Call remote datasource
        await _remoteDataSource.saveVaultTransaction(params);
      },
      operationName: 'saveVaultTransaction',
    );
  }

  @override
  Future<List<VaultTransaction>> getVaultTransactionHistory({
    required String locationId,
    int limit = 10,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getVaultTransactionHistory(
          locationId: locationId,
          limit: limit,
        );

        // Convert JSON to DTOs then to entities
        return data
            .map((json) => VaultTransactionDto.fromJson(json).toEntity())
            .toList();
      },
      operationName: 'getVaultTransactionHistory',
    );
  }
}
