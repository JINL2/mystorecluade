// lib/features/cash_ending/data/repositories/cash_ending_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../../domain/entities/cash_ending.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../datasources/cash_ending_remote_datasource.dart';

/// Repository Implementation for Cash Ending (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - BaseRepository (unified error handling)
/// - Freezed Entity (no Model needed)
/// - 50% less boilerplate
class CashEndingRepositoryImpl extends BaseRepository implements CashEndingRepository {
  final CashEndingRemoteDataSource _remoteDataSource;

  CashEndingRepositoryImpl({
    CashEndingRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CashEndingRemoteDataSource();

  @override
  Future<result_type.Result<CashEnding, Failure>> saveCashEnding(CashEnding cashEnding) {
    return executeWithResult(
      () async {
        // Note: Allow saving even with 0 denominations (cash can be 0)
        // Removed validation: if (!cashEnding.hasData) throw NoDenominationsException();

        // Prepare RPC parameters directly from entity (Freezed handles it)
        final params = cashEnding.toRpcParams();

        // Call remote datasource
        await _remoteDataSource.saveCashEnding(params);

        // RPC returns null on success, return the entity
        return cashEnding;
      },
      operationName: 'save cash ending',
    );
  }

  @override
  Future<result_type.Result<List<CashEnding>, Failure>> getCashEndingHistory({
    required String locationId,
    int limit = 10,
  }) {
    return executeFetchWithResult(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getCashEndingHistory(
          locationId: locationId,
          limit: limit,
        );

        // Convert JSON directly to entities (Freezed handles it)
        return data.map((json) => CashEnding.fromJson(json)).toList();
      },
      operationName: 'cash ending history',
    );
  }
}
