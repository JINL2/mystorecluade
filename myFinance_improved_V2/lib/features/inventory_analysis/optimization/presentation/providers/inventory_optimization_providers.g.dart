// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_optimization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventorySupabaseClientHash() =>
    r'13915ef29ed8bbb85279be71162cd24edae53161';

/// Supabase Client Provider
///
/// Copied from [inventorySupabaseClient].
@ProviderFor(inventorySupabaseClient)
final inventorySupabaseClientProvider =
    AutoDisposeProvider<SupabaseClient>.internal(
  inventorySupabaseClient,
  name: r'inventorySupabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventorySupabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventorySupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$inventoryOptimizationDatasourceHash() =>
    r'0f45a161d24ea9ae33f50b16348e608bfba3f27e';

/// DataSource Provider
///
/// Copied from [inventoryOptimizationDatasource].
@ProviderFor(inventoryOptimizationDatasource)
final inventoryOptimizationDatasourceProvider =
    AutoDisposeProvider<InventoryOptimizationDatasource>.internal(
  inventoryOptimizationDatasource,
  name: r'inventoryOptimizationDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryOptimizationDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryOptimizationDatasourceRef
    = AutoDisposeProviderRef<InventoryOptimizationDatasource>;
String _$inventoryOptimizationRepositoryHash() =>
    r'a1205767b89d0dd055020732d6bfbd2666559a5a';

/// Repository Provider
///
/// Copied from [inventoryOptimizationRepository].
@ProviderFor(inventoryOptimizationRepository)
final inventoryOptimizationRepositoryProvider =
    AutoDisposeProvider<InventoryOptimizationRepository>.internal(
  inventoryOptimizationRepository,
  name: r'inventoryOptimizationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryOptimizationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryOptimizationRepositoryRef
    = AutoDisposeProviderRef<InventoryOptimizationRepository>;
String _$inventoryDashboardHash() =>
    r'4143aaacbc2739efdfabc447dec848e00763de4a';

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

/// 대시보드 데이터 Provider
///
/// Copied from [inventoryDashboard].
@ProviderFor(inventoryDashboard)
const inventoryDashboardProvider = InventoryDashboardFamily();

/// 대시보드 데이터 Provider
///
/// Copied from [inventoryDashboard].
class InventoryDashboardFamily extends Family<AsyncValue<InventoryDashboard>> {
  /// 대시보드 데이터 Provider
  ///
  /// Copied from [inventoryDashboard].
  const InventoryDashboardFamily();

  /// 대시보드 데이터 Provider
  ///
  /// Copied from [inventoryDashboard].
  InventoryDashboardProvider call(
    String companyId,
  ) {
    return InventoryDashboardProvider(
      companyId,
    );
  }

  @override
  InventoryDashboardProvider getProviderOverride(
    covariant InventoryDashboardProvider provider,
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
  String? get name => r'inventoryDashboardProvider';
}

/// 대시보드 데이터 Provider
///
/// Copied from [inventoryDashboard].
class InventoryDashboardProvider
    extends AutoDisposeFutureProvider<InventoryDashboard> {
  /// 대시보드 데이터 Provider
  ///
  /// Copied from [inventoryDashboard].
  InventoryDashboardProvider(
    String companyId,
  ) : this._internal(
          (ref) => inventoryDashboard(
            ref as InventoryDashboardRef,
            companyId,
          ),
          from: inventoryDashboardProvider,
          name: r'inventoryDashboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryDashboardHash,
          dependencies: InventoryDashboardFamily._dependencies,
          allTransitiveDependencies:
              InventoryDashboardFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  InventoryDashboardProvider._internal(
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
    FutureOr<InventoryDashboard> Function(InventoryDashboardRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryDashboardProvider._internal(
        (ref) => create(ref as InventoryDashboardRef),
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
  AutoDisposeFutureProviderElement<InventoryDashboard> createElement() {
    return _InventoryDashboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryDashboardProvider && other.companyId == companyId;
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
mixin InventoryDashboardRef
    on AutoDisposeFutureProviderRef<InventoryDashboard> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _InventoryDashboardProviderElement
    extends AutoDisposeFutureProviderElement<InventoryDashboard>
    with InventoryDashboardRef {
  _InventoryDashboardProviderElement(super.provider);

  @override
  String get companyId => (origin as InventoryDashboardProvider).companyId;
}

String _$categorySummariesHash() => r'fd3a2fea3a9aaa48e8f1af24e9275ed80581d2b7';

/// 카테고리 목록 Provider
///
/// Copied from [categorySummaries].
@ProviderFor(categorySummaries)
const categorySummariesProvider = CategorySummariesFamily();

/// 카테고리 목록 Provider
///
/// Copied from [categorySummaries].
class CategorySummariesFamily
    extends Family<AsyncValue<List<CategorySummary>>> {
  /// 카테고리 목록 Provider
  ///
  /// Copied from [categorySummaries].
  const CategorySummariesFamily();

  /// 카테고리 목록 Provider
  ///
  /// Copied from [categorySummaries].
  CategorySummariesProvider call(
    String companyId,
  ) {
    return CategorySummariesProvider(
      companyId,
    );
  }

  @override
  CategorySummariesProvider getProviderOverride(
    covariant CategorySummariesProvider provider,
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
  String? get name => r'categorySummariesProvider';
}

/// 카테고리 목록 Provider
///
/// Copied from [categorySummaries].
class CategorySummariesProvider
    extends AutoDisposeFutureProvider<List<CategorySummary>> {
  /// 카테고리 목록 Provider
  ///
  /// Copied from [categorySummaries].
  CategorySummariesProvider(
    String companyId,
  ) : this._internal(
          (ref) => categorySummaries(
            ref as CategorySummariesRef,
            companyId,
          ),
          from: categorySummariesProvider,
          name: r'categorySummariesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categorySummariesHash,
          dependencies: CategorySummariesFamily._dependencies,
          allTransitiveDependencies:
              CategorySummariesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CategorySummariesProvider._internal(
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
    FutureOr<List<CategorySummary>> Function(CategorySummariesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategorySummariesProvider._internal(
        (ref) => create(ref as CategorySummariesRef),
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
  AutoDisposeFutureProviderElement<List<CategorySummary>> createElement() {
    return _CategorySummariesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategorySummariesProvider && other.companyId == companyId;
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
mixin CategorySummariesRef
    on AutoDisposeFutureProviderRef<List<CategorySummary>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CategorySummariesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategorySummary>>
    with CategorySummariesRef {
  _CategorySummariesProviderElement(super.provider);

  @override
  String get companyId => (origin as CategorySummariesProvider).companyId;
}

String _$refreshInventoryViewsHash() =>
    r'1b06905e32f421b928aba4ed39475aae2c69a552';

/// Materialized View 새로고침
///
/// Copied from [refreshInventoryViews].
@ProviderFor(refreshInventoryViews)
final refreshInventoryViewsProvider = AutoDisposeFutureProvider<void>.internal(
  refreshInventoryViews,
  name: r'refreshInventoryViewsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshInventoryViewsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefreshInventoryViewsRef = AutoDisposeFutureProviderRef<void>;
String _$inventoryHealthDashboardHash() =>
    r'00fa1d2d37dd0f3ad2c1ff6995b4595d948264f7';

/// 재고 건강도 대시보드 Provider (V2)
/// RPC: inventory_analysis_get_inventory_health_dashboard
///
/// Copied from [inventoryHealthDashboard].
@ProviderFor(inventoryHealthDashboard)
const inventoryHealthDashboardProvider = InventoryHealthDashboardFamily();

/// 재고 건강도 대시보드 Provider (V2)
/// RPC: inventory_analysis_get_inventory_health_dashboard
///
/// Copied from [inventoryHealthDashboard].
class InventoryHealthDashboardFamily
    extends Family<AsyncValue<InventoryHealthDashboard>> {
  /// 재고 건강도 대시보드 Provider (V2)
  /// RPC: inventory_analysis_get_inventory_health_dashboard
  ///
  /// Copied from [inventoryHealthDashboard].
  const InventoryHealthDashboardFamily();

  /// 재고 건강도 대시보드 Provider (V2)
  /// RPC: inventory_analysis_get_inventory_health_dashboard
  ///
  /// Copied from [inventoryHealthDashboard].
  InventoryHealthDashboardProvider call(
    HealthDashboardFilter filter,
  ) {
    return InventoryHealthDashboardProvider(
      filter,
    );
  }

  @override
  InventoryHealthDashboardProvider getProviderOverride(
    covariant InventoryHealthDashboardProvider provider,
  ) {
    return call(
      provider.filter,
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
  String? get name => r'inventoryHealthDashboardProvider';
}

/// 재고 건강도 대시보드 Provider (V2)
/// RPC: inventory_analysis_get_inventory_health_dashboard
///
/// Copied from [inventoryHealthDashboard].
class InventoryHealthDashboardProvider
    extends AutoDisposeFutureProvider<InventoryHealthDashboard> {
  /// 재고 건강도 대시보드 Provider (V2)
  /// RPC: inventory_analysis_get_inventory_health_dashboard
  ///
  /// Copied from [inventoryHealthDashboard].
  InventoryHealthDashboardProvider(
    HealthDashboardFilter filter,
  ) : this._internal(
          (ref) => inventoryHealthDashboard(
            ref as InventoryHealthDashboardRef,
            filter,
          ),
          from: inventoryHealthDashboardProvider,
          name: r'inventoryHealthDashboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryHealthDashboardHash,
          dependencies: InventoryHealthDashboardFamily._dependencies,
          allTransitiveDependencies:
              InventoryHealthDashboardFamily._allTransitiveDependencies,
          filter: filter,
        );

  InventoryHealthDashboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final HealthDashboardFilter filter;

  @override
  Override overrideWith(
    FutureOr<InventoryHealthDashboard> Function(
            InventoryHealthDashboardRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryHealthDashboardProvider._internal(
        (ref) => create(ref as InventoryHealthDashboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InventoryHealthDashboard> createElement() {
    return _InventoryHealthDashboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryHealthDashboardProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InventoryHealthDashboardRef
    on AutoDisposeFutureProviderRef<InventoryHealthDashboard> {
  /// The parameter `filter` of this provider.
  HealthDashboardFilter get filter;
}

class _InventoryHealthDashboardProviderElement
    extends AutoDisposeFutureProviderElement<InventoryHealthDashboard>
    with InventoryHealthDashboardRef {
  _InventoryHealthDashboardProviderElement(super.provider);

  @override
  HealthDashboardFilter get filter =>
      (origin as InventoryHealthDashboardProvider).filter;
}

String _$productListNotifierHash() =>
    r'222f6f31c2b5ac01ba4152499942665b03f95289';

abstract class _$ProductListNotifier
    extends BuildlessAutoDisposeNotifier<ProductListState> {
  late final ProductListFilter filter;

  ProductListState build(
    ProductListFilter filter,
  );
}

/// 상품 목록 Notifier (무한 스크롤)
///
/// Copied from [ProductListNotifier].
@ProviderFor(ProductListNotifier)
const productListNotifierProvider = ProductListNotifierFamily();

/// 상품 목록 Notifier (무한 스크롤)
///
/// Copied from [ProductListNotifier].
class ProductListNotifierFamily extends Family<ProductListState> {
  /// 상품 목록 Notifier (무한 스크롤)
  ///
  /// Copied from [ProductListNotifier].
  const ProductListNotifierFamily();

  /// 상품 목록 Notifier (무한 스크롤)
  ///
  /// Copied from [ProductListNotifier].
  ProductListNotifierProvider call(
    ProductListFilter filter,
  ) {
    return ProductListNotifierProvider(
      filter,
    );
  }

  @override
  ProductListNotifierProvider getProviderOverride(
    covariant ProductListNotifierProvider provider,
  ) {
    return call(
      provider.filter,
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
  String? get name => r'productListNotifierProvider';
}

/// 상품 목록 Notifier (무한 스크롤)
///
/// Copied from [ProductListNotifier].
class ProductListNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ProductListNotifier, ProductListState> {
  /// 상품 목록 Notifier (무한 스크롤)
  ///
  /// Copied from [ProductListNotifier].
  ProductListNotifierProvider(
    ProductListFilter filter,
  ) : this._internal(
          () => ProductListNotifier()..filter = filter,
          from: productListNotifierProvider,
          name: r'productListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productListNotifierHash,
          dependencies: ProductListNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductListNotifierFamily._allTransitiveDependencies,
          filter: filter,
        );

  ProductListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final ProductListFilter filter;

  @override
  ProductListState runNotifierBuild(
    covariant ProductListNotifier notifier,
  ) {
    return notifier.build(
      filter,
    );
  }

  @override
  Override overrideWith(ProductListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductListNotifierProvider._internal(
        () => create()..filter = filter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProductListNotifier, ProductListState>
      createElement() {
    return _ProductListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductListNotifierProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductListNotifierRef
    on AutoDisposeNotifierProviderRef<ProductListState> {
  /// The parameter `filter` of this provider.
  ProductListFilter get filter;
}

class _ProductListNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ProductListNotifier,
        ProductListState> with ProductListNotifierRef {
  _ProductListNotifierProviderElement(super.provider);

  @override
  ProductListFilter get filter =>
      (origin as ProductListNotifierProvider).filter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
