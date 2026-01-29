import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/inventory_optimization_datasource.dart';
import '../../data/repositories/inventory_optimization_repository_impl.dart';
import '../../domain/entities/category_summary.dart';
import '../../domain/entities/inventory_dashboard.dart';
import '../../domain/entities/inventory_health_dashboard.dart';
import '../../domain/entities/inventory_product.dart';
import '../../domain/repositories/inventory_optimization_repository.dart';

part 'inventory_optimization_providers.g.dart';

// =============================================================================
// DI Providers
// =============================================================================

/// Supabase Client Provider
@riverpod
SupabaseClient inventorySupabaseClient(InventorySupabaseClientRef ref) {
  return Supabase.instance.client;
}

/// DataSource Provider
@riverpod
InventoryOptimizationDatasource inventoryOptimizationDatasource(
  InventoryOptimizationDatasourceRef ref,
) {
  final client = ref.watch(inventorySupabaseClientProvider);
  return InventoryOptimizationDatasource(client);
}

/// Repository Provider
@riverpod
InventoryOptimizationRepository inventoryOptimizationRepository(
  InventoryOptimizationRepositoryRef ref,
) {
  final datasource = ref.watch(inventoryOptimizationDatasourceProvider);
  return InventoryOptimizationRepositoryImpl(datasource);
}

// =============================================================================
// Dashboard Provider
// =============================================================================

/// 대시보드 데이터 Provider
@riverpod
Future<InventoryDashboard> inventoryDashboard(
  InventoryDashboardRef ref,
  String companyId,
) async {
  final repository = ref.watch(inventoryOptimizationRepositoryProvider);

  final result = await repository.getDashboard(companyId: companyId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (dashboard) => dashboard,
  );
}

// =============================================================================
// Category List Provider
// =============================================================================

/// 카테고리 목록 Provider
@riverpod
Future<List<CategorySummary>> categorySummaries(
  CategorySummariesRef ref,
  String companyId,
) async {
  final repository = ref.watch(inventoryOptimizationRepositoryProvider);

  final result = await repository.getCategorySummaries(companyId: companyId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
}

// =============================================================================
// Product List Notifier (페이지네이션)
// =============================================================================

/// 상품 목록 필터 상태
class ProductListFilter {
  final String companyId;
  final String? categoryId;
  final String? statusFilter;

  const ProductListFilter({
    required this.companyId,
    this.categoryId,
    this.statusFilter,
  });

  ProductListFilter copyWith({
    String? companyId,
    String? categoryId,
    String? statusFilter,
    bool clearCategoryId = false,
    bool clearStatusFilter = false,
  }) {
    return ProductListFilter(
      companyId: companyId ?? this.companyId,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      statusFilter:
          clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductListFilter &&
        other.companyId == companyId &&
        other.categoryId == categoryId &&
        other.statusFilter == statusFilter;
  }

  @override
  int get hashCode =>
      companyId.hashCode ^ categoryId.hashCode ^ statusFilter.hashCode;
}

/// 상품 목록 상태
class ProductListState {
  final List<InventoryProduct> products;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const ProductListState({
    this.products = const [],
    this.totalCount = 0,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ProductListState copyWith({
    List<InventoryProduct>? products,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductListState(
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isEmpty => products.isEmpty && !isLoading;
  bool get hasData => products.isNotEmpty;
  bool get hasError => errorMessage != null;
}

/// 상품 목록 Notifier (무한 스크롤)
@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  static const int _pageSize = 20;
  late ProductListFilter _filter;

  @override
  ProductListState build(ProductListFilter filter) {
    _filter = filter;
    // 초기 로드
    Future.microtask(() => loadInitial());
    return const ProductListState(isLoading: true);
  }

  /// 초기 로드
  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final repository = ref.read(inventoryOptimizationRepositoryProvider);

    final result = await repository.getProductsPaged(
      companyId: _filter.companyId,
      categoryId: _filter.categoryId,
      statusFilter: _filter.statusFilter,
      page: 0,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (paginated) {
        state = state.copyWith(
          products: paginated.items,
          totalCount: paginated.totalCount,
          currentPage: 0,
          hasMore: paginated.hasMore,
          isLoading: false,
        );
      },
    );
  }

  /// 다음 페이지 로드
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final repository = ref.read(inventoryOptimizationRepositoryProvider);
    final nextPage = state.currentPage + 1;

    final result = await repository.getProductsPaged(
      companyId: _filter.companyId,
      categoryId: _filter.categoryId,
      statusFilter: _filter.statusFilter,
      page: nextPage,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (paginated) {
        state = state.copyWith(
          products: [...state.products, ...paginated.items],
          currentPage: nextPage,
          hasMore: paginated.hasMore,
          isLoadingMore: false,
        );
      },
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const ProductListState(isLoading: true);
    await loadInitial();
  }
}

// =============================================================================
// View 새로고침 Provider
// =============================================================================

/// Materialized View 새로고침
@riverpod
Future<void> refreshInventoryViews(RefreshInventoryViewsRef ref) async {
  final repository = ref.read(inventoryOptimizationRepositoryProvider);
  final result = await repository.refreshViews();

  result.fold(
    (failure) => throw Exception(failure.message),
    (_) => null,
  );
}

// =============================================================================
// Health Dashboard Provider (V2)
// =============================================================================

/// Health Dashboard Filter
class HealthDashboardFilter {
  final String companyId;
  final String? storeId;
  final double urgentThreshold;
  final int limit;

  const HealthDashboardFilter({
    required this.companyId,
    this.storeId,
    this.urgentThreshold = 1.0,
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthDashboardFilter &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.urgentThreshold == urgentThreshold &&
        other.limit == limit;
  }

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      urgentThreshold.hashCode ^
      limit.hashCode;
}

/// 재고 건강도 대시보드 Provider (V2)
/// RPC: inventory_analysis_get_inventory_health_dashboard
@riverpod
Future<InventoryHealthDashboard> inventoryHealthDashboard(
  InventoryHealthDashboardRef ref,
  HealthDashboardFilter filter,
) async {
  final repository = ref.watch(inventoryOptimizationRepositoryProvider);

  final result = await repository.getHealthDashboard(
    companyId: filter.companyId,
    storeId: filter.storeId,
    urgentThreshold: filter.urgentThreshold,
    limit: filter.limit,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (dashboard) => dashboard,
  );
}
