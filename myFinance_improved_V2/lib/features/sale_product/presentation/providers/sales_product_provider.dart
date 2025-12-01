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

  SalesProductNotifier(this.ref, this._repository) : super(const SalesProductState()) {
    loadProducts();
  }

  /// Load products from repository
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

      final products = await _repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: 100,
        search: search ?? state.searchQuery,
      );

      state = state.copyWith(
        products: products,
        isLoading: false,
        searchQuery: search ?? state.searchQuery,
        currentPage: 1,
        hasNextPage: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading products: $e',
        products: [],
      );
    }
  }

  /// Search products
  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update sort option
  void updateSort(SortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  /// Refresh products
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await loadProducts();
    state = state.copyWith(isRefreshing: false);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
