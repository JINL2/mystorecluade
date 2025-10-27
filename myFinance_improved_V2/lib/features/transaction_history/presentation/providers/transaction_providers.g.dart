// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupedTransactionsHash() =>
    r'741982c4dc1bbcc27855bee9b6007642ba74adf3';

/// Provider for grouping transactions by date
///
/// Copied from [groupedTransactions].
@ProviderFor(groupedTransactions)
final groupedTransactionsProvider =
    AutoDisposeProvider<Map<String, List<Transaction>>>.internal(
  groupedTransactions,
  name: r'groupedTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupedTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedTransactionsRef
    = AutoDisposeProviderRef<Map<String, List<Transaction>>>;
String _$transactionFilterOptionsHash() =>
    r'8cf8c73c4ae01b5a9eae7e485aae41953de4f4bb';

/// Provider for filter options (accounts, cash locations, counterparties, journal types)
///
/// Copied from [transactionFilterOptions].
@ProviderFor(transactionFilterOptions)
final transactionFilterOptionsProvider =
    AutoDisposeFutureProvider<FilterOptions>.internal(
  transactionFilterOptions,
  name: r'transactionFilterOptionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionFilterOptionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionFilterOptionsRef
    = AutoDisposeFutureProviderRef<FilterOptions>;
String _$transactionHistoryHash() =>
    r'414a3d9f2548abd13b779d5da65bd24b2d3fd144';

/// Provider for transaction history with filtering support
///
/// Copied from [TransactionHistory].
@ProviderFor(TransactionHistory)
final transactionHistoryProvider = AutoDisposeAsyncNotifierProvider<
    TransactionHistory, List<Transaction>>.internal(
  TransactionHistory.new,
  name: r'transactionHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionHistory = AutoDisposeAsyncNotifier<List<Transaction>>;
String _$transactionFilterStateHash() =>
    r'700feef23ff0234a80cb59f0f4e87e2b3f9483cf';

/// Provider for current filter state
///
/// Copied from [TransactionFilterState].
@ProviderFor(TransactionFilterState)
final transactionFilterStateProvider = AutoDisposeNotifierProvider<
    TransactionFilterState, TransactionFilter>.internal(
  TransactionFilterState.new,
  name: r'transactionFilterStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionFilterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionFilterState = AutoDisposeNotifier<TransactionFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
