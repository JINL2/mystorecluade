// lib/features/cash_ending/data/repositories/bank_repository_impl.dart

import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../datasources/bank_remote_datasource.dart';
import '../models/bank_balance_model.dart';

/// Repository Implementation for Bank operations (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping.
class BankRepositoryImpl implements BankRepository {
  final BankRemoteDataSource _remoteDataSource;

  BankRepositoryImpl({
    BankRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? BankRemoteDataSource();

  @override
  Future<void> saveBankBalance(BankBalance balance) async {
    try {
      // Convert entity to model
      final model = BankBalanceModel.fromEntity(balance);

      // Prepare RPC parameters
      final params = model.toRpcParams();

      // Call remote datasource
      await _remoteDataSource.saveBankBalance(params);
    } catch (e) {
      // Map to domain exception if needed
      throw Exception('Failed to save bank balance: $e');
    }
  }

  @override
  Future<List<BankBalance>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      // Call remote datasource
      final data = await _remoteDataSource.getBankBalanceHistory(
        locationId: locationId,
        limit: limit,
      );

      // Convert JSON to models then to entities
      return data
          .map((json) => BankBalanceModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bank balance history: $e');
    }
  }
}
