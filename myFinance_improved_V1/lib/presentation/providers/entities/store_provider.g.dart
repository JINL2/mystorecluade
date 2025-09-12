// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentStoresHash() => r'e6770455af832c2b672fc9269d1ccac4cd523f80';

/// Current stores based on selected company
///
/// Copied from [currentStores].
@ProviderFor(currentStores)
final currentStoresProvider =
    AutoDisposeFutureProvider<List<StoreData>>.internal(
  currentStores,
  name: r'currentStoresProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentStoresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStoresRef = AutoDisposeFutureProviderRef<List<StoreData>>;
String _$currentActiveStoresHash() =>
    r'26fb6e38fd9e4baf2f3742f7cd6a0f7e010510e7';

/// Current stores with transaction count filter
///
/// Copied from [currentActiveStores].
@ProviderFor(currentActiveStores)
final currentActiveStoresProvider =
    AutoDisposeFutureProvider<List<StoreData>>.internal(
  currentActiveStores,
  name: r'currentActiveStoresProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentActiveStoresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentActiveStoresRef = AutoDisposeFutureProviderRef<List<StoreData>>;
String _$storeByIdHash() => r'da935c56144cc5f4d6d0d10dbb9a18a64adac753';

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

/// Find store by ID
///
/// Copied from [storeById].
@ProviderFor(storeById)
const storeByIdProvider = StoreByIdFamily();

/// Find store by ID
///
/// Copied from [storeById].
class StoreByIdFamily extends Family<AsyncValue<StoreData?>> {
  /// Find store by ID
  ///
  /// Copied from [storeById].
  const StoreByIdFamily();

  /// Find store by ID
  ///
  /// Copied from [storeById].
  StoreByIdProvider call(
    String storeId,
  ) {
    return StoreByIdProvider(
      storeId,
    );
  }

  @override
  StoreByIdProvider getProviderOverride(
    covariant StoreByIdProvider provider,
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
  String? get name => r'storeByIdProvider';
}

/// Find store by ID
///
/// Copied from [storeById].
class StoreByIdProvider extends AutoDisposeFutureProvider<StoreData?> {
  /// Find store by ID
  ///
  /// Copied from [storeById].
  StoreByIdProvider(
    String storeId,
  ) : this._internal(
          (ref) => storeById(
            ref as StoreByIdRef,
            storeId,
          ),
          from: storeByIdProvider,
          name: r'storeByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storeByIdHash,
          dependencies: StoreByIdFamily._dependencies,
          allTransitiveDependencies: StoreByIdFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  StoreByIdProvider._internal(
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
    FutureOr<StoreData?> Function(StoreByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoreByIdProvider._internal(
        (ref) => create(ref as StoreByIdRef),
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
  AutoDisposeFutureProviderElement<StoreData?> createElement() {
    return _StoreByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreByIdProvider && other.storeId == storeId;
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
mixin StoreByIdRef on AutoDisposeFutureProviderRef<StoreData?> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _StoreByIdProviderElement
    extends AutoDisposeFutureProviderElement<StoreData?> with StoreByIdRef {
  _StoreByIdProviderElement(super.provider);

  @override
  String get storeId => (origin as StoreByIdProvider).storeId;
}

String _$storesByIdsHash() => r'e0ea117f4cd731c30bb84fc2547e85a669d3c0a3';

/// Find stores by IDs
///
/// Copied from [storesByIds].
@ProviderFor(storesByIds)
const storesByIdsProvider = StoresByIdsFamily();

/// Find stores by IDs
///
/// Copied from [storesByIds].
class StoresByIdsFamily extends Family<AsyncValue<List<StoreData>>> {
  /// Find stores by IDs
  ///
  /// Copied from [storesByIds].
  const StoresByIdsFamily();

  /// Find stores by IDs
  ///
  /// Copied from [storesByIds].
  StoresByIdsProvider call(
    List<String> storeIds,
  ) {
    return StoresByIdsProvider(
      storeIds,
    );
  }

  @override
  StoresByIdsProvider getProviderOverride(
    covariant StoresByIdsProvider provider,
  ) {
    return call(
      provider.storeIds,
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
  String? get name => r'storesByIdsProvider';
}

/// Find stores by IDs
///
/// Copied from [storesByIds].
class StoresByIdsProvider extends AutoDisposeFutureProvider<List<StoreData>> {
  /// Find stores by IDs
  ///
  /// Copied from [storesByIds].
  StoresByIdsProvider(
    List<String> storeIds,
  ) : this._internal(
          (ref) => storesByIds(
            ref as StoresByIdsRef,
            storeIds,
          ),
          from: storesByIdsProvider,
          name: r'storesByIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storesByIdsHash,
          dependencies: StoresByIdsFamily._dependencies,
          allTransitiveDependencies:
              StoresByIdsFamily._allTransitiveDependencies,
          storeIds: storeIds,
        );

  StoresByIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeIds,
  }) : super.internal();

  final List<String> storeIds;

  @override
  Override overrideWith(
    FutureOr<List<StoreData>> Function(StoresByIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoresByIdsProvider._internal(
        (ref) => create(ref as StoresByIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeIds: storeIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StoreData>> createElement() {
    return _StoresByIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoresByIdsProvider && other.storeIds == storeIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoresByIdsRef on AutoDisposeFutureProviderRef<List<StoreData>> {
  /// The parameter `storeIds` of this provider.
  List<String> get storeIds;
}

class _StoresByIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<StoreData>>
    with StoresByIdsRef {
  _StoresByIdsProviderElement(super.provider);

  @override
  List<String> get storeIds => (origin as StoresByIdsProvider).storeIds;
}

String _$searchStoresHash() => r'3fc076c04051c96d40a466f56949016b87f8eca0';

/// Search stores by name or code
///
/// Copied from [searchStores].
@ProviderFor(searchStores)
const searchStoresProvider = SearchStoresFamily();

/// Search stores by name or code
///
/// Copied from [searchStores].
class SearchStoresFamily extends Family<AsyncValue<List<StoreData>>> {
  /// Search stores by name or code
  ///
  /// Copied from [searchStores].
  const SearchStoresFamily();

  /// Search stores by name or code
  ///
  /// Copied from [searchStores].
  SearchStoresProvider call(
    String searchQuery,
  ) {
    return SearchStoresProvider(
      searchQuery,
    );
  }

  @override
  SearchStoresProvider getProviderOverride(
    covariant SearchStoresProvider provider,
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
  String? get name => r'searchStoresProvider';
}

/// Search stores by name or code
///
/// Copied from [searchStores].
class SearchStoresProvider extends AutoDisposeFutureProvider<List<StoreData>> {
  /// Search stores by name or code
  ///
  /// Copied from [searchStores].
  SearchStoresProvider(
    String searchQuery,
  ) : this._internal(
          (ref) => searchStores(
            ref as SearchStoresRef,
            searchQuery,
          ),
          from: searchStoresProvider,
          name: r'searchStoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchStoresHash,
          dependencies: SearchStoresFamily._dependencies,
          allTransitiveDependencies:
              SearchStoresFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SearchStoresProvider._internal(
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
    FutureOr<List<StoreData>> Function(SearchStoresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchStoresProvider._internal(
        (ref) => create(ref as SearchStoresRef),
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
  AutoDisposeFutureProviderElement<List<StoreData>> createElement() {
    return _SearchStoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchStoresProvider && other.searchQuery == searchQuery;
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
mixin SearchStoresRef on AutoDisposeFutureProviderRef<List<StoreData>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _SearchStoresProviderElement
    extends AutoDisposeFutureProviderElement<List<StoreData>>
    with SearchStoresRef {
  _SearchStoresProviderElement(super.provider);

  @override
  String get searchQuery => (origin as SearchStoresProvider).searchQuery;
}

String _$storeListHash() => r'5d0561ee5cb86c9402a866c191e3224434cf3ef7';

abstract class _$StoreList
    extends BuildlessAutoDisposeAsyncNotifier<List<StoreData>> {
  late final String companyId;

  FutureOr<List<StoreData>> build(
    String companyId,
  );
}

/// See also [StoreList].
@ProviderFor(StoreList)
const storeListProvider = StoreListFamily();

/// See also [StoreList].
class StoreListFamily extends Family<AsyncValue<List<StoreData>>> {
  /// See also [StoreList].
  const StoreListFamily();

  /// See also [StoreList].
  StoreListProvider call(
    String companyId,
  ) {
    return StoreListProvider(
      companyId,
    );
  }

  @override
  StoreListProvider getProviderOverride(
    covariant StoreListProvider provider,
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
  String? get name => r'storeListProvider';
}

/// See also [StoreList].
class StoreListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<StoreList, List<StoreData>> {
  /// See also [StoreList].
  StoreListProvider(
    String companyId,
  ) : this._internal(
          () => StoreList()..companyId = companyId,
          from: storeListProvider,
          name: r'storeListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storeListHash,
          dependencies: StoreListFamily._dependencies,
          allTransitiveDependencies: StoreListFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  StoreListProvider._internal(
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
  FutureOr<List<StoreData>> runNotifierBuild(
    covariant StoreList notifier,
  ) {
    return notifier.build(
      companyId,
    );
  }

  @override
  Override overrideWith(StoreList Function() create) {
    return ProviderOverride(
      origin: this,
      override: StoreListProvider._internal(
        () => create()..companyId = companyId,
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
  AutoDisposeAsyncNotifierProviderElement<StoreList, List<StoreData>>
      createElement() {
    return _StoreListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreListProvider && other.companyId == companyId;
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
mixin StoreListRef on AutoDisposeAsyncNotifierProviderRef<List<StoreData>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _StoreListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StoreList, List<StoreData>>
    with StoreListRef {
  _StoreListProviderElement(super.provider);

  @override
  String get companyId => (origin as StoreListProvider).companyId;
}

String _$selectedStoreHash() => r'e341967b9d4c0904bb70ba412503ad5bba56a612';

/// Single store selection state
///
/// Copied from [SelectedStore].
@ProviderFor(SelectedStore)
final selectedStoreProvider =
    AutoDisposeNotifierProvider<SelectedStore, String?>.internal(
  SelectedStore.new,
  name: r'selectedStoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedStore = AutoDisposeNotifier<String?>;
String _$selectedStoresHash() => r'66c52bfa150f67ee3d0d3766f929e6b378354539';

/// Multiple store selection state
///
/// Copied from [SelectedStores].
@ProviderFor(SelectedStores)
final selectedStoresProvider =
    AutoDisposeNotifierProvider<SelectedStores, List<String>>.internal(
  SelectedStores.new,
  name: r'selectedStoresProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedStoresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedStores = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
