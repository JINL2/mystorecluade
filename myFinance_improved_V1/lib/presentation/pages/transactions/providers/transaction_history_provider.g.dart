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
    r'2c3373e137b426899f0fe840f65e9a7920445e83';

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
    r'4e9dddba08778ee1fd63bf046174946542e4ca58';

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
    r'700feef23ff0234a80cb59f0f4e87e2b3f9483cf';

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
