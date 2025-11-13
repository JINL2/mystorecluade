import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_extensions.dart';

part 'transaction_history_state.freezed.dart';

/// Transaction History Page State - UI state for transaction history page
///
/// Manages the overall state of the transaction history page including
/// loading states, errors, transaction list data, and pagination.
@freezed
class TransactionHistoryState with _$TransactionHistoryState {
  const TransactionHistoryState._();

  const factory TransactionHistoryState({
    /// List of transactions
    @Default([]) List<Transaction> transactions,

    /// Loading state for initial fetch
    @Default(false) bool isLoading,

    /// Loading state for loading more transactions (pagination)
    @Default(false) bool isLoadingMore,

    /// Refreshing state
    @Default(false) bool isRefreshing,

    /// Error message if any error occurred
    String? errorMessage,

    /// Whether there are more transactions to load
    @Default(true) bool hasMore,

    /// Current offset for pagination
    @Default(0) int currentOffset,

    /// Page size for pagination
    @Default(20) int pageSize,
  }) = _TransactionHistoryState;

  /// Initial state
  factory TransactionHistoryState.initial() => const TransactionHistoryState();

  /// Loading state
  factory TransactionHistoryState.loading() => const TransactionHistoryState(
        isLoading: true,
      );

  /// Success state with transactions
  factory TransactionHistoryState.success(List<Transaction> transactions) =>
      TransactionHistoryState(
        transactions: transactions,
        isLoading: false,
        currentOffset: transactions.length,
      );

  /// Error state
  factory TransactionHistoryState.error(String message) =>
      TransactionHistoryState(
        errorMessage: message,
        isLoading: false,
      );

  /// Check if can load more
  bool get canLoadMore => hasMore && !isLoadingMore && !isLoading;

  /// Get total transaction count
  int get totalCount => transactions.length;
}

/// Grouped Transactions State - Groups transactions by date
///
/// Helper state for displaying transactions grouped by date.
@freezed
class GroupedTransactionsState with _$GroupedTransactionsState {
  const factory GroupedTransactionsState({
    @Default({}) Map<String, List<Transaction>> groupedByDate,
    @Default([]) List<String> sortedDates,
  }) = _GroupedTransactionsState;

  /// Initial state
  factory GroupedTransactionsState.initial() =>
      const GroupedTransactionsState();

  /// Create from transaction list
  factory GroupedTransactionsState.fromTransactions(
      List<Transaction> transactions,) {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      final dateKey = transaction.entryDate.toDateKey();
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return GroupedTransactionsState(
      groupedByDate: grouped,
      sortedDates: sortedDates,
    );
  }
}
