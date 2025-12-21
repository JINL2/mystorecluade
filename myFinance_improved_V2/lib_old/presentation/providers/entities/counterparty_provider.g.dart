// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentCounterpartiesHash() =>
    r'2100c51bc7bbbab09db6aa910dde360f46c4509a';

/// Current counterparties based on selected company/store
///
/// Copied from [currentCounterparties].
@ProviderFor(currentCounterparties)
final currentCounterpartiesProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentCounterparties,
  name: r'currentCounterpartiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCounterpartiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCounterpartiesRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$currentCounterpartiesByTypeHash() =>
    r'a2b3e288d3f6843ed43ed58f4432d40215328f6f';

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

/// Current counterparties filtered by type
///
/// Copied from [currentCounterpartiesByType].
@ProviderFor(currentCounterpartiesByType)
const currentCounterpartiesByTypeProvider = CurrentCounterpartiesByTypeFamily();

/// Current counterparties filtered by type
///
/// Copied from [currentCounterpartiesByType].
class CurrentCounterpartiesByTypeFamily
    extends Family<AsyncValue<List<CounterpartyData>>> {
  /// Current counterparties filtered by type
  ///
  /// Copied from [currentCounterpartiesByType].
  const CurrentCounterpartiesByTypeFamily();

  /// Current counterparties filtered by type
  ///
  /// Copied from [currentCounterpartiesByType].
  CurrentCounterpartiesByTypeProvider call(
    String counterpartyType,
  ) {
    return CurrentCounterpartiesByTypeProvider(
      counterpartyType,
    );
  }

  @override
  CurrentCounterpartiesByTypeProvider getProviderOverride(
    covariant CurrentCounterpartiesByTypeProvider provider,
  ) {
    return call(
      provider.counterpartyType,
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
  String? get name => r'currentCounterpartiesByTypeProvider';
}

/// Current counterparties filtered by type
///
/// Copied from [currentCounterpartiesByType].
class CurrentCounterpartiesByTypeProvider
    extends AutoDisposeFutureProvider<List<CounterpartyData>> {
  /// Current counterparties filtered by type
  ///
  /// Copied from [currentCounterpartiesByType].
  CurrentCounterpartiesByTypeProvider(
    String counterpartyType,
  ) : this._internal(
          (ref) => currentCounterpartiesByType(
            ref as CurrentCounterpartiesByTypeRef,
            counterpartyType,
          ),
          from: currentCounterpartiesByTypeProvider,
          name: r'currentCounterpartiesByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentCounterpartiesByTypeHash,
          dependencies: CurrentCounterpartiesByTypeFamily._dependencies,
          allTransitiveDependencies:
              CurrentCounterpartiesByTypeFamily._allTransitiveDependencies,
          counterpartyType: counterpartyType,
        );

  CurrentCounterpartiesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.counterpartyType,
  }) : super.internal();

  final String counterpartyType;

  @override
  Override overrideWith(
    FutureOr<List<CounterpartyData>> Function(
            CurrentCounterpartiesByTypeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentCounterpartiesByTypeProvider._internal(
        (ref) => create(ref as CurrentCounterpartiesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        counterpartyType: counterpartyType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CounterpartyData>> createElement() {
    return _CurrentCounterpartiesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentCounterpartiesByTypeProvider &&
        other.counterpartyType == counterpartyType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, counterpartyType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentCounterpartiesByTypeRef
    on AutoDisposeFutureProviderRef<List<CounterpartyData>> {
  /// The parameter `counterpartyType` of this provider.
  String get counterpartyType;
}

class _CurrentCounterpartiesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<CounterpartyData>>
    with CurrentCounterpartiesByTypeRef {
  _CurrentCounterpartiesByTypeProviderElement(super.provider);

  @override
  String get counterpartyType =>
      (origin as CurrentCounterpartiesByTypeProvider).counterpartyType;
}

String _$currentCustomersHash() => r'e37755fdf40276f2bd47baa8a7551d6c3f1a0c07';

/// Customer counterparties only
///
/// Copied from [currentCustomers].
@ProviderFor(currentCustomers)
final currentCustomersProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentCustomers,
  name: r'currentCustomersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCustomersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCustomersRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$currentVendorsHash() => r'4007f36709c277b52fb33c2d6a88c277da8c2642';

/// Vendor counterparties only
///
/// Copied from [currentVendors].
@ProviderFor(currentVendors)
final currentVendorsProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentVendors,
  name: r'currentVendorsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentVendorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentVendorsRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$currentSuppliersHash() => r'5e2ab1115707d4ee23f9f912edb0526e2ef2d05c';

/// Supplier counterparties only
///
/// Copied from [currentSuppliers].
@ProviderFor(currentSuppliers)
final currentSuppliersProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentSuppliers,
  name: r'currentSuppliersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSuppliersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentSuppliersRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$currentInternalCounterpartiesHash() =>
    r'111cd15065df5674f23b0bcda5094f38ba779c45';

/// Internal counterparties only
///
/// Copied from [currentInternalCounterparties].
@ProviderFor(currentInternalCounterparties)
final currentInternalCounterpartiesProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentInternalCounterparties,
  name: r'currentInternalCounterpartiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentInternalCounterpartiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentInternalCounterpartiesRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$currentExternalCounterpartiesHash() =>
    r'67e2d0e4205411e559c5585aea73a16b4a7b8daf';

/// External counterparties only
///
/// Copied from [currentExternalCounterparties].
@ProviderFor(currentExternalCounterparties)
final currentExternalCounterpartiesProvider =
    AutoDisposeFutureProvider<List<CounterpartyData>>.internal(
  currentExternalCounterparties,
  name: r'currentExternalCounterpartiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentExternalCounterpartiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentExternalCounterpartiesRef
    = AutoDisposeFutureProviderRef<List<CounterpartyData>>;
String _$counterpartyByIdHash() => r'da367d9def77c5d34b1724968d2d146e245a5649';

/// Find counterparty by ID
///
/// Copied from [counterpartyById].
@ProviderFor(counterpartyById)
const counterpartyByIdProvider = CounterpartyByIdFamily();

/// Find counterparty by ID
///
/// Copied from [counterpartyById].
class CounterpartyByIdFamily extends Family<AsyncValue<CounterpartyData?>> {
  /// Find counterparty by ID
  ///
  /// Copied from [counterpartyById].
  const CounterpartyByIdFamily();

  /// Find counterparty by ID
  ///
  /// Copied from [counterpartyById].
  CounterpartyByIdProvider call(
    String counterpartyId,
  ) {
    return CounterpartyByIdProvider(
      counterpartyId,
    );
  }

  @override
  CounterpartyByIdProvider getProviderOverride(
    covariant CounterpartyByIdProvider provider,
  ) {
    return call(
      provider.counterpartyId,
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
  String? get name => r'counterpartyByIdProvider';
}

/// Find counterparty by ID
///
/// Copied from [counterpartyById].
class CounterpartyByIdProvider
    extends AutoDisposeFutureProvider<CounterpartyData?> {
  /// Find counterparty by ID
  ///
  /// Copied from [counterpartyById].
  CounterpartyByIdProvider(
    String counterpartyId,
  ) : this._internal(
          (ref) => counterpartyById(
            ref as CounterpartyByIdRef,
            counterpartyId,
          ),
          from: counterpartyByIdProvider,
          name: r'counterpartyByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartyByIdHash,
          dependencies: CounterpartyByIdFamily._dependencies,
          allTransitiveDependencies:
              CounterpartyByIdFamily._allTransitiveDependencies,
          counterpartyId: counterpartyId,
        );

  CounterpartyByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.counterpartyId,
  }) : super.internal();

  final String counterpartyId;

  @override
  Override overrideWith(
    FutureOr<CounterpartyData?> Function(CounterpartyByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartyByIdProvider._internal(
        (ref) => create(ref as CounterpartyByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        counterpartyId: counterpartyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CounterpartyData?> createElement() {
    return _CounterpartyByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartyByIdProvider &&
        other.counterpartyId == counterpartyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, counterpartyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterpartyByIdRef on AutoDisposeFutureProviderRef<CounterpartyData?> {
  /// The parameter `counterpartyId` of this provider.
  String get counterpartyId;
}

class _CounterpartyByIdProviderElement
    extends AutoDisposeFutureProviderElement<CounterpartyData?>
    with CounterpartyByIdRef {
  _CounterpartyByIdProviderElement(super.provider);

  @override
  String get counterpartyId =>
      (origin as CounterpartyByIdProvider).counterpartyId;
}

String _$counterpartiesByIdsHash() =>
    r'455c4a8e39db6a8f2fdc817029424ccb0c26616a';

/// Find counterparties by IDs
///
/// Copied from [counterpartiesByIds].
@ProviderFor(counterpartiesByIds)
const counterpartiesByIdsProvider = CounterpartiesByIdsFamily();

/// Find counterparties by IDs
///
/// Copied from [counterpartiesByIds].
class CounterpartiesByIdsFamily
    extends Family<AsyncValue<List<CounterpartyData>>> {
  /// Find counterparties by IDs
  ///
  /// Copied from [counterpartiesByIds].
  const CounterpartiesByIdsFamily();

  /// Find counterparties by IDs
  ///
  /// Copied from [counterpartiesByIds].
  CounterpartiesByIdsProvider call(
    List<String> counterpartyIds,
  ) {
    return CounterpartiesByIdsProvider(
      counterpartyIds,
    );
  }

  @override
  CounterpartiesByIdsProvider getProviderOverride(
    covariant CounterpartiesByIdsProvider provider,
  ) {
    return call(
      provider.counterpartyIds,
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
  String? get name => r'counterpartiesByIdsProvider';
}

/// Find counterparties by IDs
///
/// Copied from [counterpartiesByIds].
class CounterpartiesByIdsProvider
    extends AutoDisposeFutureProvider<List<CounterpartyData>> {
  /// Find counterparties by IDs
  ///
  /// Copied from [counterpartiesByIds].
  CounterpartiesByIdsProvider(
    List<String> counterpartyIds,
  ) : this._internal(
          (ref) => counterpartiesByIds(
            ref as CounterpartiesByIdsRef,
            counterpartyIds,
          ),
          from: counterpartiesByIdsProvider,
          name: r'counterpartiesByIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartiesByIdsHash,
          dependencies: CounterpartiesByIdsFamily._dependencies,
          allTransitiveDependencies:
              CounterpartiesByIdsFamily._allTransitiveDependencies,
          counterpartyIds: counterpartyIds,
        );

  CounterpartiesByIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.counterpartyIds,
  }) : super.internal();

  final List<String> counterpartyIds;

  @override
  Override overrideWith(
    FutureOr<List<CounterpartyData>> Function(CounterpartiesByIdsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartiesByIdsProvider._internal(
        (ref) => create(ref as CounterpartiesByIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        counterpartyIds: counterpartyIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CounterpartyData>> createElement() {
    return _CounterpartiesByIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartiesByIdsProvider &&
        other.counterpartyIds == counterpartyIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, counterpartyIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterpartiesByIdsRef
    on AutoDisposeFutureProviderRef<List<CounterpartyData>> {
  /// The parameter `counterpartyIds` of this provider.
  List<String> get counterpartyIds;
}

class _CounterpartiesByIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<CounterpartyData>>
    with CounterpartiesByIdsRef {
  _CounterpartiesByIdsProviderElement(super.provider);

  @override
  List<String> get counterpartyIds =>
      (origin as CounterpartiesByIdsProvider).counterpartyIds;
}

String _$searchCounterpartiesHash() =>
    r'6310787d10413f4bbe2416543107b4e70e7e2f7e';

/// Search counterparties by name
///
/// Copied from [searchCounterparties].
@ProviderFor(searchCounterparties)
const searchCounterpartiesProvider = SearchCounterpartiesFamily();

/// Search counterparties by name
///
/// Copied from [searchCounterparties].
class SearchCounterpartiesFamily
    extends Family<AsyncValue<List<CounterpartyData>>> {
  /// Search counterparties by name
  ///
  /// Copied from [searchCounterparties].
  const SearchCounterpartiesFamily();

  /// Search counterparties by name
  ///
  /// Copied from [searchCounterparties].
  SearchCounterpartiesProvider call(
    String searchQuery,
  ) {
    return SearchCounterpartiesProvider(
      searchQuery,
    );
  }

  @override
  SearchCounterpartiesProvider getProviderOverride(
    covariant SearchCounterpartiesProvider provider,
  ) {
    return call(
      provider.searchQuery,
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
  String? get name => r'searchCounterpartiesProvider';
}

/// Search counterparties by name
///
/// Copied from [searchCounterparties].
class SearchCounterpartiesProvider
    extends AutoDisposeFutureProvider<List<CounterpartyData>> {
  /// Search counterparties by name
  ///
  /// Copied from [searchCounterparties].
  SearchCounterpartiesProvider(
    String searchQuery,
  ) : this._internal(
          (ref) => searchCounterparties(
            ref as SearchCounterpartiesRef,
            searchQuery,
          ),
          from: searchCounterpartiesProvider,
          name: r'searchCounterpartiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchCounterpartiesHash,
          dependencies: SearchCounterpartiesFamily._dependencies,
          allTransitiveDependencies:
              SearchCounterpartiesFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SearchCounterpartiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<CounterpartyData>> Function(SearchCounterpartiesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchCounterpartiesProvider._internal(
        (ref) => create(ref as SearchCounterpartiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CounterpartyData>> createElement() {
    return _SearchCounterpartiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchCounterpartiesProvider &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchCounterpartiesRef
    on AutoDisposeFutureProviderRef<List<CounterpartyData>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _SearchCounterpartiesProviderElement
    extends AutoDisposeFutureProviderElement<List<CounterpartyData>>
    with SearchCounterpartiesRef {
  _SearchCounterpartiesProviderElement(super.provider);

  @override
  String get searchQuery =>
      (origin as SearchCounterpartiesProvider).searchQuery;
}

String _$counterpartyStoresHash() =>
    r'9ec19caaa7c342ebd277d6198e02d29e5f70c1e9';

/// Get stores for a counterparty company
///
/// Copied from [counterpartyStores].
@ProviderFor(counterpartyStores)
const counterpartyStoresProvider = CounterpartyStoresFamily();

/// Get stores for a counterparty company
///
/// Copied from [counterpartyStores].
class CounterpartyStoresFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Get stores for a counterparty company
  ///
  /// Copied from [counterpartyStores].
  const CounterpartyStoresFamily();

  /// Get stores for a counterparty company
  ///
  /// Copied from [counterpartyStores].
  CounterpartyStoresProvider call(
    String companyId,
  ) {
    return CounterpartyStoresProvider(
      companyId,
    );
  }

  @override
  CounterpartyStoresProvider getProviderOverride(
    covariant CounterpartyStoresProvider provider,
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
  String? get name => r'counterpartyStoresProvider';
}

/// Get stores for a counterparty company
///
/// Copied from [counterpartyStores].
class CounterpartyStoresProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Get stores for a counterparty company
  ///
  /// Copied from [counterpartyStores].
  CounterpartyStoresProvider(
    String companyId,
  ) : this._internal(
          (ref) => counterpartyStores(
            ref as CounterpartyStoresRef,
            companyId,
          ),
          from: counterpartyStoresProvider,
          name: r'counterpartyStoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartyStoresHash,
          dependencies: CounterpartyStoresFamily._dependencies,
          allTransitiveDependencies:
              CounterpartyStoresFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CounterpartyStoresProvider._internal(
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
    FutureOr<List<Map<String, dynamic>>> Function(
            CounterpartyStoresRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartyStoresProvider._internal(
        (ref) => create(ref as CounterpartyStoresRef),
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
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _CounterpartyStoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartyStoresProvider && other.companyId == companyId;
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
mixin CounterpartyStoresRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CounterpartyStoresProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with CounterpartyStoresRef {
  _CounterpartyStoresProviderElement(super.provider);

  @override
  String get companyId => (origin as CounterpartyStoresProvider).companyId;
}

String _$counterpartyListHash() => r'9006e592fb8ce2e32be792ee514de1e4412e9c03';

abstract class _$CounterpartyList
    extends BuildlessAutoDisposeAsyncNotifier<List<CounterpartyData>> {
  late final String companyId;
  late final String? storeId;
  late final String? counterpartyType;

  FutureOr<List<CounterpartyData>> build(
    String companyId, [
    String? storeId,
    String? counterpartyType,
  ]);
}

/// See also [CounterpartyList].
@ProviderFor(CounterpartyList)
const counterpartyListProvider = CounterpartyListFamily();

/// See also [CounterpartyList].
class CounterpartyListFamily
    extends Family<AsyncValue<List<CounterpartyData>>> {
  /// See also [CounterpartyList].
  const CounterpartyListFamily();

  /// See also [CounterpartyList].
  CounterpartyListProvider call(
    String companyId, [
    String? storeId,
    String? counterpartyType,
  ]) {
    return CounterpartyListProvider(
      companyId,
      storeId,
      counterpartyType,
    );
  }

  @override
  CounterpartyListProvider getProviderOverride(
    covariant CounterpartyListProvider provider,
  ) {
    return call(
      provider.companyId,
      provider.storeId,
      provider.counterpartyType,
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
  String? get name => r'counterpartyListProvider';
}

/// See also [CounterpartyList].
class CounterpartyListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CounterpartyList, List<CounterpartyData>> {
  /// See also [CounterpartyList].
  CounterpartyListProvider(
    String companyId, [
    String? storeId,
    String? counterpartyType,
  ]) : this._internal(
          () => CounterpartyList()
            ..companyId = companyId
            ..storeId = storeId
            ..counterpartyType = counterpartyType,
          from: counterpartyListProvider,
          name: r'counterpartyListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartyListHash,
          dependencies: CounterpartyListFamily._dependencies,
          allTransitiveDependencies:
              CounterpartyListFamily._allTransitiveDependencies,
          companyId: companyId,
          storeId: storeId,
          counterpartyType: counterpartyType,
        );

  CounterpartyListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
    required this.storeId,
    required this.counterpartyType,
  }) : super.internal();

  final String companyId;
  final String? storeId;
  final String? counterpartyType;

  @override
  FutureOr<List<CounterpartyData>> runNotifierBuild(
    covariant CounterpartyList notifier,
  ) {
    return notifier.build(
      companyId,
      storeId,
      counterpartyType,
    );
  }

  @override
  Override overrideWith(CounterpartyList Function() create) {
    return ProviderOverride(
      origin: this,
      override: CounterpartyListProvider._internal(
        () => create()
          ..companyId = companyId
          ..storeId = storeId
          ..counterpartyType = counterpartyType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
        storeId: storeId,
        counterpartyType: counterpartyType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CounterpartyList,
      List<CounterpartyData>> createElement() {
    return _CounterpartyListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartyListProvider &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.counterpartyType == counterpartyType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);
    hash = _SystemHash.combine(hash, counterpartyType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterpartyListRef
    on AutoDisposeAsyncNotifierProviderRef<List<CounterpartyData>> {
  /// The parameter `companyId` of this provider.
  String get companyId;

  /// The parameter `storeId` of this provider.
  String? get storeId;

  /// The parameter `counterpartyType` of this provider.
  String? get counterpartyType;
}

class _CounterpartyListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CounterpartyList,
        List<CounterpartyData>> with CounterpartyListRef {
  _CounterpartyListProviderElement(super.provider);

  @override
  String get companyId => (origin as CounterpartyListProvider).companyId;
  @override
  String? get storeId => (origin as CounterpartyListProvider).storeId;
  @override
  String? get counterpartyType =>
      (origin as CounterpartyListProvider).counterpartyType;
}

String _$selectedCounterpartyHash() =>
    r'17f20bf32464493a2244b21c5181f80909753678';

/// Single counterparty selection state
///
/// Copied from [SelectedCounterparty].
@ProviderFor(SelectedCounterparty)
final selectedCounterpartyProvider =
    AutoDisposeNotifierProvider<SelectedCounterparty, String?>.internal(
  SelectedCounterparty.new,
  name: r'selectedCounterpartyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCounterpartyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCounterparty = AutoDisposeNotifier<String?>;
String _$selectedCounterpartiesHash() =>
    r'be23ebf975f4ac1db9af8278d7fd5d47ed2594e6';

/// Multiple counterparty selection state
///
/// Copied from [SelectedCounterparties].
@ProviderFor(SelectedCounterparties)
final selectedCounterpartiesProvider =
    AutoDisposeNotifierProvider<SelectedCounterparties, List<String>>.internal(
  SelectedCounterparties.new,
  name: r'selectedCounterpartiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCounterpartiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCounterparties = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
