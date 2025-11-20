import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_extensions.dart';
import '../../domain/entities/transaction_filter.dart';

part 'transaction_providers.g.dart';

/// Provider for transaction history with filtering support
@riverpod
class TransactionHistory extends _$TransactionHistory {
  @override
  Future<List<Transaction>> build() async {
    // Watch the filter state to rebuild when it changes
    final filter = ref.watch(transactionFilterStateProvider);
    return _fetchTransactions(filter: filter);
  }

  Future<List<Transaction>> _fetchTransactions({
    required TransactionFilter filter,
  }) async {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.fetchTransactions(filter: filter);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final filter = ref.read(transactionFilterStateProvider);
    state = await AsyncValue.guard(() => _fetchTransactions(filter: filter));
  }

  Future<void> applyFilter(TransactionFilter filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions(filter: filter));
  }

  Future<void> loadMore() async {
    final currentData = state.valueOrNull ?? [];
    if (currentData.isEmpty) return;

    try {
      final filter = ref.read(transactionFilterStateProvider);
      final repository = ref.read(transactionRepositoryProvider);

      final moreData = await repository.loadMoreTransactions(
        filter: filter,
        offset: currentData.length,
      );

      if (moreData.isNotEmpty) {
        state = AsyncValue.data([...currentData, ...moreData]);
      }
    } catch (e, stackTrace) {
      // Keep existing data even if loading more fails
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Provider for current filter state
@riverpod
class TransactionFilterState extends _$TransactionFilterState {
  @override
  TransactionFilter build() {
    return const TransactionFilter();
  }

  void updateFilter(TransactionFilter filter) {
    state = filter;
    ref.read(transactionHistoryProvider.notifier).applyFilter(filter);
  }

  void clearFilter() {
    state = const TransactionFilter();
    ref.read(transactionHistoryProvider.notifier).refresh();
  }

  void setDateRange(DateTime from, DateTime to) {
    state = state.copyWith(
      dateFrom: from,
      dateTo: to,
    );
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setAccount(String? accountId) {
    state = state.copyWith(accountId: accountId);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setCashLocation(String? cashLocationId) {
    state = state.copyWith(cashLocationId: cashLocationId);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setCounterparty(String? counterpartyId) {
    state = state.copyWith(counterpartyId: counterpartyId);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setCreatedBy(String? userId) {
    state = state.copyWith(createdBy: userId);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setAccountIds(List<String>? accountIds) {
    state = state.copyWith(accountIds: accountIds, accountId: null);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }

  void setScope(TransactionScope scope) {
    state = state.copyWith(scope: scope);
    ref.read(transactionHistoryProvider.notifier).applyFilter(state);
  }
}

/// Provider for grouping transactions by date
@riverpod
Map<String, List<Transaction>> groupedTransactions(GroupedTransactionsRef ref) {
  final transactions = ref.watch(transactionHistoryProvider).valueOrNull ?? [];

  final Map<String, List<Transaction>> grouped = {};

  for (final transaction in transactions) {
    final dateKey = transaction.entryDate.toDateKey();
    grouped.putIfAbsent(dateKey, () => []).add(transaction);
  }

  return grouped;
}

/// Provider for filter options (accounts, cash locations, counterparties, journal types)
@riverpod
Future<FilterOptions> transactionFilterOptions(TransactionFilterOptionsRef ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getFilterOptions();
}
