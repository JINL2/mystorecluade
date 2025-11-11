// lib/features/cash_ending/data/repositories/vault_repository_impl.dart

import '../../domain/entities/vault_transaction.dart';
import '../../domain/repositories/vault_repository.dart';
import '../datasources/vault_remote_datasource.dart';
import '../models/vault_transaction_model.dart';

/// Repository Implementation for Vault operations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping.
class VaultRepositoryImpl implements VaultRepository {
  final VaultRemoteDataSource _remoteDataSource;

  VaultRepositoryImpl({
    VaultRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? VaultRemoteDataSource();

  @override
  Future<void> saveVaultTransaction(VaultTransaction transaction) async {
    try {
      // Convert entity to model
      final model = VaultTransactionModel.fromEntity(transaction);

      // Prepare RPC parameters
      final params = model.toRpcParams();

      // Call remote datasource
      await _remoteDataSource.saveVaultTransaction(params);
    } catch (e) {
      // Map to domain exception if needed
      throw Exception('Failed to save vault transaction: $e');
    }
  }

  @override
  Future<List<VaultTransaction>> getVaultTransactionHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      // Call remote datasource
      final data = await _remoteDataSource.getVaultTransactionHistory(
        locationId: locationId,
        limit: limit,
      );

      // Convert JSON to models then to entities
      return data
          .map((json) => VaultTransactionModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch vault transaction history: $e');
    }
  }
}
