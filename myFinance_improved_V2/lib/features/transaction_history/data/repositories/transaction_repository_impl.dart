import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_datasource.dart';
import '../models/filter_options_model.dart';
import '../models/transaction_model.dart';

/// Implementation of TransactionRepository
/// Coordinates between datasource and domain layer
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource _dataSource;
  final String Function() _getCompanyId;
  final String? Function() _getStoreId;

  TransactionRepositoryImpl({
    required TransactionDataSource dataSource,
    required String Function() getCompanyId,
    required String? Function() getStoreId,
  })  : _dataSource = dataSource,
        _getCompanyId = getCompanyId,
        _getStoreId = getStoreId;

  @override
  Future<List<Transaction>> fetchTransactions({
    required TransactionFilter filter,
  }) async {
    final companyId = _getCompanyId();
    final storeId = _getStoreId();

    final models = await _dataSource.getTransactionHistory(
      companyId: companyId,
      storeId: storeId,
      filter: filter,
    );

    // Convert models to entities
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<FilterOptions> getFilterOptions() async {
    final companyId = _getCompanyId();
    final storeId = _getStoreId();

    final model = await _dataSource.getFilterOptions(
      companyId: companyId,
      storeId: storeId,
    );

    // Convert model to entity
    return model.toEntity();
  }

  @override
  Future<List<Transaction>> refreshTransactions({
    required TransactionFilter filter,
  }) async {
    // Reset offset for refresh
    final refreshFilter = filter.copyWith(offset: 0);
    return fetchTransactions(filter: refreshFilter);
  }

  @override
  Future<List<Transaction>> loadMoreTransactions({
    required TransactionFilter filter,
    required int offset,
  }) async {
    // Update offset for pagination
    final paginatedFilter = filter.copyWith(offset: offset);
    return fetchTransactions(filter: paginatedFilter);
  }
}
