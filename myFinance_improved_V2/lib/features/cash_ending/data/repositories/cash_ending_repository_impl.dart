// lib/features/cash_ending/data/repositories/cash_ending_repository_impl.dart

import '../../domain/entities/cash_ending.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/exceptions/cash_ending_exception.dart';
import '../datasources/cash_ending_remote_datasource.dart';
import '../models/cash_ending_model.dart';

/// Repository Implementation for Cash Ending (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping.
class CashEndingRepositoryImpl implements CashEndingRepository {
  final CashEndingRemoteDataSource _remoteDataSource;

  CashEndingRepositoryImpl({
    CashEndingRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CashEndingRemoteDataSource();

  @override
  Future<CashEnding> saveCashEnding(CashEnding cashEnding) async {
    try {
      // Note: Allow saving even with 0 denominations (cash can be 0)
      // Removed validation: if (!cashEnding.hasData) throw NoDenominationsException();

      // Convert entity to model
      final model = CashEndingModel.fromEntity(cashEnding);

      // Prepare RPC parameters
      final params = model.toRpcParams();

      // Call remote datasource
      await _remoteDataSource.saveCashEnding(params);

      // RPC returns null on success, return the entity
      return cashEnding;
    } catch (e) {
      if (e is CashEndingException) {
        rethrow;
      }
      throw SaveFailedException(
        'Failed to save cash ending',
        originalError: e,
      );
    }
  }

  @override
  Future<List<CashEnding>> getCashEndingHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      // Call remote datasource
      final data = await _remoteDataSource.getCashEndingHistory(
        locationId: locationId,
        limit: limit,
      );

      // Convert JSON to models then to entities
      return data.map((json) => CashEndingModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch cash ending history',
        originalError: e,
      );
    }
  }
}
