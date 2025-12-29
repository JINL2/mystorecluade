// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allCashLocationsHash() => r'1645bc9a19c5b5c9cc130d9f6b2f3c07461d1e5b';

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

/// Cash Location Providers - delegates to UseCases
///
/// Copied from [allCashLocations].
@ProviderFor(allCashLocations)
const allCashLocationsProvider = AllCashLocationsFamily();

/// Cash Location Providers - delegates to UseCases
///
/// Copied from [allCashLocations].
class AllCashLocationsFamily extends Family<AsyncValue<List<CashLocation>>> {
  /// Cash Location Providers - delegates to UseCases
  ///
  /// Copied from [allCashLocations].
  const AllCashLocationsFamily();

  /// Cash Location Providers - delegates to UseCases
  ///
  /// Copied from [allCashLocations].
  AllCashLocationsProvider call(
    CashLocationQueryParams params,
  ) {
    return AllCashLocationsProvider(
      params,
    );
  }

  @override
  AllCashLocationsProvider getProviderOverride(
    covariant AllCashLocationsProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'allCashLocationsProvider';
}

/// Cash Location Providers - delegates to UseCases
///
/// Copied from [allCashLocations].
class AllCashLocationsProvider
    extends AutoDisposeFutureProvider<List<CashLocation>> {
  /// Cash Location Providers - delegates to UseCases
  ///
  /// Copied from [allCashLocations].
  AllCashLocationsProvider(
    CashLocationQueryParams params,
  ) : this._internal(
          (ref) => allCashLocations(
            ref as AllCashLocationsRef,
            params,
          ),
          from: allCashLocationsProvider,
          name: r'allCashLocationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allCashLocationsHash,
          dependencies: AllCashLocationsFamily._dependencies,
          allTransitiveDependencies:
              AllCashLocationsFamily._allTransitiveDependencies,
          params: params,
        );

  AllCashLocationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CashLocationQueryParams params;

  @override
  Override overrideWith(
    FutureOr<List<CashLocation>> Function(AllCashLocationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllCashLocationsProvider._internal(
        (ref) => create(ref as AllCashLocationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocation>> createElement() {
    return _AllCashLocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllCashLocationsProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllCashLocationsRef on AutoDisposeFutureProviderRef<List<CashLocation>> {
  /// The parameter `params` of this provider.
  CashLocationQueryParams get params;
}

class _AllCashLocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocation>>
    with AllCashLocationsRef {
  _AllCashLocationsProviderElement(super.provider);

  @override
  CashLocationQueryParams get params =>
      (origin as AllCashLocationsProvider).params;
}

String _$cashRealHash() => r'de3dd333767da3917f10cc05d74473d758ed9e36';

/// Cash Real Provider - delegates to UseCase
///
/// Copied from [cashReal].
@ProviderFor(cashReal)
const cashRealProvider = CashRealFamily();

/// Cash Real Provider - delegates to UseCase
///
/// Copied from [cashReal].
class CashRealFamily extends Family<AsyncValue<List<CashRealEntry>>> {
  /// Cash Real Provider - delegates to UseCase
  ///
  /// Copied from [cashReal].
  const CashRealFamily();

  /// Cash Real Provider - delegates to UseCase
  ///
  /// Copied from [cashReal].
  CashRealProvider call(
    CashRealParams params,
  ) {
    return CashRealProvider(
      params,
    );
  }

  @override
  CashRealProvider getProviderOverride(
    covariant CashRealProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'cashRealProvider';
}

/// Cash Real Provider - delegates to UseCase
///
/// Copied from [cashReal].
class CashRealProvider extends AutoDisposeFutureProvider<List<CashRealEntry>> {
  /// Cash Real Provider - delegates to UseCase
  ///
  /// Copied from [cashReal].
  CashRealProvider(
    CashRealParams params,
  ) : this._internal(
          (ref) => cashReal(
            ref as CashRealRef,
            params,
          ),
          from: cashRealProvider,
          name: r'cashRealProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashRealHash,
          dependencies: CashRealFamily._dependencies,
          allTransitiveDependencies: CashRealFamily._allTransitiveDependencies,
          params: params,
        );

  CashRealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CashRealParams params;

  @override
  Override overrideWith(
    FutureOr<List<CashRealEntry>> Function(CashRealRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashRealProvider._internal(
        (ref) => create(ref as CashRealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashRealEntry>> createElement() {
    return _CashRealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashRealProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashRealRef on AutoDisposeFutureProviderRef<List<CashRealEntry>> {
  /// The parameter `params` of this provider.
  CashRealParams get params;
}

class _CashRealProviderElement
    extends AutoDisposeFutureProviderElement<List<CashRealEntry>>
    with CashRealRef {
  _CashRealProviderElement(super.provider);

  @override
  CashRealParams get params => (origin as CashRealProvider).params;
}

String _$bankRealHash() => r'3e7dab2a9fb785a105ff204dd8b574a2a1a5cd15';

/// Bank Real Provider - delegates to UseCase
///
/// Copied from [bankReal].
@ProviderFor(bankReal)
const bankRealProvider = BankRealFamily();

/// Bank Real Provider - delegates to UseCase
///
/// Copied from [bankReal].
class BankRealFamily extends Family<AsyncValue<List<BankRealEntry>>> {
  /// Bank Real Provider - delegates to UseCase
  ///
  /// Copied from [bankReal].
  const BankRealFamily();

  /// Bank Real Provider - delegates to UseCase
  ///
  /// Copied from [bankReal].
  BankRealProvider call(
    BankRealParams params,
  ) {
    return BankRealProvider(
      params,
    );
  }

  @override
  BankRealProvider getProviderOverride(
    covariant BankRealProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'bankRealProvider';
}

/// Bank Real Provider - delegates to UseCase
///
/// Copied from [bankReal].
class BankRealProvider extends AutoDisposeFutureProvider<List<BankRealEntry>> {
  /// Bank Real Provider - delegates to UseCase
  ///
  /// Copied from [bankReal].
  BankRealProvider(
    BankRealParams params,
  ) : this._internal(
          (ref) => bankReal(
            ref as BankRealRef,
            params,
          ),
          from: bankRealProvider,
          name: r'bankRealProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bankRealHash,
          dependencies: BankRealFamily._dependencies,
          allTransitiveDependencies: BankRealFamily._allTransitiveDependencies,
          params: params,
        );

  BankRealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final BankRealParams params;

  @override
  Override overrideWith(
    FutureOr<List<BankRealEntry>> Function(BankRealRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BankRealProvider._internal(
        (ref) => create(ref as BankRealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BankRealEntry>> createElement() {
    return _BankRealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BankRealProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BankRealRef on AutoDisposeFutureProviderRef<List<BankRealEntry>> {
  /// The parameter `params` of this provider.
  BankRealParams get params;
}

class _BankRealProviderElement
    extends AutoDisposeFutureProviderElement<List<BankRealEntry>>
    with BankRealRef {
  _BankRealProviderElement(super.provider);

  @override
  BankRealParams get params => (origin as BankRealProvider).params;
}

String _$vaultRealHash() => r'4bf4010d8935e9e28ca0a2e76a0546c8e2c0f5b4';

/// Vault Real Provider - delegates to UseCase
///
/// Copied from [vaultReal].
@ProviderFor(vaultReal)
const vaultRealProvider = VaultRealFamily();

/// Vault Real Provider - delegates to UseCase
///
/// Copied from [vaultReal].
class VaultRealFamily extends Family<AsyncValue<List<VaultRealEntry>>> {
  /// Vault Real Provider - delegates to UseCase
  ///
  /// Copied from [vaultReal].
  const VaultRealFamily();

  /// Vault Real Provider - delegates to UseCase
  ///
  /// Copied from [vaultReal].
  VaultRealProvider call(
    VaultRealParams params,
  ) {
    return VaultRealProvider(
      params,
    );
  }

  @override
  VaultRealProvider getProviderOverride(
    covariant VaultRealProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'vaultRealProvider';
}

/// Vault Real Provider - delegates to UseCase
///
/// Copied from [vaultReal].
class VaultRealProvider
    extends AutoDisposeFutureProvider<List<VaultRealEntry>> {
  /// Vault Real Provider - delegates to UseCase
  ///
  /// Copied from [vaultReal].
  VaultRealProvider(
    VaultRealParams params,
  ) : this._internal(
          (ref) => vaultReal(
            ref as VaultRealRef,
            params,
          ),
          from: vaultRealProvider,
          name: r'vaultRealProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vaultRealHash,
          dependencies: VaultRealFamily._dependencies,
          allTransitiveDependencies: VaultRealFamily._allTransitiveDependencies,
          params: params,
        );

  VaultRealProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final VaultRealParams params;

  @override
  Override overrideWith(
    FutureOr<List<VaultRealEntry>> Function(VaultRealRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VaultRealProvider._internal(
        (ref) => create(ref as VaultRealRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VaultRealEntry>> createElement() {
    return _VaultRealProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VaultRealProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VaultRealRef on AutoDisposeFutureProviderRef<List<VaultRealEntry>> {
  /// The parameter `params` of this provider.
  VaultRealParams get params;
}

class _VaultRealProviderElement
    extends AutoDisposeFutureProviderElement<List<VaultRealEntry>>
    with VaultRealRef {
  _VaultRealProviderElement(super.provider);

  @override
  VaultRealParams get params => (origin as VaultRealProvider).params;
}

String _$cashJournalHash() => r'd1f941571dc9e0344dfd0e1755a32adf9360ffbd';

/// Cash Journal Provider - delegates to UseCase
///
/// Copied from [cashJournal].
@ProviderFor(cashJournal)
const cashJournalProvider = CashJournalFamily();

/// Cash Journal Provider - delegates to UseCase
///
/// Copied from [cashJournal].
class CashJournalFamily extends Family<AsyncValue<List<JournalEntry>>> {
  /// Cash Journal Provider - delegates to UseCase
  ///
  /// Copied from [cashJournal].
  const CashJournalFamily();

  /// Cash Journal Provider - delegates to UseCase
  ///
  /// Copied from [cashJournal].
  CashJournalProvider call(
    CashJournalParams params,
  ) {
    return CashJournalProvider(
      params,
    );
  }

  @override
  CashJournalProvider getProviderOverride(
    covariant CashJournalProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'cashJournalProvider';
}

/// Cash Journal Provider - delegates to UseCase
///
/// Copied from [cashJournal].
class CashJournalProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// Cash Journal Provider - delegates to UseCase
  ///
  /// Copied from [cashJournal].
  CashJournalProvider(
    CashJournalParams params,
  ) : this._internal(
          (ref) => cashJournal(
            ref as CashJournalRef,
            params,
          ),
          from: cashJournalProvider,
          name: r'cashJournalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashJournalHash,
          dependencies: CashJournalFamily._dependencies,
          allTransitiveDependencies:
              CashJournalFamily._allTransitiveDependencies,
          params: params,
        );

  CashJournalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CashJournalParams params;

  @override
  Override overrideWith(
    FutureOr<List<JournalEntry>> Function(CashJournalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashJournalProvider._internal(
        (ref) => create(ref as CashJournalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _CashJournalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashJournalProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashJournalRef on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `params` of this provider.
  CashJournalParams get params;
}

class _CashJournalProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with CashJournalRef {
  _CashJournalProviderElement(super.provider);

  @override
  CashJournalParams get params => (origin as CashJournalProvider).params;
}

String _$stockFlowHash() => r'df4f27fd0f03ec59e3e3e18938a4c6a732dcc0e8';

/// Stock Flow Provider - delegates to UseCase
///
/// Copied from [stockFlow].
@ProviderFor(stockFlow)
const stockFlowProvider = StockFlowFamily();

/// Stock Flow Provider - delegates to UseCase
///
/// Copied from [stockFlow].
class StockFlowFamily extends Family<AsyncValue<StockFlowResponse>> {
  /// Stock Flow Provider - delegates to UseCase
  ///
  /// Copied from [stockFlow].
  const StockFlowFamily();

  /// Stock Flow Provider - delegates to UseCase
  ///
  /// Copied from [stockFlow].
  StockFlowProvider call(
    StockFlowParams params,
  ) {
    return StockFlowProvider(
      params,
    );
  }

  @override
  StockFlowProvider getProviderOverride(
    covariant StockFlowProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'stockFlowProvider';
}

/// Stock Flow Provider - delegates to UseCase
///
/// Copied from [stockFlow].
class StockFlowProvider extends AutoDisposeFutureProvider<StockFlowResponse> {
  /// Stock Flow Provider - delegates to UseCase
  ///
  /// Copied from [stockFlow].
  StockFlowProvider(
    StockFlowParams params,
  ) : this._internal(
          (ref) => stockFlow(
            ref as StockFlowRef,
            params,
          ),
          from: stockFlowProvider,
          name: r'stockFlowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockFlowHash,
          dependencies: StockFlowFamily._dependencies,
          allTransitiveDependencies: StockFlowFamily._allTransitiveDependencies,
          params: params,
        );

  StockFlowProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final StockFlowParams params;

  @override
  Override overrideWith(
    FutureOr<StockFlowResponse> Function(StockFlowRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockFlowProvider._internal(
        (ref) => create(ref as StockFlowRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<StockFlowResponse> createElement() {
    return _StockFlowProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockFlowProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockFlowRef on AutoDisposeFutureProviderRef<StockFlowResponse> {
  /// The parameter `params` of this provider.
  StockFlowParams get params;
}

class _StockFlowProviderElement
    extends AutoDisposeFutureProviderElement<StockFlowResponse>
    with StockFlowRef {
  _StockFlowProviderElement(super.provider);

  @override
  StockFlowParams get params => (origin as StockFlowProvider).params;
}

String _$currencyTypesHash() => r'deff0309effee3b9727d19ef104c51014c166426';

/// Currency Types Provider - fetches available currency types from register_denomination feature
///
/// Copied from [currencyTypes].
@ProviderFor(currencyTypes)
final currencyTypesProvider =
    AutoDisposeFutureProvider<List<CurrencyType>>.internal(
  currencyTypes,
  name: r'currencyTypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrencyTypesRef = AutoDisposeFutureProviderRef<List<CurrencyType>>;
String _$cashLocationTotalsHash() =>
    r'52ecfced1c152acf87f28010daf224a551e0233b';

/// Provider for cached totals (avoids fold() every build)
///
/// Copied from [cashLocationTotals].
@ProviderFor(cashLocationTotals)
const cashLocationTotalsProvider = CashLocationTotalsFamily();

/// Provider for cached totals (avoids fold() every build)
///
/// Copied from [cashLocationTotals].
class CashLocationTotalsFamily extends Family<CashLocationTotals> {
  /// Provider for cached totals (avoids fold() every build)
  ///
  /// Copied from [cashLocationTotals].
  const CashLocationTotalsFamily();

  /// Provider for cached totals (avoids fold() every build)
  ///
  /// Copied from [cashLocationTotals].
  CashLocationTotalsProvider call(
    List<CashLocation> locations,
  ) {
    return CashLocationTotalsProvider(
      locations,
    );
  }

  @override
  CashLocationTotalsProvider getProviderOverride(
    covariant CashLocationTotalsProvider provider,
  ) {
    return call(
      provider.locations,
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
  String? get name => r'cashLocationTotalsProvider';
}

/// Provider for cached totals (avoids fold() every build)
///
/// Copied from [cashLocationTotals].
class CashLocationTotalsProvider
    extends AutoDisposeProvider<CashLocationTotals> {
  /// Provider for cached totals (avoids fold() every build)
  ///
  /// Copied from [cashLocationTotals].
  CashLocationTotalsProvider(
    List<CashLocation> locations,
  ) : this._internal(
          (ref) => cashLocationTotals(
            ref as CashLocationTotalsRef,
            locations,
          ),
          from: cashLocationTotalsProvider,
          name: r'cashLocationTotalsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationTotalsHash,
          dependencies: CashLocationTotalsFamily._dependencies,
          allTransitiveDependencies:
              CashLocationTotalsFamily._allTransitiveDependencies,
          locations: locations,
        );

  CashLocationTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locations,
  }) : super.internal();

  final List<CashLocation> locations;

  @override
  Override overrideWith(
    CashLocationTotals Function(CashLocationTotalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationTotalsProvider._internal(
        (ref) => create(ref as CashLocationTotalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locations: locations,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CashLocationTotals> createElement() {
    return _CashLocationTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationTotalsProvider && other.locations == locations;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locations.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationTotalsRef on AutoDisposeProviderRef<CashLocationTotals> {
  /// The parameter `locations` of this provider.
  List<CashLocation> get locations;
}

class _CashLocationTotalsProviderElement
    extends AutoDisposeProviderElement<CashLocationTotals>
    with CashLocationTotalsRef {
  _CashLocationTotalsProviderElement(super.provider);

  @override
  List<CashLocation> get locations =>
      (origin as CashLocationTotalsProvider).locations;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
