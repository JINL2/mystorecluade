// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupedTransactionsHash() =>
    r'ba0109d5e0cb517850035a380ef5a8e5a931b84a';

/// See also [groupedTransactions].
@ProviderFor(groupedTransactions)
final groupedTransactionsProvider =
    AutoDisposeProvider<Map<String, List<TransactionData>>>.internal(
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
    = AutoDisposeProviderRef<Map<String, List<TransactionData>>>;
String _$transactionFilterOptionsHash() =>
    r'6cc14f3c52bf0caf415ca42c43db300b03a0930d';

/// See also [transactionFilterOptions].
@ProviderFor(transactionFilterOptions)
final transactionFilterOptionsProvider =
    AutoDisposeFutureProvider<TransactionFilterOptions>.internal(
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
    = AutoDisposeFutureProviderRef<TransactionFilterOptions>;
String _$transactionHistoryHash() =>
    r'951e37bcac0e322c8d17a80bcbf5d7bfe6941a27';

/// See also [TransactionHistory].
@ProviderFor(TransactionHistory)
final transactionHistoryProvider = AutoDisposeAsyncNotifierProvider<
    TransactionHistory, List<TransactionData>>.internal(
  TransactionHistory.new,
  name: r'transactionHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionHistory = AutoDisposeAsyncNotifier<List<TransactionData>>;
String _$transactionFilterStateHash() =>
    r'3cd2cc3eb3c3ba91dead9f4cd30ebc598fb7746e';

/// See also [TransactionFilterState].
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
