import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/value_objects/sort_option.dart';
import 'states/sales_product_state.dart';

// Re-export repository provider for external use
export '../../di/sale_product_providers.dart' show salesProductRepositoryProvider;

part 'sales_product_provider.g.dart';

/// Sales product notifier - manages product loading and state
///
/// Uses @Riverpod(keepAlive: true) to persist state across navigation.
/// State is SalesProductState (freezed) for complex UI state management.
@Riverpod(keepAlive: true)
class SalesProductNotifier extends _$SalesProductNotifier {
  static const int _defaultPageSize = 15;

  @override
  SalesProductState build() {
    // 2025 Best Practice: Don't auto-load in build()
    // Let the page control when to load for better optimization
    // This prevents duplicate API calls when page explicitly calls loadProducts()
    return const SalesProductState();
  }

  /// Load products from repository (initial load)
  Future<void> loadProducts({String? search}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a company and store first',
          products: [],
        );
        return;
      }

      final repository = ref.read(salesProductRepositoryProvider);
      final result = await repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: _defaultPageSize,
        search: search ?? state.searchQuery,
      );

      state = state.copyWith(
        products: result.products,
        totalCount: result.totalCount,
        isLoading: false,
        searchQuery: search ?? state.searchQuery,
        currentPage: 1,
        pageSize: _defaultPageSize,
        hasNextPage: result.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading products: $e',
        products: [],
      );
    }
  }

  /// Load next page of products
  Future<void> loadNextPage() async {
    if (!state.canLoadMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(isLoadingMore: false);
        return;
      }

      final nextPage = state.currentPage + 1;
      final repository = ref.read(salesProductRepositoryProvider);
      final result = await repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: nextPage,
        limit: _defaultPageSize,
        search: state.searchQuery,
      );

      // Append new products to existing list, avoiding duplicates
      final existingIds = state.products.map((p) => p.productId).toSet();
      final newProducts = result.products
          .where((p) => !existingIds.contains(p.productId))
          .toList();
      final allProducts = [...state.products, ...newProducts];

      state = state.copyWith(
        products: allProducts,
        isLoadingMore: false,
        currentPage: nextPage,
        hasNextPage: result.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Search products (reset pagination)
  void search(String query) {
    state = state.copyWith(searchQuery: query);
    // Reload from page 1 when search query changes
    loadProducts(search: query);
  }

  /// Update sort option
  void updateSort(SortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  /// Refresh products (reset to page 1) without showing loading spinner
  /// Keeps existing data visible while fetching fresh data
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(isRefreshing: false);
        return;
      }

      final repository = ref.read(salesProductRepositoryProvider);
      final result = await repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: _defaultPageSize,
        search: state.searchQuery,
      );

      state = state.copyWith(
        products: result.products,
        totalCount: result.totalCount,
        isRefreshing: false,
        currentPage: 1,
        pageSize: _defaultPageSize,
        hasNextPage: result.hasNextPage,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'Error refreshing products: $e',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
