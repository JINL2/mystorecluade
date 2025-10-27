import '../entities/transaction.dart';
import '../entities/transaction_filter.dart';

/// Abstract repository interface for transaction operations
/// This defines the contract that the data layer must implement
abstract class TransactionRepository {
  /// Fetch transactions based on filter criteria
  /// Returns a list of transactions matching the filter
  Future<List<Transaction>> fetchTransactions({
    required TransactionFilter filter,
  });

  /// Get available filter options (accounts, cash locations, etc.)
  /// Returns filter options based on current company/store context
  Future<FilterOptions> getFilterOptions();

  /// Refresh transaction data
  /// Returns updated list of transactions
  Future<List<Transaction>> refreshTransactions({
    required TransactionFilter filter,
  });

  /// Load more transactions for pagination
  /// Returns additional transactions based on offset
  Future<List<Transaction>> loadMoreTransactions({
    required TransactionFilter filter,
    required int offset,
  });
}
