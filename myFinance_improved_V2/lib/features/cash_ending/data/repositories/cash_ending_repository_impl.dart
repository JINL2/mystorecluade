// lib/features/cash_ending/data/repositories/cash_ending_repository_impl.dart

import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/balance_summary.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../datasources/cash_ending_remote_datasource.dart';
import '../models/freezed/cash_ending_dto.dart';
import '../models/freezed/balance_summary_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Cash Ending (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
class CashEndingRepositoryImpl extends BaseRepository
    implements CashEndingRepository {
  final CashEndingRemoteDataSource _remoteDataSource;

  CashEndingRepositoryImpl({
    CashEndingRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CashEndingRemoteDataSource();

  @override
  Future<CashEnding> saveCashEnding(CashEnding cashEnding) async {
    return executeWithErrorHandling(
      () async {
        // Convert entity to DTO
        final dto = CashEndingDto.fromEntity(cashEnding);

        // Prepare RPC parameters
        final params = dto.toRpcParams();

        // Call remote datasource
        await _remoteDataSource.saveCashEnding(params);

        // RPC returns null on success, return the entity
        return cashEnding;
      },
      operationName: 'saveCashEnding',
    );
  }

  @override
  Future<BalanceSummary> getBalanceSummary({
    required String locationId,
  }) async {
    return executeWithErrorHandling(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getBalanceSummary(
          locationId: locationId,
        );

        // Convert JSON to DTO then to entity
        final dto = BalanceSummaryDto.fromJson(data);
        return dto.toEntity();
      },
      operationName: 'getBalanceSummary',
    );
  }
}
