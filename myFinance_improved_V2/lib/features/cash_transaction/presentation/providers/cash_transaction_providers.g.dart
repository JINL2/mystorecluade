// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cashTransactionDataSourceHash() =>
    r'3494748d81d382cb62ee43de5f0b724dca72a072';

/// Data source provider
///
/// Copied from [cashTransactionDataSource].
@ProviderFor(cashTransactionDataSource)
final cashTransactionDataSourceProvider =
    AutoDisposeProvider<CashTransactionDataSource>.internal(
  cashTransactionDataSource,
  name: r'cashTransactionDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashTransactionDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CashTransactionDataSourceRef
    = AutoDisposeProviderRef<CashTransactionDataSource>;
String _$cashTransactionRepositoryHash() =>
    r'2b5f3ea50e3abfd6b6579a6f5f5c277d4f7bcde4';

/// Repository provider
///
/// Copied from [cashTransactionRepository].
@ProviderFor(cashTransactionRepository)
final cashTransactionRepositoryProvider =
    AutoDisposeProvider<CashTransactionRepository>.internal(
  cashTransactionRepository,
  name: r'cashTransactionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cashTransactionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CashTransactionRepositoryRef
    = AutoDisposeProviderRef<CashTransactionRepository>;
String _$expenseAccountsHash() => r'06809539cf9fe99cb2ca88dd5e53bc552301a04b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Quick access expense accounts provider (user's most used accounts)
/// Note: This includes ALL account types the user frequently uses
/// For expense-only accounts, use expenseAccountsOnlyProvider
///
/// Copied from [expenseAccounts].
@ProviderFor(expenseAccounts)
const expenseAccountsProvider = ExpenseAccountsFamily();

/// Quick access expense accounts provider (user's most used accounts)
/// Note: This includes ALL account types the user frequently uses
/// For expense-only accounts, use expenseAccountsOnlyProvider
///
/// Copied from [expenseAccounts].
class ExpenseAccountsFamily extends Family<AsyncValue<List<ExpenseAccount>>> {
  /// Quick access expense accounts provider (user's most used accounts)
  /// Note: This includes ALL account types the user frequently uses
  /// For expense-only accounts, use expenseAccountsOnlyProvider
  ///
  /// Copied from [expenseAccounts].
  const ExpenseAccountsFamily();

  /// Quick access expense accounts provider (user's most used accounts)
  /// Note: This includes ALL account types the user frequently uses
  /// For expense-only accounts, use expenseAccountsOnlyProvider
  ///
  /// Copied from [expenseAccounts].
  ExpenseAccountsProvider call({
    required String companyId,
    required String userId,
  }) {
    return ExpenseAccountsProvider(
      companyId: companyId,
      userId: userId,
    );
  }

  @override
  ExpenseAccountsProvider getProviderOverride(
    covariant ExpenseAccountsProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
      userId: provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseAccountsProvider';
}

/// Quick access expense accounts provider (user's most used accounts)
/// Note: This includes ALL account types the user frequently uses
/// For expense-only accounts, use expenseAccountsOnlyProvider
///
/// Copied from [expenseAccounts].
class ExpenseAccountsProvider
    extends AutoDisposeFutureProvider<List<ExpenseAccount>> {
  /// Quick access expense accounts provider (user's most used accounts)
  /// Note: This includes ALL account types the user frequently uses
  /// For expense-only accounts, use expenseAccountsOnlyProvider
  ///
  /// Copied from [expenseAccounts].
  ExpenseAccountsProvider({
    required String companyId,
    required String userId,
  }) : this._internal(
          (ref) => expenseAccounts(
            ref as ExpenseAccountsRef,
            companyId: companyId,
            userId: userId,
          ),
          from: expenseAccountsProvider,
          name: r'expenseAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseAccountsHash,
          dependencies: ExpenseAccountsFamily._dependencies,
          allTransitiveDependencies:
              ExpenseAccountsFamily._allTransitiveDependencies,
          companyId: companyId,
          userId: userId,
        );

  ExpenseAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
    required this.userId,
  }) : super.internal();

  final String companyId;
  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseAccount>> Function(ExpenseAccountsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseAccountsProvider._internal(
        (ref) => create(ref as ExpenseAccountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseAccount>> createElement() {
    return _ExpenseAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseAccountsProvider &&
        other.companyId == companyId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseAccountsRef on AutoDisposeFutureProviderRef<List<ExpenseAccount>> {
  /// The parameter `companyId` of this provider.
  String get companyId;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _ExpenseAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseAccount>>
    with ExpenseAccountsRef {
  _ExpenseAccountsProviderElement(super.provider);

  @override
  String get companyId => (origin as ExpenseAccountsProvider).companyId;
  @override
  String get userId => (origin as ExpenseAccountsProvider).userId;
}

String _$expenseAccountsOnlyHash() =>
    r'4745d74c32eff2b5d167875f2110970dd9fbddec';

/// Expense accounts only provider (account_type = 'expense')
/// Returns only accounts where account_type = 'expense'
/// AND (is_default = TRUE OR company_id = params.companyId)
/// Uses keepAlive to cache across navigation
///
/// Copied from [expenseAccountsOnly].
@ProviderFor(expenseAccountsOnly)
const expenseAccountsOnlyProvider = ExpenseAccountsOnlyFamily();

/// Expense accounts only provider (account_type = 'expense')
/// Returns only accounts where account_type = 'expense'
/// AND (is_default = TRUE OR company_id = params.companyId)
/// Uses keepAlive to cache across navigation
///
/// Copied from [expenseAccountsOnly].
class ExpenseAccountsOnlyFamily
    extends Family<AsyncValue<List<ExpenseAccount>>> {
  /// Expense accounts only provider (account_type = 'expense')
  /// Returns only accounts where account_type = 'expense'
  /// AND (is_default = TRUE OR company_id = params.companyId)
  /// Uses keepAlive to cache across navigation
  ///
  /// Copied from [expenseAccountsOnly].
  const ExpenseAccountsOnlyFamily();

  /// Expense accounts only provider (account_type = 'expense')
  /// Returns only accounts where account_type = 'expense'
  /// AND (is_default = TRUE OR company_id = params.companyId)
  /// Uses keepAlive to cache across navigation
  ///
  /// Copied from [expenseAccountsOnly].
  ExpenseAccountsOnlyProvider call(
    String companyId,
  ) {
    return ExpenseAccountsOnlyProvider(
      companyId,
    );
  }

  @override
  ExpenseAccountsOnlyProvider getProviderOverride(
    covariant ExpenseAccountsOnlyProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseAccountsOnlyProvider';
}

/// Expense accounts only provider (account_type = 'expense')
/// Returns only accounts where account_type = 'expense'
/// AND (is_default = TRUE OR company_id = params.companyId)
/// Uses keepAlive to cache across navigation
///
/// Copied from [expenseAccountsOnly].
class ExpenseAccountsOnlyProvider
    extends AutoDisposeFutureProvider<List<ExpenseAccount>> {
  /// Expense accounts only provider (account_type = 'expense')
  /// Returns only accounts where account_type = 'expense'
  /// AND (is_default = TRUE OR company_id = params.companyId)
  /// Uses keepAlive to cache across navigation
  ///
  /// Copied from [expenseAccountsOnly].
  ExpenseAccountsOnlyProvider(
    String companyId,
  ) : this._internal(
          (ref) => expenseAccountsOnly(
            ref as ExpenseAccountsOnlyRef,
            companyId,
          ),
          from: expenseAccountsOnlyProvider,
          name: r'expenseAccountsOnlyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseAccountsOnlyHash,
          dependencies: ExpenseAccountsOnlyFamily._dependencies,
          allTransitiveDependencies:
              ExpenseAccountsOnlyFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  ExpenseAccountsOnlyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseAccount>> Function(ExpenseAccountsOnlyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseAccountsOnlyProvider._internal(
        (ref) => create(ref as ExpenseAccountsOnlyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseAccount>> createElement() {
    return _ExpenseAccountsOnlyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseAccountsOnlyProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseAccountsOnlyRef
    on AutoDisposeFutureProviderRef<List<ExpenseAccount>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _ExpenseAccountsOnlyProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseAccount>>
    with ExpenseAccountsOnlyRef {
  _ExpenseAccountsOnlyProviderElement(super.provider);

  @override
  String get companyId => (origin as ExpenseAccountsOnlyProvider).companyId;
}

String _$searchExpenseAccountsHash() =>
    r'2b7bd7d1ef647d463fba9275e8ad39a2e6a183fb';

/// Search expense accounts provider
/// Returns expense accounts matching the search query
///
/// Copied from [searchExpenseAccounts].
@ProviderFor(searchExpenseAccounts)
const searchExpenseAccountsProvider = SearchExpenseAccountsFamily();

/// Search expense accounts provider
/// Returns expense accounts matching the search query
///
/// Copied from [searchExpenseAccounts].
class SearchExpenseAccountsFamily
    extends Family<AsyncValue<List<ExpenseAccount>>> {
  /// Search expense accounts provider
  /// Returns expense accounts matching the search query
  ///
  /// Copied from [searchExpenseAccounts].
  const SearchExpenseAccountsFamily();

  /// Search expense accounts provider
  /// Returns expense accounts matching the search query
  ///
  /// Copied from [searchExpenseAccounts].
  SearchExpenseAccountsProvider call({
    required String companyId,
    required String query,
  }) {
    return SearchExpenseAccountsProvider(
      companyId: companyId,
      query: query,
    );
  }

  @override
  SearchExpenseAccountsProvider getProviderOverride(
    covariant SearchExpenseAccountsProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
      query: provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchExpenseAccountsProvider';
}

/// Search expense accounts provider
/// Returns expense accounts matching the search query
///
/// Copied from [searchExpenseAccounts].
class SearchExpenseAccountsProvider
    extends AutoDisposeFutureProvider<List<ExpenseAccount>> {
  /// Search expense accounts provider
  /// Returns expense accounts matching the search query
  ///
  /// Copied from [searchExpenseAccounts].
  SearchExpenseAccountsProvider({
    required String companyId,
    required String query,
  }) : this._internal(
          (ref) => searchExpenseAccounts(
            ref as SearchExpenseAccountsRef,
            companyId: companyId,
            query: query,
          ),
          from: searchExpenseAccountsProvider,
          name: r'searchExpenseAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchExpenseAccountsHash,
          dependencies: SearchExpenseAccountsFamily._dependencies,
          allTransitiveDependencies:
              SearchExpenseAccountsFamily._allTransitiveDependencies,
          companyId: companyId,
          query: query,
        );

  SearchExpenseAccountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
    required this.query,
  }) : super.internal();

  final String companyId;
  final String query;

  @override
  Override overrideWith(
    FutureOr<List<ExpenseAccount>> Function(SearchExpenseAccountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchExpenseAccountsProvider._internal(
        (ref) => create(ref as SearchExpenseAccountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ExpenseAccount>> createElement() {
    return _SearchExpenseAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchExpenseAccountsProvider &&
        other.companyId == companyId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchExpenseAccountsRef
    on AutoDisposeFutureProviderRef<List<ExpenseAccount>> {
  /// The parameter `companyId` of this provider.
  String get companyId;

  /// The parameter `query` of this provider.
  String get query;
}

class _SearchExpenseAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<ExpenseAccount>>
    with SearchExpenseAccountsRef {
  _SearchExpenseAccountsProviderElement(super.provider);

  @override
  String get companyId => (origin as SearchExpenseAccountsProvider).companyId;
  @override
  String get query => (origin as SearchExpenseAccountsProvider).query;
}

String _$counterpartiesHash() => r'8684d090786601f2818b29f75e58ce2418540659';

/// Counterparties provider
///
/// Copied from [counterparties].
@ProviderFor(counterparties)
const counterpartiesProvider = CounterpartiesFamily();

/// Counterparties provider
///
/// Copied from [counterparties].
class CounterpartiesFamily extends Family<AsyncValue<List<Counterparty>>> {
  /// Counterparties provider
  ///
  /// Copied from [counterparties].
  const CounterpartiesFamily();

  /// Counterparties provider
  ///
  /// Copied from [counterparties].
  CounterpartiesProvider call(
    String companyId,
  ) {
    return CounterpartiesProvider(
      companyId,
    );
  }

  @override
  CounterpartiesProvider getProviderOverride(
    covariant CounterpartiesProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'counterpartiesProvider';
}

/// Counterparties provider
///
/// Copied from [counterparties].
class CounterpartiesProvider
    extends AutoDisposeFutureProvider<List<Counterparty>> {
  /// Counterparties provider
  ///
  /// Copied from [counterparties].
  CounterpartiesProvider(
    String companyId,
  ) : this._internal(
          (ref) => counterparties(
            ref as CounterpartiesRef,
            companyId,
          ),
          from: counterpartiesProvider,
          name: r'counterpartiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartiesHash,
          dependencies: CounterpartiesFamily._dependencies,
          allTransitiveDependencies:
              CounterpartiesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CounterpartiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<Counterparty>> Function(CounterpartiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartiesProvider._internal(
        (ref) => create(ref as CounterpartiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Counterparty>> createElement() {
    return _CounterpartiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartiesProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterpartiesRef on AutoDisposeFutureProviderRef<List<Counterparty>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CounterpartiesProviderElement
    extends AutoDisposeFutureProviderElement<List<Counterparty>>
    with CounterpartiesRef {
  _CounterpartiesProviderElement(super.provider);

  @override
  String get companyId => (origin as CounterpartiesProvider).companyId;
}

String _$selfCounterpartyHash() => r'9b123df97b1f242de47b5699a3c585cc4816fa4c';

/// Self-counterparty provider
/// Returns the counterparty where company_id = linked_company_id
/// Used for within-company transfers (same company, different stores)
///
/// Copied from [selfCounterparty].
@ProviderFor(selfCounterparty)
const selfCounterpartyProvider = SelfCounterpartyFamily();

/// Self-counterparty provider
/// Returns the counterparty where company_id = linked_company_id
/// Used for within-company transfers (same company, different stores)
///
/// Copied from [selfCounterparty].
class SelfCounterpartyFamily extends Family<AsyncValue<Counterparty?>> {
  /// Self-counterparty provider
  /// Returns the counterparty where company_id = linked_company_id
  /// Used for within-company transfers (same company, different stores)
  ///
  /// Copied from [selfCounterparty].
  const SelfCounterpartyFamily();

  /// Self-counterparty provider
  /// Returns the counterparty where company_id = linked_company_id
  /// Used for within-company transfers (same company, different stores)
  ///
  /// Copied from [selfCounterparty].
  SelfCounterpartyProvider call(
    String companyId,
  ) {
    return SelfCounterpartyProvider(
      companyId,
    );
  }

  @override
  SelfCounterpartyProvider getProviderOverride(
    covariant SelfCounterpartyProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'selfCounterpartyProvider';
}

/// Self-counterparty provider
/// Returns the counterparty where company_id = linked_company_id
/// Used for within-company transfers (same company, different stores)
///
/// Copied from [selfCounterparty].
class SelfCounterpartyProvider
    extends AutoDisposeFutureProvider<Counterparty?> {
  /// Self-counterparty provider
  /// Returns the counterparty where company_id = linked_company_id
  /// Used for within-company transfers (same company, different stores)
  ///
  /// Copied from [selfCounterparty].
  SelfCounterpartyProvider(
    String companyId,
  ) : this._internal(
          (ref) => selfCounterparty(
            ref as SelfCounterpartyRef,
            companyId,
          ),
          from: selfCounterpartyProvider,
          name: r'selfCounterpartyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selfCounterpartyHash,
          dependencies: SelfCounterpartyFamily._dependencies,
          allTransitiveDependencies:
              SelfCounterpartyFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  SelfCounterpartyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<Counterparty?> Function(SelfCounterpartyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelfCounterpartyProvider._internal(
        (ref) => create(ref as SelfCounterpartyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Counterparty?> createElement() {
    return _SelfCounterpartyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelfCounterpartyProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SelfCounterpartyRef on AutoDisposeFutureProviderRef<Counterparty?> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _SelfCounterpartyProviderElement
    extends AutoDisposeFutureProviderElement<Counterparty?>
    with SelfCounterpartyRef {
  _SelfCounterpartyProviderElement(super.provider);

  @override
  String get companyId => (origin as SelfCounterpartyProvider).companyId;
}

String _$cashLocationsForCompanyHash() =>
    r'e0948224a8ee84be2678a9bf282bb9a991e13700';

/// Cash locations provider for a company
///
/// Copied from [cashLocationsForCompany].
@ProviderFor(cashLocationsForCompany)
const cashLocationsForCompanyProvider = CashLocationsForCompanyFamily();

/// Cash locations provider for a company
///
/// Copied from [cashLocationsForCompany].
class CashLocationsForCompanyFamily
    extends Family<AsyncValue<List<CashLocation>>> {
  /// Cash locations provider for a company
  ///
  /// Copied from [cashLocationsForCompany].
  const CashLocationsForCompanyFamily();

  /// Cash locations provider for a company
  ///
  /// Copied from [cashLocationsForCompany].
  CashLocationsForCompanyProvider call(
    String companyId,
  ) {
    return CashLocationsForCompanyProvider(
      companyId,
    );
  }

  @override
  CashLocationsForCompanyProvider getProviderOverride(
    covariant CashLocationsForCompanyProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cashLocationsForCompanyProvider';
}

/// Cash locations provider for a company
///
/// Copied from [cashLocationsForCompany].
class CashLocationsForCompanyProvider
    extends AutoDisposeFutureProvider<List<CashLocation>> {
  /// Cash locations provider for a company
  ///
  /// Copied from [cashLocationsForCompany].
  CashLocationsForCompanyProvider(
    String companyId,
  ) : this._internal(
          (ref) => cashLocationsForCompany(
            ref as CashLocationsForCompanyRef,
            companyId,
          ),
          from: cashLocationsForCompanyProvider,
          name: r'cashLocationsForCompanyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationsForCompanyHash,
          dependencies: CashLocationsForCompanyFamily._dependencies,
          allTransitiveDependencies:
              CashLocationsForCompanyFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CashLocationsForCompanyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<CashLocation>> Function(CashLocationsForCompanyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationsForCompanyProvider._internal(
        (ref) => create(ref as CashLocationsForCompanyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocation>> createElement() {
    return _CashLocationsForCompanyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationsForCompanyProvider &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationsForCompanyRef
    on AutoDisposeFutureProviderRef<List<CashLocation>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CashLocationsForCompanyProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocation>>
    with CashLocationsForCompanyRef {
  _CashLocationsForCompanyProviderElement(super.provider);

  @override
  String get companyId => (origin as CashLocationsForCompanyProvider).companyId;
}

String _$cashLocationsForStoreHash() =>
    r'84929c4c368fafdd8939cd2221588cfdfcf1e796';

/// Cash locations provider for a store
/// Uses keepAlive to cache for 3 minutes
///
/// Copied from [cashLocationsForStore].
@ProviderFor(cashLocationsForStore)
const cashLocationsForStoreProvider = CashLocationsForStoreFamily();

/// Cash locations provider for a store
/// Uses keepAlive to cache for 3 minutes
///
/// Copied from [cashLocationsForStore].
class CashLocationsForStoreFamily
    extends Family<AsyncValue<List<CashLocation>>> {
  /// Cash locations provider for a store
  /// Uses keepAlive to cache for 3 minutes
  ///
  /// Copied from [cashLocationsForStore].
  const CashLocationsForStoreFamily();

  /// Cash locations provider for a store
  /// Uses keepAlive to cache for 3 minutes
  ///
  /// Copied from [cashLocationsForStore].
  CashLocationsForStoreProvider call({
    required String companyId,
    required String storeId,
  }) {
    return CashLocationsForStoreProvider(
      companyId: companyId,
      storeId: storeId,
    );
  }

  @override
  CashLocationsForStoreProvider getProviderOverride(
    covariant CashLocationsForStoreProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
      storeId: provider.storeId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cashLocationsForStoreProvider';
}

/// Cash locations provider for a store
/// Uses keepAlive to cache for 3 minutes
///
/// Copied from [cashLocationsForStore].
class CashLocationsForStoreProvider
    extends AutoDisposeFutureProvider<List<CashLocation>> {
  /// Cash locations provider for a store
  /// Uses keepAlive to cache for 3 minutes
  ///
  /// Copied from [cashLocationsForStore].
  CashLocationsForStoreProvider({
    required String companyId,
    required String storeId,
  }) : this._internal(
          (ref) => cashLocationsForStore(
            ref as CashLocationsForStoreRef,
            companyId: companyId,
            storeId: storeId,
          ),
          from: cashLocationsForStoreProvider,
          name: r'cashLocationsForStoreProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationsForStoreHash,
          dependencies: CashLocationsForStoreFamily._dependencies,
          allTransitiveDependencies:
              CashLocationsForStoreFamily._allTransitiveDependencies,
          companyId: companyId,
          storeId: storeId,
        );

  CashLocationsForStoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
    required this.storeId,
  }) : super.internal();

  final String companyId;
  final String storeId;

  @override
  Override overrideWith(
    FutureOr<List<CashLocation>> Function(CashLocationsForStoreRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationsForStoreProvider._internal(
        (ref) => create(ref as CashLocationsForStoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocation>> createElement() {
    return _CashLocationsForStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationsForStoreProvider &&
        other.companyId == companyId &&
        other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationsForStoreRef
    on AutoDisposeFutureProviderRef<List<CashLocation>> {
  /// The parameter `companyId` of this provider.
  String get companyId;

  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _CashLocationsForStoreProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocation>>
    with CashLocationsForStoreRef {
  _CashLocationsForStoreProviderElement(super.provider);

  @override
  String get companyId => (origin as CashLocationsForStoreProvider).companyId;
  @override
  String get storeId => (origin as CashLocationsForStoreProvider).storeId;
}

String _$companyCurrencySymbolHash() =>
    r'87c247081a92377951656e8ab03647b6e5b4d357';

/// Company base currency symbol provider
/// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
///
/// Copied from [companyCurrencySymbol].
@ProviderFor(companyCurrencySymbol)
const companyCurrencySymbolProvider = CompanyCurrencySymbolFamily();

/// Company base currency symbol provider
/// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
///
/// Copied from [companyCurrencySymbol].
class CompanyCurrencySymbolFamily extends Family<AsyncValue<String>> {
  /// Company base currency symbol provider
  /// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
  ///
  /// Copied from [companyCurrencySymbol].
  const CompanyCurrencySymbolFamily();

  /// Company base currency symbol provider
  /// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
  ///
  /// Copied from [companyCurrencySymbol].
  CompanyCurrencySymbolProvider call(
    String companyId,
  ) {
    return CompanyCurrencySymbolProvider(
      companyId,
    );
  }

  @override
  CompanyCurrencySymbolProvider getProviderOverride(
    covariant CompanyCurrencySymbolProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'companyCurrencySymbolProvider';
}

/// Company base currency symbol provider
/// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
///
/// Copied from [companyCurrencySymbol].
class CompanyCurrencySymbolProvider extends AutoDisposeFutureProvider<String> {
  /// Company base currency symbol provider
  /// Returns the currency symbol for the company (e.g., '₩', '$', '₫')
  ///
  /// Copied from [companyCurrencySymbol].
  CompanyCurrencySymbolProvider(
    String companyId,
  ) : this._internal(
          (ref) => companyCurrencySymbol(
            ref as CompanyCurrencySymbolRef,
            companyId,
          ),
          from: companyCurrencySymbolProvider,
          name: r'companyCurrencySymbolProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$companyCurrencySymbolHash,
          dependencies: CompanyCurrencySymbolFamily._dependencies,
          allTransitiveDependencies:
              CompanyCurrencySymbolFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CompanyCurrencySymbolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<String> Function(CompanyCurrencySymbolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyCurrencySymbolProvider._internal(
        (ref) => create(ref as CompanyCurrencySymbolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _CompanyCurrencySymbolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCurrencySymbolProvider &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompanyCurrencySymbolRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CompanyCurrencySymbolProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with CompanyCurrencySymbolRef {
  _CompanyCurrencySymbolProviderElement(super.provider);

  @override
  String get companyId => (origin as CompanyCurrencySymbolProvider).companyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
