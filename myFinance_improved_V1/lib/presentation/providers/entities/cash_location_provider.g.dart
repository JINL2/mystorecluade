// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentCashLocationsHash() =>
    r'1281f2dccb952240d956325cd42ce3bd57d5fb9e';

/// Current cash locations based on selected company/store
///
/// Copied from [currentCashLocations].
@ProviderFor(currentCashLocations)
final currentCashLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  currentCashLocations,
  name: r'currentCashLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCashLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCashLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$companyCashLocationsHash() =>
    r'8c75009bb24fb6cf651873387d42c2e1e6d3dc12';

/// Company-wide cash locations (no store filtering)
///
/// Copied from [companyCashLocations].
@ProviderFor(companyCashLocations)
final companyCashLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  companyCashLocations,
  name: r'companyCashLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyCashLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyCashLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$currentCashLocationsByTypeHash() =>
    r'd3a948c67694f541370523c24e8dd669a78a9b72';

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

/// Current cash locations filtered by type
///
/// Copied from [currentCashLocationsByType].
@ProviderFor(currentCashLocationsByType)
const currentCashLocationsByTypeProvider = CurrentCashLocationsByTypeFamily();

/// Current cash locations filtered by type
///
/// Copied from [currentCashLocationsByType].
class CurrentCashLocationsByTypeFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Current cash locations filtered by type
  ///
  /// Copied from [currentCashLocationsByType].
  const CurrentCashLocationsByTypeFamily();

  /// Current cash locations filtered by type
  ///
  /// Copied from [currentCashLocationsByType].
  CurrentCashLocationsByTypeProvider call(
    String locationType,
  ) {
    return CurrentCashLocationsByTypeProvider(
      locationType,
    );
  }

  @override
  CurrentCashLocationsByTypeProvider getProviderOverride(
    covariant CurrentCashLocationsByTypeProvider provider,
  ) {
    return call(
      provider.locationType,
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
  String? get name => r'currentCashLocationsByTypeProvider';
}

/// Current cash locations filtered by type
///
/// Copied from [currentCashLocationsByType].
class CurrentCashLocationsByTypeProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Current cash locations filtered by type
  ///
  /// Copied from [currentCashLocationsByType].
  CurrentCashLocationsByTypeProvider(
    String locationType,
  ) : this._internal(
          (ref) => currentCashLocationsByType(
            ref as CurrentCashLocationsByTypeRef,
            locationType,
          ),
          from: currentCashLocationsByTypeProvider,
          name: r'currentCashLocationsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentCashLocationsByTypeHash,
          dependencies: CurrentCashLocationsByTypeFamily._dependencies,
          allTransitiveDependencies:
              CurrentCashLocationsByTypeFamily._allTransitiveDependencies,
          locationType: locationType,
        );

  CurrentCashLocationsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationType,
  }) : super.internal();

  final String locationType;

  @override
  Override overrideWith(
    FutureOr<List<CashLocationData>> Function(
            CurrentCashLocationsByTypeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentCashLocationsByTypeProvider._internal(
        (ref) => create(ref as CurrentCashLocationsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationType: locationType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CurrentCashLocationsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentCashLocationsByTypeProvider &&
        other.locationType == locationType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentCashLocationsByTypeRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `locationType` of this provider.
  String get locationType;
}

class _CurrentCashLocationsByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CurrentCashLocationsByTypeRef {
  _CurrentCashLocationsByTypeProviderElement(super.provider);

  @override
  String get locationType =>
      (origin as CurrentCashLocationsByTypeProvider).locationType;
}

String _$currentCashLocationsByScopeHash() =>
    r'c48862e5eb85a5a47c4aa7c489f123c72138dd04';

/// Current cash locations filtered by scope (company/store)
///
/// Copied from [currentCashLocationsByScope].
@ProviderFor(currentCashLocationsByScope)
const currentCashLocationsByScopeProvider = CurrentCashLocationsByScopeFamily();

/// Current cash locations filtered by scope (company/store)
///
/// Copied from [currentCashLocationsByScope].
class CurrentCashLocationsByScopeFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Current cash locations filtered by scope (company/store)
  ///
  /// Copied from [currentCashLocationsByScope].
  const CurrentCashLocationsByScopeFamily();

  /// Current cash locations filtered by scope (company/store)
  ///
  /// Copied from [currentCashLocationsByScope].
  CurrentCashLocationsByScopeProvider call(
    TransactionScope scope,
  ) {
    return CurrentCashLocationsByScopeProvider(
      scope,
    );
  }

  @override
  CurrentCashLocationsByScopeProvider getProviderOverride(
    covariant CurrentCashLocationsByScopeProvider provider,
  ) {
    return call(
      provider.scope,
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
  String? get name => r'currentCashLocationsByScopeProvider';
}

/// Current cash locations filtered by scope (company/store)
///
/// Copied from [currentCashLocationsByScope].
class CurrentCashLocationsByScopeProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Current cash locations filtered by scope (company/store)
  ///
  /// Copied from [currentCashLocationsByScope].
  CurrentCashLocationsByScopeProvider(
    TransactionScope scope,
  ) : this._internal(
          (ref) => currentCashLocationsByScope(
            ref as CurrentCashLocationsByScopeRef,
            scope,
          ),
          from: currentCashLocationsByScopeProvider,
          name: r'currentCashLocationsByScopeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentCashLocationsByScopeHash,
          dependencies: CurrentCashLocationsByScopeFamily._dependencies,
          allTransitiveDependencies:
              CurrentCashLocationsByScopeFamily._allTransitiveDependencies,
          scope: scope,
        );

  CurrentCashLocationsByScopeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scope,
  }) : super.internal();

  final TransactionScope scope;

  @override
  Override overrideWith(
    FutureOr<List<CashLocationData>> Function(
            CurrentCashLocationsByScopeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentCashLocationsByScopeProvider._internal(
        (ref) => create(ref as CurrentCashLocationsByScopeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scope: scope,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CurrentCashLocationsByScopeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentCashLocationsByScopeProvider && other.scope == scope;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scope.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentCashLocationsByScopeRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `scope` of this provider.
  TransactionScope get scope;
}

class _CurrentCashLocationsByScopeProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CurrentCashLocationsByScopeRef {
  _CurrentCashLocationsByScopeProviderElement(super.provider);

  @override
  TransactionScope get scope =>
      (origin as CurrentCashLocationsByScopeProvider).scope;
}

String _$currentCompanyCashLocationsHash() =>
    r'288586cedb3ef33fa0bc200a0c2638001fc524ef';

/// Company-wide cash locations only
///
/// Copied from [currentCompanyCashLocations].
@ProviderFor(currentCompanyCashLocations)
final currentCompanyCashLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  currentCompanyCashLocations,
  name: r'currentCompanyCashLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCompanyCashLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCompanyCashLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$currentStoreCashLocationsHash() =>
    r'90e0bd873a41b590d6578f98ad763703280e52aa';

/// Store-specific cash locations only
///
/// Copied from [currentStoreCashLocations].
@ProviderFor(currentStoreCashLocations)
final currentStoreCashLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  currentStoreCashLocations,
  name: r'currentStoreCashLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentStoreCashLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStoreCashLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$currentCashOnlyLocationsHash() =>
    r'c55ee2145a69ba34c205a4b8f0ed9d48271c5104';

/// Cash-type locations only (not bank accounts)
///
/// Copied from [currentCashOnlyLocations].
@ProviderFor(currentCashOnlyLocations)
final currentCashOnlyLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  currentCashOnlyLocations,
  name: r'currentCashOnlyLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCashOnlyLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCashOnlyLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$currentBankAccountLocationsHash() =>
    r'91c0d34d0804b9822f50e6400a5cd66006cc9893';

/// Bank account locations only
///
/// Copied from [currentBankAccountLocations].
@ProviderFor(currentBankAccountLocations)
final currentBankAccountLocationsProvider =
    AutoDisposeFutureProvider<List<CashLocationData>>.internal(
  currentBankAccountLocations,
  name: r'currentBankAccountLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentBankAccountLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentBankAccountLocationsRef
    = AutoDisposeFutureProviderRef<List<CashLocationData>>;
String _$cashLocationByIdHash() => r'413ba2a702bbb02bd1944fd98174d5ae6b5f545f';

/// Find cash location by ID
///
/// Copied from [cashLocationById].
@ProviderFor(cashLocationById)
const cashLocationByIdProvider = CashLocationByIdFamily();

/// Find cash location by ID
///
/// Copied from [cashLocationById].
class CashLocationByIdFamily extends Family<AsyncValue<CashLocationData?>> {
  /// Find cash location by ID
  ///
  /// Copied from [cashLocationById].
  const CashLocationByIdFamily();

  /// Find cash location by ID
  ///
  /// Copied from [cashLocationById].
  CashLocationByIdProvider call(
    String locationId,
  ) {
    return CashLocationByIdProvider(
      locationId,
    );
  }

  @override
  CashLocationByIdProvider getProviderOverride(
    covariant CashLocationByIdProvider provider,
  ) {
    return call(
      provider.locationId,
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
  String? get name => r'cashLocationByIdProvider';
}

/// Find cash location by ID
///
/// Copied from [cashLocationById].
class CashLocationByIdProvider
    extends AutoDisposeFutureProvider<CashLocationData?> {
  /// Find cash location by ID
  ///
  /// Copied from [cashLocationById].
  CashLocationByIdProvider(
    String locationId,
  ) : this._internal(
          (ref) => cashLocationById(
            ref as CashLocationByIdRef,
            locationId,
          ),
          from: cashLocationByIdProvider,
          name: r'cashLocationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationByIdHash,
          dependencies: CashLocationByIdFamily._dependencies,
          allTransitiveDependencies:
              CashLocationByIdFamily._allTransitiveDependencies,
          locationId: locationId,
        );

  CashLocationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationId,
  }) : super.internal();

  final String locationId;

  @override
  Override overrideWith(
    FutureOr<CashLocationData?> Function(CashLocationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationByIdProvider._internal(
        (ref) => create(ref as CashLocationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CashLocationData?> createElement() {
    return _CashLocationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationByIdProvider && other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationByIdRef on AutoDisposeFutureProviderRef<CashLocationData?> {
  /// The parameter `locationId` of this provider.
  String get locationId;
}

class _CashLocationByIdProviderElement
    extends AutoDisposeFutureProviderElement<CashLocationData?>
    with CashLocationByIdRef {
  _CashLocationByIdProviderElement(super.provider);

  @override
  String get locationId => (origin as CashLocationByIdProvider).locationId;
}

String _$cashLocationsByIdsHash() =>
    r'4fb4e4afbe46c8f7557394d326bb25c298801955';

/// Find cash locations by IDs
///
/// Copied from [cashLocationsByIds].
@ProviderFor(cashLocationsByIds)
const cashLocationsByIdsProvider = CashLocationsByIdsFamily();

/// Find cash locations by IDs
///
/// Copied from [cashLocationsByIds].
class CashLocationsByIdsFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Find cash locations by IDs
  ///
  /// Copied from [cashLocationsByIds].
  const CashLocationsByIdsFamily();

  /// Find cash locations by IDs
  ///
  /// Copied from [cashLocationsByIds].
  CashLocationsByIdsProvider call(
    List<String> locationIds,
  ) {
    return CashLocationsByIdsProvider(
      locationIds,
    );
  }

  @override
  CashLocationsByIdsProvider getProviderOverride(
    covariant CashLocationsByIdsProvider provider,
  ) {
    return call(
      provider.locationIds,
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
  String? get name => r'cashLocationsByIdsProvider';
}

/// Find cash locations by IDs
///
/// Copied from [cashLocationsByIds].
class CashLocationsByIdsProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Find cash locations by IDs
  ///
  /// Copied from [cashLocationsByIds].
  CashLocationsByIdsProvider(
    List<String> locationIds,
  ) : this._internal(
          (ref) => cashLocationsByIds(
            ref as CashLocationsByIdsRef,
            locationIds,
          ),
          from: cashLocationsByIdsProvider,
          name: r'cashLocationsByIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationsByIdsHash,
          dependencies: CashLocationsByIdsFamily._dependencies,
          allTransitiveDependencies:
              CashLocationsByIdsFamily._allTransitiveDependencies,
          locationIds: locationIds,
        );

  CashLocationsByIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationIds,
  }) : super.internal();

  final List<String> locationIds;

  @override
  Override overrideWith(
    FutureOr<List<CashLocationData>> Function(CashLocationsByIdsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationsByIdsProvider._internal(
        (ref) => create(ref as CashLocationsByIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationIds: locationIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CashLocationsByIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationsByIdsProvider &&
        other.locationIds == locationIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationsByIdsRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `locationIds` of this provider.
  List<String> get locationIds;
}

class _CashLocationsByIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CashLocationsByIdsRef {
  _CashLocationsByIdsProviderElement(super.provider);

  @override
  List<String> get locationIds =>
      (origin as CashLocationsByIdsProvider).locationIds;
}

String _$cashLocationsByStoreHash() =>
    r'54f90b3e29ddac579d88e56e8ed1415696942d79';

/// Filter cash locations by store ID
///
/// Copied from [cashLocationsByStore].
@ProviderFor(cashLocationsByStore)
const cashLocationsByStoreProvider = CashLocationsByStoreFamily();

/// Filter cash locations by store ID
///
/// Copied from [cashLocationsByStore].
class CashLocationsByStoreFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Filter cash locations by store ID
  ///
  /// Copied from [cashLocationsByStore].
  const CashLocationsByStoreFamily();

  /// Filter cash locations by store ID
  ///
  /// Copied from [cashLocationsByStore].
  CashLocationsByStoreProvider call(
    String storeId,
  ) {
    return CashLocationsByStoreProvider(
      storeId,
    );
  }

  @override
  CashLocationsByStoreProvider getProviderOverride(
    covariant CashLocationsByStoreProvider provider,
  ) {
    return call(
      provider.storeId,
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
  String? get name => r'cashLocationsByStoreProvider';
}

/// Filter cash locations by store ID
///
/// Copied from [cashLocationsByStore].
class CashLocationsByStoreProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Filter cash locations by store ID
  ///
  /// Copied from [cashLocationsByStore].
  CashLocationsByStoreProvider(
    String storeId,
  ) : this._internal(
          (ref) => cashLocationsByStore(
            ref as CashLocationsByStoreRef,
            storeId,
          ),
          from: cashLocationsByStoreProvider,
          name: r'cashLocationsByStoreProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationsByStoreHash,
          dependencies: CashLocationsByStoreFamily._dependencies,
          allTransitiveDependencies:
              CashLocationsByStoreFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  CashLocationsByStoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String storeId;

  @override
  Override overrideWith(
    FutureOr<List<CashLocationData>> Function(CashLocationsByStoreRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CashLocationsByStoreProvider._internal(
        (ref) => create(ref as CashLocationsByStoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CashLocationsByStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationsByStoreProvider && other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationsByStoreRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _CashLocationsByStoreProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CashLocationsByStoreRef {
  _CashLocationsByStoreProviderElement(super.provider);

  @override
  String get storeId => (origin as CashLocationsByStoreProvider).storeId;
}

String _$counterpartyCompanyCashLocationsHash() =>
    r'd0df209039f1443d0debcb348e3347f1abd90a83';

/// Get cash locations for a counterparty company
///
/// Copied from [counterpartyCompanyCashLocations].
@ProviderFor(counterpartyCompanyCashLocations)
const counterpartyCompanyCashLocationsProvider =
    CounterpartyCompanyCashLocationsFamily();

/// Get cash locations for a counterparty company
///
/// Copied from [counterpartyCompanyCashLocations].
class CounterpartyCompanyCashLocationsFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Get cash locations for a counterparty company
  ///
  /// Copied from [counterpartyCompanyCashLocations].
  const CounterpartyCompanyCashLocationsFamily();

  /// Get cash locations for a counterparty company
  ///
  /// Copied from [counterpartyCompanyCashLocations].
  CounterpartyCompanyCashLocationsProvider call(
    String companyId,
  ) {
    return CounterpartyCompanyCashLocationsProvider(
      companyId,
    );
  }

  @override
  CounterpartyCompanyCashLocationsProvider getProviderOverride(
    covariant CounterpartyCompanyCashLocationsProvider provider,
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
  String? get name => r'counterpartyCompanyCashLocationsProvider';
}

/// Get cash locations for a counterparty company
///
/// Copied from [counterpartyCompanyCashLocations].
class CounterpartyCompanyCashLocationsProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Get cash locations for a counterparty company
  ///
  /// Copied from [counterpartyCompanyCashLocations].
  CounterpartyCompanyCashLocationsProvider(
    String companyId,
  ) : this._internal(
          (ref) => counterpartyCompanyCashLocations(
            ref as CounterpartyCompanyCashLocationsRef,
            companyId,
          ),
          from: counterpartyCompanyCashLocationsProvider,
          name: r'counterpartyCompanyCashLocationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartyCompanyCashLocationsHash,
          dependencies: CounterpartyCompanyCashLocationsFamily._dependencies,
          allTransitiveDependencies:
              CounterpartyCompanyCashLocationsFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CounterpartyCompanyCashLocationsProvider._internal(
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
    FutureOr<List<CashLocationData>> Function(
            CounterpartyCompanyCashLocationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartyCompanyCashLocationsProvider._internal(
        (ref) => create(ref as CounterpartyCompanyCashLocationsRef),
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
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CounterpartyCompanyCashLocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartyCompanyCashLocationsProvider &&
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
mixin CounterpartyCompanyCashLocationsRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CounterpartyCompanyCashLocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CounterpartyCompanyCashLocationsRef {
  _CounterpartyCompanyCashLocationsProviderElement(super.provider);

  @override
  String get companyId =>
      (origin as CounterpartyCompanyCashLocationsProvider).companyId;
}

String _$counterpartyStoreCashLocationsHash() =>
    r'2e6c22cdba29e302fa32539594996fa66f8ab193';

/// Get cash locations for a specific counterparty store
///
/// Copied from [counterpartyStoreCashLocations].
@ProviderFor(counterpartyStoreCashLocations)
const counterpartyStoreCashLocationsProvider =
    CounterpartyStoreCashLocationsFamily();

/// Get cash locations for a specific counterparty store
///
/// Copied from [counterpartyStoreCashLocations].
class CounterpartyStoreCashLocationsFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// Get cash locations for a specific counterparty store
  ///
  /// Copied from [counterpartyStoreCashLocations].
  const CounterpartyStoreCashLocationsFamily();

  /// Get cash locations for a specific counterparty store
  ///
  /// Copied from [counterpartyStoreCashLocations].
  CounterpartyStoreCashLocationsProvider call(
    ({String companyId, String storeId}) params,
  ) {
    return CounterpartyStoreCashLocationsProvider(
      params,
    );
  }

  @override
  CounterpartyStoreCashLocationsProvider getProviderOverride(
    covariant CounterpartyStoreCashLocationsProvider provider,
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
  String? get name => r'counterpartyStoreCashLocationsProvider';
}

/// Get cash locations for a specific counterparty store
///
/// Copied from [counterpartyStoreCashLocations].
class CounterpartyStoreCashLocationsProvider
    extends AutoDisposeFutureProvider<List<CashLocationData>> {
  /// Get cash locations for a specific counterparty store
  ///
  /// Copied from [counterpartyStoreCashLocations].
  CounterpartyStoreCashLocationsProvider(
    ({String companyId, String storeId}) params,
  ) : this._internal(
          (ref) => counterpartyStoreCashLocations(
            ref as CounterpartyStoreCashLocationsRef,
            params,
          ),
          from: counterpartyStoreCashLocationsProvider,
          name: r'counterpartyStoreCashLocationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$counterpartyStoreCashLocationsHash,
          dependencies: CounterpartyStoreCashLocationsFamily._dependencies,
          allTransitiveDependencies:
              CounterpartyStoreCashLocationsFamily._allTransitiveDependencies,
          params: params,
        );

  CounterpartyStoreCashLocationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({String companyId, String storeId}) params;

  @override
  Override overrideWith(
    FutureOr<List<CashLocationData>> Function(
            CounterpartyStoreCashLocationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CounterpartyStoreCashLocationsProvider._internal(
        (ref) => create(ref as CounterpartyStoreCashLocationsRef),
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
  AutoDisposeFutureProviderElement<List<CashLocationData>> createElement() {
    return _CounterpartyStoreCashLocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterpartyStoreCashLocationsProvider &&
        other.params == params;
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
mixin CounterpartyStoreCashLocationsRef
    on AutoDisposeFutureProviderRef<List<CashLocationData>> {
  /// The parameter `params` of this provider.
  ({String companyId, String storeId}) get params;
}

class _CounterpartyStoreCashLocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<CashLocationData>>
    with CounterpartyStoreCashLocationsRef {
  _CounterpartyStoreCashLocationsProviderElement(super.provider);

  @override
  ({String companyId, String storeId}) get params =>
      (origin as CounterpartyStoreCashLocationsProvider).params;
}

String _$cashLocationListHash() => r'c22b15619f1d1631d0ea91c825444db8e133c14a';

abstract class _$CashLocationList
    extends BuildlessAutoDisposeAsyncNotifier<List<CashLocationData>> {
  late final String companyId;
  late final String? storeId;
  late final String? locationType;

  FutureOr<List<CashLocationData>> build(
    String companyId, [
    String? storeId,
    String? locationType,
  ]);
}

/// See also [CashLocationList].
@ProviderFor(CashLocationList)
const cashLocationListProvider = CashLocationListFamily();

/// See also [CashLocationList].
class CashLocationListFamily
    extends Family<AsyncValue<List<CashLocationData>>> {
  /// See also [CashLocationList].
  const CashLocationListFamily();

  /// See also [CashLocationList].
  CashLocationListProvider call(
    String companyId, [
    String? storeId,
    String? locationType,
  ]) {
    return CashLocationListProvider(
      companyId,
      storeId,
      locationType,
    );
  }

  @override
  CashLocationListProvider getProviderOverride(
    covariant CashLocationListProvider provider,
  ) {
    return call(
      provider.companyId,
      provider.storeId,
      provider.locationType,
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
  String? get name => r'cashLocationListProvider';
}

/// See also [CashLocationList].
class CashLocationListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CashLocationList, List<CashLocationData>> {
  /// See also [CashLocationList].
  CashLocationListProvider(
    String companyId, [
    String? storeId,
    String? locationType,
  ]) : this._internal(
          () => CashLocationList()
            ..companyId = companyId
            ..storeId = storeId
            ..locationType = locationType,
          from: cashLocationListProvider,
          name: r'cashLocationListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cashLocationListHash,
          dependencies: CashLocationListFamily._dependencies,
          allTransitiveDependencies:
              CashLocationListFamily._allTransitiveDependencies,
          companyId: companyId,
          storeId: storeId,
          locationType: locationType,
        );

  CashLocationListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
    required this.storeId,
    required this.locationType,
  }) : super.internal();

  final String companyId;
  final String? storeId;
  final String? locationType;

  @override
  FutureOr<List<CashLocationData>> runNotifierBuild(
    covariant CashLocationList notifier,
  ) {
    return notifier.build(
      companyId,
      storeId,
      locationType,
    );
  }

  @override
  Override overrideWith(CashLocationList Function() create) {
    return ProviderOverride(
      origin: this,
      override: CashLocationListProvider._internal(
        () => create()
          ..companyId = companyId
          ..storeId = storeId
          ..locationType = locationType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
        storeId: storeId,
        locationType: locationType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CashLocationList,
      List<CashLocationData>> createElement() {
    return _CashLocationListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CashLocationListProvider &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.locationType == locationType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);
    hash = _SystemHash.combine(hash, locationType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CashLocationListRef
    on AutoDisposeAsyncNotifierProviderRef<List<CashLocationData>> {
  /// The parameter `companyId` of this provider.
  String get companyId;

  /// The parameter `storeId` of this provider.
  String? get storeId;

  /// The parameter `locationType` of this provider.
  String? get locationType;
}

class _CashLocationListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CashLocationList,
        List<CashLocationData>> with CashLocationListRef {
  _CashLocationListProviderElement(super.provider);

  @override
  String get companyId => (origin as CashLocationListProvider).companyId;
  @override
  String? get storeId => (origin as CashLocationListProvider).storeId;
  @override
  String? get locationType => (origin as CashLocationListProvider).locationType;
}

String _$selectedCashLocationHash() =>
    r'1c37a5b90247713050f6cc397418f0917e2d1d56';

/// Single cash location selection state
///
/// Copied from [SelectedCashLocation].
@ProviderFor(SelectedCashLocation)
final selectedCashLocationProvider =
    AutoDisposeNotifierProvider<SelectedCashLocation, String?>.internal(
  SelectedCashLocation.new,
  name: r'selectedCashLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCashLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCashLocation = AutoDisposeNotifier<String?>;
String _$selectedCashLocationsHash() =>
    r'58d9cb364c955829a3990b01110d3992771f9dd3';

/// Multiple cash location selection state
///
/// Copied from [SelectedCashLocations].
@ProviderFor(SelectedCashLocations)
final selectedCashLocationsProvider =
    AutoDisposeNotifierProvider<SelectedCashLocations, List<String>>.internal(
  SelectedCashLocations.new,
  name: r'selectedCashLocationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCashLocationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCashLocations = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
