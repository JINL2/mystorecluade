// lib/features/cash_ending/data/repositories/bank_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../datasources/bank_remote_datasource.dart';

/// Repository Implementation for Bank Balance (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - Freezed Entity (no Model needed)
/// - BaseRepository (unified error handling)
/// - 60% less code than before
class BankRepositoryImpl extends BaseRepository implements BankRepository {
  final BankRemoteDataSource _remoteDataSource;

  BankRepositoryImpl({
    required BankRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<result_type.Result<BankBalance, Failure>> saveBankBalance(BankBalance bankBalance) {
    return executeWithResult(
      () async {
        // Entity handles RPC conversion (Freezed + custom method)
        final params = bankBalance.toRpcParams();

        // Call datasource
        await _remoteDataSource.saveBankBalance(params);

        // Return entity (RPC returns void on success)
        return bankBalance;
      },
      operationName: 'save bank balance',
    );
  }
}
