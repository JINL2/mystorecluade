// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$optimizedCounterPartyDataHash() =>
    r'5d98141edd64f34dde51004345804e53f5fd1b33';

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

/// Optimized base provider - Single source of truth
///
/// Copied from [optimizedCounterPartyData].
@ProviderFor(optimizedCounterPartyData)
const optimizedCounterPartyDataProvider = OptimizedCounterPartyDataFamily();

/// Optimized base provider - Single source of truth
///
/// Copied from [optimizedCounterPartyData].
class OptimizedCounterPartyDataFamily
    extends Family<AsyncValue<CounterPartyData>> {
  /// Optimized base provider - Single source of truth
  ///
  /// Copied from [optimizedCounterPartyData].
  const OptimizedCounterPartyDataFamily();

  /// Optimized base provider - Single source of truth
  ///
  /// Copied from [optimizedCounterPartyData].
  OptimizedCounterPartyDataProvider call(
    String companyId,
  ) {
    return OptimizedCounterPartyDataProvider(
      companyId,
    );
  }

  @override
  OptimizedCounterPartyDataProvider getProviderOverride(
    covariant OptimizedCounterPartyDataProvider provider,
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
  String? get name => r'optimizedCounterPartyDataProvider';
}

/// Optimized base provider - Single source of truth
///
/// Copied from [optimizedCounterPartyData].
class OptimizedCounterPartyDataProvider
    extends AutoDisposeFutureProvider<CounterPartyData> {
  /// Optimized base provider - Single source of truth
  ///
  /// Copied from [optimizedCounterPartyData].
  OptimizedCounterPartyDataProvider(
    String companyId,
  ) : this._internal(
          (ref) => optimizedCounterPartyData(
            ref as OptimizedCounterPartyDataRef,
            companyId,
          ),
          from: optimizedCounterPartyDataProvider,
          name: r'optimizedCounterPartyDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$optimizedCounterPartyDataHash,
          dependencies: OptimizedCounterPartyDataFamily._dependencies,
          allTransitiveDependencies:
              OptimizedCounterPartyDataFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  OptimizedCounterPartyDataProvider._internal(
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
    FutureOr<CounterPartyData> Function(OptimizedCounterPartyDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OptimizedCounterPartyDataProvider._internal(
        (ref) => create(ref as OptimizedCounterPartyDataRef),
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
  AutoDisposeFutureProviderElement<CounterPartyData> createElement() {
    return _OptimizedCounterPartyDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OptimizedCounterPartyDataProvider &&
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
mixin OptimizedCounterPartyDataRef
    on AutoDisposeFutureProviderRef<CounterPartyData> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _OptimizedCounterPartyDataProviderElement
    extends AutoDisposeFutureProviderElement<CounterPartyData>
    with OptimizedCounterPartyDataRef {
  _OptimizedCounterPartyDataProviderElement(super.provider);

  @override
  String get companyId =>
      (origin as OptimizedCounterPartyDataProvider).companyId;
}

String _$selectedCompanyIdHash() => r'ee6a2952c9e7ab00932ec83fb00730b114910c5d';

/// See also [selectedCompanyId].
@ProviderFor(selectedCompanyId)
final selectedCompanyIdProvider = AutoDisposeProvider<String?>.internal(
  selectedCompanyId,
  name: r'selectedCompanyIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCompanyIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedCompanyIdRef = AutoDisposeProviderRef<String?>;
String _$optimizedCounterPartiesHash() =>
    r'798c60739e7a10baa137ddd03cbee75cd9b11e3d';

/// Optimized counter parties provider - derived from base data
///
/// Copied from [optimizedCounterParties].
@ProviderFor(optimizedCounterParties)
final optimizedCounterPartiesProvider =
    AutoDisposeProvider<AsyncValue<List<CounterParty>>>.internal(
  optimizedCounterParties,
  name: r'optimizedCounterPartiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$optimizedCounterPartiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OptimizedCounterPartiesRef
    = AutoDisposeProviderRef<AsyncValue<List<CounterParty>>>;
String _$optimizedCounterPartyStatsHash() =>
    r'2376d2a12cebfada8206d26cb575913623fc7aca';

/// Optimized stats provider
///
/// Copied from [optimizedCounterPartyStats].
@ProviderFor(optimizedCounterPartyStats)
final optimizedCounterPartyStatsProvider =
    AutoDisposeProvider<AsyncValue<CounterPartyStats>>.internal(
  optimizedCounterPartyStats,
  name: r'optimizedCounterPartyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$optimizedCounterPartyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OptimizedCounterPartyStatsRef
    = AutoDisposeProviderRef<AsyncValue<CounterPartyStats>>;
String _$createCounterPartyHash() =>
    r'2bcfe859c639847abcb14ccf793c24830efdadff';

/// Create counter party provider
///
/// Copied from [createCounterParty].
@ProviderFor(createCounterParty)
const createCounterPartyProvider = CreateCounterPartyFamily();

/// Create counter party provider
///
/// Copied from [createCounterParty].
class CreateCounterPartyFamily extends Family<AsyncValue<CounterParty>> {
  /// Create counter party provider
  ///
  /// Copied from [createCounterParty].
  const CreateCounterPartyFamily();

  /// Create counter party provider
  ///
  /// Copied from [createCounterParty].
  CreateCounterPartyProvider call(
    CreateCounterPartyParams params,
  ) {
    return CreateCounterPartyProvider(
      params,
    );
  }

  @override
  CreateCounterPartyProvider getProviderOverride(
    covariant CreateCounterPartyProvider provider,
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
  String? get name => r'createCounterPartyProvider';
}

/// Create counter party provider
///
/// Copied from [createCounterParty].
class CreateCounterPartyProvider
    extends AutoDisposeFutureProvider<CounterParty> {
  /// Create counter party provider
  ///
  /// Copied from [createCounterParty].
  CreateCounterPartyProvider(
    CreateCounterPartyParams params,
  ) : this._internal(
          (ref) => createCounterParty(
            ref as CreateCounterPartyRef,
            params,
          ),
          from: createCounterPartyProvider,
          name: r'createCounterPartyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createCounterPartyHash,
          dependencies: CreateCounterPartyFamily._dependencies,
          allTransitiveDependencies:
              CreateCounterPartyFamily._allTransitiveDependencies,
          params: params,
        );

  CreateCounterPartyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CreateCounterPartyParams params;

  @override
  Override overrideWith(
    FutureOr<CounterParty> Function(CreateCounterPartyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateCounterPartyProvider._internal(
        (ref) => create(ref as CreateCounterPartyRef),
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
  AutoDisposeFutureProviderElement<CounterParty> createElement() {
    return _CreateCounterPartyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCounterPartyProvider && other.params == params;
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
mixin CreateCounterPartyRef on AutoDisposeFutureProviderRef<CounterParty> {
  /// The parameter `params` of this provider.
  CreateCounterPartyParams get params;
}

class _CreateCounterPartyProviderElement
    extends AutoDisposeFutureProviderElement<CounterParty>
    with CreateCounterPartyRef {
  _CreateCounterPartyProviderElement(super.provider);

  @override
  CreateCounterPartyParams get params =>
      (origin as CreateCounterPartyProvider).params;
}

String _$updateCounterPartyHash() =>
    r'7f053d134561838212b0a1dc4bd55a7e8a856749';

/// Update counter party provider
///
/// Copied from [updateCounterParty].
@ProviderFor(updateCounterParty)
const updateCounterPartyProvider = UpdateCounterPartyFamily();

/// Update counter party provider
///
/// Copied from [updateCounterParty].
class UpdateCounterPartyFamily extends Family<AsyncValue<CounterParty>> {
  /// Update counter party provider
  ///
  /// Copied from [updateCounterParty].
  const UpdateCounterPartyFamily();

  /// Update counter party provider
  ///
  /// Copied from [updateCounterParty].
  UpdateCounterPartyProvider call(
    UpdateCounterPartyParams params,
  ) {
    return UpdateCounterPartyProvider(
      params,
    );
  }

  @override
  UpdateCounterPartyProvider getProviderOverride(
    covariant UpdateCounterPartyProvider provider,
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
  String? get name => r'updateCounterPartyProvider';
}

/// Update counter party provider
///
/// Copied from [updateCounterParty].
class UpdateCounterPartyProvider
    extends AutoDisposeFutureProvider<CounterParty> {
  /// Update counter party provider
  ///
  /// Copied from [updateCounterParty].
  UpdateCounterPartyProvider(
    UpdateCounterPartyParams params,
  ) : this._internal(
          (ref) => updateCounterParty(
            ref as UpdateCounterPartyRef,
            params,
          ),
          from: updateCounterPartyProvider,
          name: r'updateCounterPartyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateCounterPartyHash,
          dependencies: UpdateCounterPartyFamily._dependencies,
          allTransitiveDependencies:
              UpdateCounterPartyFamily._allTransitiveDependencies,
          params: params,
        );

  UpdateCounterPartyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final UpdateCounterPartyParams params;

  @override
  Override overrideWith(
    FutureOr<CounterParty> Function(UpdateCounterPartyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateCounterPartyProvider._internal(
        (ref) => create(ref as UpdateCounterPartyRef),
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
  AutoDisposeFutureProviderElement<CounterParty> createElement() {
    return _UpdateCounterPartyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateCounterPartyProvider && other.params == params;
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
mixin UpdateCounterPartyRef on AutoDisposeFutureProviderRef<CounterParty> {
  /// The parameter `params` of this provider.
  UpdateCounterPartyParams get params;
}

class _UpdateCounterPartyProviderElement
    extends AutoDisposeFutureProviderElement<CounterParty>
    with UpdateCounterPartyRef {
  _UpdateCounterPartyProviderElement(super.provider);

  @override
  UpdateCounterPartyParams get params =>
      (origin as UpdateCounterPartyProvider).params;
}

String _$deleteCounterPartyHash() =>
    r'c82b7cd78d12f1367d8abe86e796704e0b47ff56';

/// Delete counter party provider
///
/// Copied from [deleteCounterParty].
@ProviderFor(deleteCounterParty)
const deleteCounterPartyProvider = DeleteCounterPartyFamily();

/// Delete counter party provider
///
/// Copied from [deleteCounterParty].
class DeleteCounterPartyFamily extends Family<AsyncValue<bool>> {
  /// Delete counter party provider
  ///
  /// Copied from [deleteCounterParty].
  const DeleteCounterPartyFamily();

  /// Delete counter party provider
  ///
  /// Copied from [deleteCounterParty].
  DeleteCounterPartyProvider call(
    String counterpartyId,
  ) {
    return DeleteCounterPartyProvider(
      counterpartyId,
    );
  }

  @override
  DeleteCounterPartyProvider getProviderOverride(
    covariant DeleteCounterPartyProvider provider,
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
  String? get name => r'deleteCounterPartyProvider';
}

/// Delete counter party provider
///
/// Copied from [deleteCounterParty].
class DeleteCounterPartyProvider extends AutoDisposeFutureProvider<bool> {
  /// Delete counter party provider
  ///
  /// Copied from [deleteCounterParty].
  DeleteCounterPartyProvider(
    String counterpartyId,
  ) : this._internal(
          (ref) => deleteCounterParty(
            ref as DeleteCounterPartyRef,
            counterpartyId,
          ),
          from: deleteCounterPartyProvider,
          name: r'deleteCounterPartyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteCounterPartyHash,
          dependencies: DeleteCounterPartyFamily._dependencies,
          allTransitiveDependencies:
              DeleteCounterPartyFamily._allTransitiveDependencies,
          counterpartyId: counterpartyId,
        );

  DeleteCounterPartyProvider._internal(
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
    FutureOr<bool> Function(DeleteCounterPartyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteCounterPartyProvider._internal(
        (ref) => create(ref as DeleteCounterPartyRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteCounterPartyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteCounterPartyProvider &&
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
mixin DeleteCounterPartyRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `counterpartyId` of this provider.
  String get counterpartyId;
}

class _DeleteCounterPartyProviderElement
    extends AutoDisposeFutureProviderElement<bool> with DeleteCounterPartyRef {
  _DeleteCounterPartyProviderElement(super.provider);

  @override
  String get counterpartyId =>
      (origin as DeleteCounterPartyProvider).counterpartyId;
}

String _$unlinkedCompaniesHash() => r'1f63038793a633404580c0d02ec40faf2cc913f6';

/// Get unlinked companies provider
///
/// Copied from [unlinkedCompanies].
@ProviderFor(unlinkedCompanies)
final unlinkedCompaniesProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  unlinkedCompanies,
  name: r'unlinkedCompaniesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unlinkedCompaniesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnlinkedCompaniesRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$counterPartyRefreshHash() =>
    r'782110241b814a7554d38066e84fe6fd4e51f57b';

/// Manual refresh functionality
///
/// Copied from [counterPartyRefresh].
@ProviderFor(counterPartyRefresh)
final counterPartyRefreshProvider =
    AutoDisposeProvider<void Function()>.internal(
  counterPartyRefresh,
  name: r'counterPartyRefreshProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$counterPartyRefreshHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterPartyRefreshRef = AutoDisposeProviderRef<void Function()>;
String _$counterPartyCacheHash() => r'14b23c9880e7da3fbbb178ebb7557ca97a0fbf36';

/// Cache management provider
///
/// Copied from [counterPartyCache].
@ProviderFor(counterPartyCache)
final counterPartyCacheProvider =
    AutoDisposeProvider<CounterPartyCacheManager>.internal(
  counterPartyCache,
  name: r'counterPartyCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$counterPartyCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterPartyCacheRef = AutoDisposeProviderRef<CounterPartyCacheManager>;
String _$counterPartySearchHash() =>
    r'453acd8f6b8e848f03580acb5df769ed981817d9';

/// Search query provider
///
/// Copied from [CounterPartySearch].
@ProviderFor(CounterPartySearch)
final counterPartySearchProvider =
    AutoDisposeNotifierProvider<CounterPartySearch, String>.internal(
  CounterPartySearch.new,
  name: r'counterPartySearchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$counterPartySearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CounterPartySearch = AutoDisposeNotifier<String>;
String _$counterPartyFilterNotifierHash() =>
    r'67d139d4e2458da1a85c4e5729d454be7e9d62a6';

/// Filter provider
///
/// Copied from [CounterPartyFilterNotifier].
@ProviderFor(CounterPartyFilterNotifier)
final counterPartyFilterNotifierProvider = AutoDisposeNotifierProvider<
    CounterPartyFilterNotifier, CounterPartyFilter>.internal(
  CounterPartyFilterNotifier.new,
  name: r'counterPartyFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$counterPartyFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CounterPartyFilterNotifier = AutoDisposeNotifier<CounterPartyFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
