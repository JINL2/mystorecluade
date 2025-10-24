import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/sales_product_remote_datasource.dart';
import '../../data/repositories/sales_product_repository_impl.dart';
import '../../domain/repositories/sales_product_repository.dart';
import '../../domain/value_objects/sort_option.dart';
import 'states/sales_product_state.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Remote data source provider
final salesProductRemoteDataSourceProvider = Provider<SalesProductRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SalesProductRemoteDataSource(client);
});

/// Repository provider
final salesProductRepositoryProvider = Provider<SalesProductRepository>((ref) {
  final dataSource = ref.watch(salesProductRemoteDataSourceProvider);
  return SalesProductRepositoryImpl(dataSource);
});

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
    print('🔍 [SALES_PRODUCT] Loading products with search: $search');

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      print('📋 [SALES_PRODUCT] Company: $companyId, Store: $storeId');

      if (companyId.isEmpty || storeId.isEmpty) {
        print('❌ [SALES_PRODUCT] No company or store selected');
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

      print('✅ [SALES_PRODUCT] Products loaded: ${products.length}');

      state = state.copyWith(
        products: products,
        isLoading: false,
        searchQuery: search ?? state.searchQuery,
        currentPage: 1,
        hasNextPage: false,
      );
    } catch (e) {
      print('❌ [SALES_PRODUCT] Error loading products: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading products: $e',
        products: [],
      );
    }
  }

  /// Search products
  void search(String query) {
    print('🔍 [SALES_PRODUCT] Searching for: $query');
    state = state.copyWith(searchQuery: query);
  }

  /// Update sort option
  void updateSort(SortOption sortOption) {
    print('🔄 [SALES_PRODUCT] Updating sort: $sortOption');
    state = state.copyWith(sortOption: sortOption);
  }

  /// Refresh products
  Future<void> refresh() async {
    print('🔄 [SALES_PRODUCT] Refreshing products');
    state = state.copyWith(isRefreshing: true);
    await loadProducts();
    state = state.copyWith(isRefreshing: false);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
