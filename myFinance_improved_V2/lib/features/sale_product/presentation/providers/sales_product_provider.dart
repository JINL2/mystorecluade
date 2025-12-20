import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/repositories/sales_product_repository.dart';
import '../../domain/value_objects/sort_option.dart';
import 'states/sales_product_state.dart';

// Re-export repository provider for external use
export '../../di/sale_product_providers.dart' show salesProductRepositoryProvider;

/// Sales product state provider
final salesProductProvider = StateNotifierProvider<SalesProductNotifier, SalesProductState>((ref) {
  final repository = ref.watch(salesProductRepositoryProvider);
  return SalesProductNotifier(ref, repository);
});

/// Sales product notifier - manages product loading and state
class SalesProductNotifier extends StateNotifier<SalesProductState> {
  final Ref ref;
  final SalesProductRepository _repository;

  static const int _defaultPageSize = 15;

  SalesProductNotifier(this.ref, this._repository) : super(const SalesProductState()) {
    loadProducts();
  }

  /// Safe state update - checks if notifier is still mounted
  void _safeSetState(SalesProductState newState) {
    if (mounted) {
      state = newState;
    }
  }

  /// Load products from repository (initial load)
  Future<void> loadProducts({String? search}) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        _safeSetState(state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a company and store first',
          products: [],
        ));
        return;
      }

      final result = await _repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: _defaultPageSize,
        search: search ?? state.searchQuery,
      );

      _safeSetState(state.copyWith(
        products: result.products,
        totalCount: result.totalCount,
        isLoading: false,
        searchQuery: search ?? state.searchQuery,
        currentPage: 1,
        pageSize: _defaultPageSize,
        hasNextPage: result.hasNextPage,
      ));
    } catch (e) {
      _safeSetState(state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading products: $e',
        products: [],
      ));
    }
  }

  /// Load next page of products
  Future<void> loadNextPage() async {
    if (!mounted) return;
    if (!state.canLoadMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        _safeSetState(state.copyWith(isLoadingMore: false));
        return;
      }

      final nextPage = state.currentPage + 1;
      final result = await _repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: nextPage,
        limit: _defaultPageSize,
        search: state.searchQuery,
      );

      if (!mounted) return;

      // Append new products to existing list, avoiding duplicates
      final existingIds = state.products.map((p) => p.productId).toSet();
      final newProducts = result.products
          .where((p) => !existingIds.contains(p.productId))
          .toList();
      final allProducts = [...state.products, ...newProducts];

      _safeSetState(state.copyWith(
        products: allProducts,
        isLoadingMore: false,
        currentPage: nextPage,
        hasNextPage: result.hasNextPage,
      ));
    } catch (e) {
      _safeSetState(state.copyWith(isLoadingMore: false));
    }
  }

  /// Search products (reset pagination)
  void search(String query) {
    if (!mounted) return;
    state = state.copyWith(searchQuery: query);
    // Reload from page 1 when search query changes
    loadProducts(search: query);
  }

  /// Update sort option
  void updateSort(SortOption sortOption) {
    if (!mounted) return;
    state = state.copyWith(sortOption: sortOption);
  }

  /// Refresh products (reset to page 1)
  Future<void> refresh() async {
    if (!mounted) return;
    state = state.copyWith(isRefreshing: true);
    await loadProducts();
    _safeSetState(state.copyWith(isRefreshing: false));
  }

  /// Clear error message
  void clearError() {
    if (!mounted) return;
    state = state.copyWith(errorMessage: null);
  }
}
