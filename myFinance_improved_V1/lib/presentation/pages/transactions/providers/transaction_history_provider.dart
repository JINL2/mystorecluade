import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/models/transaction_history_model.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../providers/app_state_provider.dart';

part 'transaction_history_provider.g.dart';

@riverpod
class TransactionHistory extends _$TransactionHistory {
  static const int _pageSize = 50;
  
  @override
  Future<List<TransactionData>> build() async {
    return _fetchTransactions();
  }

  Future<List<TransactionData>> _fetchTransactions({
    TransactionFilter? filter,
    int offset = 0,
  }) async {
    try {
      
      final supabase = ref.read(supabaseServiceProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);
      final selectedCompany = appStateNotifier.selectedCompany;
      final selectedStore = appStateNotifier.selectedStore;
      
      
      if (selectedCompany == null) {
        throw Exception('No company selected');
      }

      // Determine store_id based on scope
      final storeId = filter?.scope == TransactionScope.company 
        ? null  // NULL means show all stores in company
        : selectedStore?['store_id'];  // Show only current store
      
      final params = {
        'p_company_id': selectedCompany['company_id'],
        'p_store_id': storeId,
        'p_date_from': filter?.dateFrom?.toIso8601String(),
        'p_date_to': filter?.dateTo?.toIso8601String(),
        'p_account_id': filter?.accountId,
        'p_account_ids': filter?.accountIds?.join(','), // Convert to comma-separated string
        'p_cash_location_id': filter?.cashLocationId,
        'p_counterparty_id': filter?.counterpartyId,
        'p_journal_type': filter?.journalType,
        'p_created_by': filter?.createdBy,
        'p_limit': _pageSize,
        'p_offset': offset,
      };
      
      
      final response = await supabase.client.rpc(
        'get_transaction_history',
        params: params,
      );

      
      if (response == null) {
        return [];
      }

      // Handle different response types
      List<dynamic> dataList;
      if (response is List) {
        dataList = response;
      } else if (response is Map && response.containsKey('data')) {
        dataList = response['data'] as List;
      } else {
        return [];
      }
      
      
      final transactions = <TransactionData>[];
      for (int i = 0; i < dataList.length; i++) {
        try {
          final json = dataList[i] as Map<String, dynamic>;
          final transaction = TransactionData.fromJson(json);
          transactions.add(transaction);
        } catch (e) {
          // Skip invalid transaction
        }
      }
      
      return transactions;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions());
  }

  Future<void> applyFilter(TransactionFilter filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions(filter: filter));
  }

  Future<void> loadMore() async {
    final currentData = state.valueOrNull ?? [];
    if (currentData.isEmpty) return;

    try {
      final moreData = await _fetchTransactions(
        offset: currentData.length,
      );
      
      if (moreData.isNotEmpty) {
        state = AsyncValue.data([...currentData, ...moreData]);
      }
    } catch (e) {
      // Keep existing data even if loading more fails
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> searchTransactions(String query) async {
    if (query.isEmpty) {
      await refresh();
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final allTransactions = await _fetchTransactions();
      
      return allTransactions.where((transaction) {
        final searchLower = query.toLowerCase();
        
        // Search in description
        if (transaction.description.toLowerCase().contains(searchLower)) {
          return true;
        }
        
        // Search in journal number
        if (transaction.journalNumber.toLowerCase().contains(searchLower)) {
          return true;
        }
        
        // Search in account names
        if (transaction.lines.any((line) => 
            line.accountName.toLowerCase().contains(searchLower))) {
          return true;
        }
        
        // Search in counterparty names
        if (transaction.lines.any((line) => 
            (line.counterparty?['name'] as String?)?.toLowerCase().contains(searchLower) ?? false)) {
          return true;
        }
        
        // Search in cash location names
        if (transaction.lines.any((line) => 
            (line.cashLocation?['name'] as String?)?.toLowerCase().contains(searchLower) ?? false)) {
          return true;
        }
        
        return false;
      }).toList();
    });
  }
}

// Provider for current filter
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

// Provider for grouping transactions by date
@riverpod
Map<String, List<TransactionData>> groupedTransactions(GroupedTransactionsRef ref) {
  final transactions = ref.watch(transactionHistoryProvider).valueOrNull ?? [];
  
  final Map<String, List<TransactionData>> grouped = {};
  
  for (final transaction in transactions) {
    final dateKey = '${transaction.entryDate.year}-${transaction.entryDate.month.toString().padLeft(2, '0')}-${transaction.entryDate.day.toString().padLeft(2, '0')}';
    grouped.putIfAbsent(dateKey, () => []).add(transaction);
  }
  
  return grouped;
}

// Provider for filter options (accounts, cash locations, counterparties, journal types)
@riverpod
Future<TransactionFilterOptions> transactionFilterOptions(TransactionFilterOptionsRef ref) async {
  try {
    final supabase = ref.read(supabaseServiceProvider);
    final appStateNotifier = ref.read(appStateProvider.notifier);
    final selectedCompany = appStateNotifier.selectedCompany;
    final selectedStore = appStateNotifier.selectedStore;
    
    if (selectedCompany == null) {
      return const TransactionFilterOptions();
    }

    final params = {
      'p_company_id': selectedCompany['company_id'],
      'p_store_id': selectedStore?['store_id'],
    };
    
    final response = await supabase.client.rpc(
      'get_transaction_filter_options',
      params: params,
    );

    if (response == null) {
      return const TransactionFilterOptions();
    }

    final data = response as Map<String, dynamic>;
    
    final options = TransactionFilterOptions(
      stores: (data['stores'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      accounts: (data['accounts'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      cashLocations: (data['cash_locations'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      counterparties: (data['counterparties'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      journalTypes: (data['journal_types'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      users: (data['users'] as List<dynamic>? ?? [])
          .map((item) => FilterOption.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    
    return options;
  } catch (e) {
    return const TransactionFilterOptions();
  }
}