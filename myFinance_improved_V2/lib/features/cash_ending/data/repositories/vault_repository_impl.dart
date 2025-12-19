// lib/features/cash_ending/data/repositories/vault_repository_impl.dart

import '../../domain/entities/vault_transaction.dart';
import '../../domain/entities/vault_recount.dart';
import '../../domain/entities/balance_summary.dart';
import '../../domain/entities/multi_currency_recount.dart';
import '../../domain/repositories/vault_repository.dart';
import '../datasources/vault_remote_datasource.dart';
import '../datasources/cash_ending_remote_datasource.dart';
import '../models/freezed/vault_transaction_dto.dart';
import '../models/freezed/vault_recount_dto.dart';
import '../models/freezed/balance_summary_dto.dart';
import '../models/freezed/multi_currency_recount_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Vault operations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
class VaultRepositoryImpl extends BaseRepository implements VaultRepository {
  final VaultRemoteDataSource _remoteDataSource;
  final CashEndingRemoteDataSource _cashEndingDataSource;

  VaultRepositoryImpl({
    VaultRemoteDataSource? remoteDataSource,
    CashEndingRemoteDataSource? cashEndingDataSource,
  })  : _remoteDataSource = remoteDataSource ?? VaultRemoteDataSource(),
        _cashEndingDataSource =
            cashEndingDataSource ?? CashEndingRemoteDataSource();

  @override
  Future<void> saveVaultTransaction(VaultTransaction transaction) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = VaultTransactionDto.fromEntity(transaction);

        // Prepare RPC parameters with transaction type
        final params = dto.toRpcParams(
          transactionType: transaction.transactionType, // 'in' or 'out'
        );

        // Call remote datasource (universal RPC)
        await _remoteDataSource.saveVaultTransaction(params);
      },
      operationName: 'saveVaultTransaction',
    );
  }

  @override
  Future<Map<String, dynamic>> recountVault(VaultRecount recount) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = VaultRecountDto.fromEntity(recount);

        // Prepare RPC parameters
        final params = dto.toRpcParams();

        // Call remote datasource and get response
        final response = await _remoteDataSource.saveVaultTransaction(params);

        // Return response as-is (contains adjustment details)
        return response ?? {};
      },
      operationName: 'recountVault',
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

  @override
  Future<BalanceSummary> getBalanceSummary({
    required String locationId,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Call balance summary RPC
        final data = await _cashEndingDataSource.getBalanceSummary(
          locationId: locationId,
        );

        // Convert JSON to DTO then to entity
        return BalanceSummaryDto.fromJson(data).toEntity();
      },
      operationName: 'getBalanceSummary',
    );
  }

  @override
  Future<void> executeMultiCurrencyRecount(MultiCurrencyRecount recount) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = MultiCurrencyRecountDto.fromEntity(recount);

        // Prepare RPC parameters
        final rpcParams = dto.toRpcParams();

        // Call RPC through cash ending datasource (universal RPC)
        final response = await _cashEndingDataSource.saveCashEnding(rpcParams);

        if (response == null) {
          throw Exception('RPC returned null response');
        }

        // Response contains: entry_id, balance_before, balance_after, net_cash_flow
        // We don't need to process it further for RECOUNT
      },
      operationName: 'executeMultiCurrencyRecount',
    );
  }
}
