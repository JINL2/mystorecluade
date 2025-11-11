// lib/features/cash_ending/data/repositories/bank_repository_impl.dart

import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../datasources/bank_remote_datasource.dart';
import '../models/freezed/bank_balance_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Bank operations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
class BankRepositoryImpl extends BaseRepository implements BankRepository {
  final BankRemoteDataSource _remoteDataSource;

  BankRepositoryImpl({
    BankRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? BankRemoteDataSource();

  @override
  Future<void> saveBankBalance(BankBalance balance) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = BankBalanceDto.fromEntity(balance);

        // Prepare RPC parameters
        final params = dto.toRpcParams();

        // Call remote datasource
        await _remoteDataSource.saveBankBalance(params);
      },
      operationName: 'saveBankBalance',
    );
  }

  @override
  Future<List<BankBalance>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getBankBalanceHistory(
          locationId: locationId,
          limit: limit,
        );

        // Convert JSON to DTOs then to entities
        return data
            .map((json) => BankBalanceDto.fromJson(json).toEntity())
            .toList();
      },
      operationName: 'getBankBalanceHistory',
    );
  }
}
