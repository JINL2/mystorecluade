// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableCurrencyTypesHash() =>
    r'0bc38af3ea6a9d15f56120690d75329d64ac9d93';

/// Available currency types provider
///
/// Copied from [availableCurrencyTypes].
@ProviderFor(availableCurrencyTypes)
final availableCurrencyTypesProvider =
    AutoDisposeFutureProvider<List<CurrencyType>>.internal(
  availableCurrencyTypes,
  name: r'availableCurrencyTypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableCurrencyTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCurrencyTypesRef
    = AutoDisposeFutureProviderRef<List<CurrencyType>>;
String _$companyCurrenciesHash() => r'cbc75c99b2b3a0e929dd2c2d31edd560b37a2785';

/// Company currencies provider
///
/// Copied from [companyCurrencies].
@ProviderFor(companyCurrencies)
final companyCurrenciesProvider =
    AutoDisposeFutureProvider<List<Currency>>.internal(
  companyCurrencies,
  name: r'companyCurrenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyCurrenciesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCurrenciesRef = AutoDisposeFutureProviderRef<List<Currency>>;
String _$companyCurrenciesStreamHash() =>
    r'c0883cb98f5239dbd5685f1357b72d3be08bd5bb';

/// Company currencies stream provider for real-time updates
///
/// Copied from [companyCurrenciesStream].
@ProviderFor(companyCurrenciesStream)
final companyCurrenciesStreamProvider =
    AutoDisposeStreamProvider<List<Currency>>.internal(
  companyCurrenciesStream,
  name: r'companyCurrenciesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyCurrenciesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCurrenciesStreamRef
    = AutoDisposeStreamProviderRef<List<Currency>>;
String _$effectiveCompanyCurrenciesHash() =>
    r'dd72ae10b3ed5ba3cb18b049502bcb5e0c7ac4f4';

/// Effective company currencies provider that uses local state when available
///
/// Copied from [effectiveCompanyCurrencies].
@ProviderFor(effectiveCompanyCurrencies)
final effectiveCompanyCurrenciesProvider =
    AutoDisposeProvider<AsyncValue<List<Currency>>>.internal(
  effectiveCompanyCurrencies,
  name: r'effectiveCompanyCurrenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$effectiveCompanyCurrenciesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EffectiveCompanyCurrenciesRef
    = AutoDisposeProviderRef<AsyncValue<List<Currency>>>;
String _$searchFilteredCurrenciesHash() =>
    r'ccfa9ea8d61489558df2976dd8239b0f418376f8';

/// Combined provider that listens to search query changes and uses effective currencies
///
/// Copied from [searchFilteredCurrencies].
@ProviderFor(searchFilteredCurrencies)
final searchFilteredCurrenciesProvider =
    AutoDisposeProvider<AsyncValue<List<Currency>>>.internal(
  searchFilteredCurrencies,
  name: r'searchFilteredCurrenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchFilteredCurrenciesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchFilteredCurrenciesRef
    = AutoDisposeProviderRef<AsyncValue<List<Currency>>>;
String _$availableCurrenciesToAddHash() =>
    r'19539046b9ae269607369f86f783f1ebfadd4ffa';

/// Available currencies to add provider that filters out already added currencies
///
/// Copied from [availableCurrenciesToAdd].
@ProviderFor(availableCurrenciesToAdd)
final availableCurrenciesToAddProvider =
    AutoDisposeFutureProvider<List<CurrencyType>>.internal(
  availableCurrenciesToAdd,
  name: r'availableCurrenciesToAddProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableCurrenciesToAddHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCurrenciesToAddRef
    = AutoDisposeFutureProviderRef<List<CurrencyType>>;
String _$currencySearchHash() => r'b9faf7fb8ea2004b6212cd3a6c97bf90661099da';

/// Currency search notifier
///
/// Copied from [CurrencySearch].
@ProviderFor(CurrencySearch)
final currencySearchProvider = AutoDisposeNotifierProvider<CurrencySearch,
    AsyncValue<List<CurrencyType>>>.internal(
  CurrencySearch.new,
  name: r'currencySearchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencySearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencySearch = AutoDisposeNotifier<AsyncValue<List<CurrencyType>>>;
String _$selectedCurrencyTypeHash() =>
    r'c678bd779159fadd1410876901d9d0353c52f785';

/// Selected currency type for adding
///
/// Copied from [SelectedCurrencyType].
@ProviderFor(SelectedCurrencyType)
final selectedCurrencyTypeProvider =
    AutoDisposeNotifierProvider<SelectedCurrencyType, String?>.internal(
  SelectedCurrencyType.new,
  name: r'selectedCurrencyTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCurrencyTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCurrencyType = AutoDisposeNotifier<String?>;
String _$currencyOperationsHash() =>
    r'2d5ff0c14e27a30f062835828b7f29de4a93f4ee';

/// Currency operations notifier
///
/// Copied from [CurrencyOperations].
@ProviderFor(CurrencyOperations)
final currencyOperationsProvider =
    AutoDisposeNotifierProvider<CurrencyOperations, AsyncValue<void>>.internal(
  CurrencyOperations.new,
  name: r'currencyOperationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencyOperations = AutoDisposeNotifier<AsyncValue<void>>;
String _$expandedCurrenciesHash() =>
    r'1d83906893c40d1f92c6ecfbb8eee6305302f169';

/// Expanded currencies state (which currencies are expanded in the UI)
///
/// Copied from [ExpandedCurrencies].
@ProviderFor(ExpandedCurrencies)
final expandedCurrenciesProvider =
    AutoDisposeNotifierProvider<ExpandedCurrencies, Set<String>>.internal(
  ExpandedCurrencies.new,
  name: r'expandedCurrenciesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expandedCurrenciesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpandedCurrencies = AutoDisposeNotifier<Set<String>>;
String _$currencySearchQueryHash() =>
    r'07a30de1261850a89166d11cf181566eeaf049ee';

/// Search query provider with auto-dispose
///
/// Copied from [CurrencySearchQuery].
@ProviderFor(CurrencySearchQuery)
final currencySearchQueryProvider =
    AutoDisposeNotifierProvider<CurrencySearchQuery, String>.internal(
  CurrencySearchQuery.new,
  name: r'currencySearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencySearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencySearchQuery = AutoDisposeNotifier<String>;
String _$currencySearchControllerHash() =>
    r'f1e2609f6e07c2d669bfd92f640be855f74327a6';

/// Page-specific search controller provider that manages TossSearchField state
///
/// Copied from [CurrencySearchController].
@ProviderFor(CurrencySearchController)
final currencySearchControllerProvider = AutoDisposeNotifierProvider<
    CurrencySearchController, TextEditingController>.internal(
  CurrencySearchController.new,
  name: r'currencySearchControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencySearchControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencySearchController = AutoDisposeNotifier<TextEditingController>;
String _$localCurrencyListHash() => r'12846a6d325c84bef6f443fc0db96e8012cfe6b0';

/// Local currency list notifier for optimistic UI updates
///
/// Copied from [LocalCurrencyList].
@ProviderFor(LocalCurrencyList)
final localCurrencyListProvider =
    AutoDisposeNotifierProvider<LocalCurrencyList, List<Currency>?>.internal(
  LocalCurrencyList.new,
  name: r'localCurrencyListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localCurrencyListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalCurrencyList = AutoDisposeNotifier<List<Currency>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
