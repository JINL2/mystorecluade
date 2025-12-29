// Presentation Providers: Inventory Management
// Riverpod providers for inventory feature using @riverpod annotation

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/inventory_providers.dart';
import '../../domain/constants/inventory_constants.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../../domain/value_objects/sort_option.dart';
import 'states/inventory_metadata_state.dart';
import 'states/inventory_page_state.dart';

part 'inventory_providers.g.dart';

// ============================================================================
// Metadata Provider
// ============================================================================

/// Inventory Metadata Notifier
/// Fetches categories, brands, units, etc.
@riverpod
class InventoryMetadataNotifier extends _$InventoryMetadataNotifier {
  @override
  InventoryMetadataState build() {
    // Get dependencies
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    // Initialize asynchronously
    if (companyId != null && storeId != null) {
      _loadMetadata(companyId, storeId);
    } else {
      return const InventoryMetadataState(
        error: 'Company or store not selected',
        isLoading: false,
      );
    }

    return const InventoryMetadataState(isLoading: true);
  }

  Future<void> _loadMetadata(String companyId, String storeId) async {
    final repository = ref.read(inventoryRepositoryProvider);

    try {
      final metadata = await repository.getMetadata(
        companyId: companyId,
        storeId: storeId,
      );

      state = state.copyWith(
        metadata: metadata,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    if (companyId == null || storeId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    await _loadMetadata(companyId, storeId);
  }
}

// ============================================================================
// Main Inventory Page Provider
// ============================================================================

/// Inventory Page Notifier
/// Manages product list, filters, sorting, and pagination
@riverpod
class InventoryPageNotifier extends _$InventoryPageNotifier {
  Timer? _searchDebounceTimer;

  @override
  InventoryPageState build() {
    // Get dependencies
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    // Cancel timer on dispose
    ref.onDispose(() {
      _searchDebounceTimer?.cancel();
    });

    // Initialize asynchronously
    if (companyId != null && storeId != null) {
      _initialize(companyId, storeId);
    } else {
      return const InventoryPageState(
        error: 'Company or store not selected',
        isLoading: false,
      );
    }

    return const InventoryPageState(isLoading: true);
  }

  Future<void> _initialize(String companyId, String storeId) async {
    await loadInitialData();
  }

  /// Load initial products
  Future<void> loadInitialData() async {
    final repository = ref.read(inventoryRepositoryProvider);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    if (companyId == null || storeId == null) return;
    if (state.isLoading && state.products.isNotEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load base currency first
      await _loadBaseCurrency(repository, companyId);

      final filter = ProductFilter(
        searchQuery: state.searchQuery,
        categoryId: state.selectedCategoryId,
        brandId: state.selectedBrandId,
        stockStatus: state.selectedStockStatus,
      );

      final sortOption = state.sortBy != null && state.sortDirection != null
          ? SortOption(
              field: _getSortField(state.sortBy!),
              direction: _getSortDirection(state.sortDirection!),
            )
          : SortOption.defaultOption;

      final result = await repository.getProducts(
        companyId: companyId,
        storeId: storeId,
        pagination: const PaginationParams(),
        filter: filter,
        sortOption: sortOption,
      );

      if (result != null) {
        state = state.copyWith(
          products: result.products,
          pagination: result.pagination,
          currency: result.currency,
          serverTotalValue: result.serverTotalValue,
          filteredCount: result.filteredCount,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load products',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load base currency from get_base_currency RPC
  Future<void> _loadBaseCurrency(
    InventoryRepository repository,
    String companyId,
  ) async {
    try {
      final result = await repository.getBaseCurrency(companyId: companyId);
      if (result != null) {
        state = state.copyWith(baseCurrency: result.baseCurrency);
      }
    } catch (e) {
      // Log error but don't fail the whole operation
      // ignore: avoid_print
      print('[InventoryPageNotifier] Failed to load base currency: $e');
    }
  }

  /// Load next page (pagination)
  Future<void> loadNextPage() async {
    final repository = ref.read(inventoryRepositoryProvider);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen as String?;
    final storeId = appState.storeChoosen as String?;

    if (companyId == null || storeId == null) return;
    if (state.isLoadingMore || !state.canLoadMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final filter = ProductFilter(
        searchQuery: state.searchQuery,
        categoryId: state.selectedCategoryId,
        brandId: state.selectedBrandId,
        stockStatus: state.selectedStockStatus,
      );

      final sortOption = state.sortBy != null && state.sortDirection != null
          ? SortOption(
              field: _getSortField(state.sortBy!),
              direction: _getSortDirection(state.sortDirection!),
            )
          : SortOption.defaultOption;

      final nextPage = state.pagination.page + 1;
      final result = await repository.getProducts(
        companyId: companyId,
        storeId: storeId,
        pagination: PaginationParams(page: nextPage),
        filter: filter,
        sortOption: sortOption,
      );

      if (result != null) {
        final allProducts = [...state.products, ...result.products];
        state = state.copyWith(
          products: allProducts,
          pagination: result.pagination,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    state = state.copyWith(
      products: [],
      pagination: const PaginationResult(
        page: PaginationParams.defaultPageNumber,
        limit: PaginationParams.defaultPageSize,
        total: 0,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false,
      ),
    );
    await loadInitialData();
  }

  /// Add product to list if not already present (for search result navigation)
  void addProductIfNotExists(Product product) {
    final exists = state.products.any((p) => p.id == product.id);
    if (!exists) {
      state = state.copyWith(products: [...state.products, product]);
    }
  }

  /// Set search query with debounce
  void setSearchQuery(String? query) {
    if (state.searchQuery != query) {
      state = state.copyWith(searchQuery: query);

      _searchDebounceTimer?.cancel();
      _searchDebounceTimer = Timer(InventoryConstants.searchDebounceDelay, () {
        refresh();
      });
    }
  }

  /// Set category filter
  void setCategory(String? categoryId) {
    if (state.selectedCategoryId != categoryId) {
      state = state.copyWith(selectedCategoryId: categoryId);
      refresh();
    }
  }

  /// Set brand filter
  void setBrand(String? brandId) {
    if (state.selectedBrandId != brandId) {
      state = state.copyWith(selectedBrandId: brandId);
      refresh();
    }
  }

  /// Set stock status filter
  void setStockStatus(String? status) {
    if (state.selectedStockStatus != status) {
      state = state.copyWith(selectedStockStatus: status);
      refresh();
    }
  }

  /// Set sorting
  void setSorting(String sortBy, String sortDirection) {
    if (state.sortBy != sortBy || state.sortDirection != sortDirection) {
      state = state.copyWith(
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      refresh();
    }
  }

  /// Set multiple filters at once
  void setFilters({
    String? categoryId,
    String? brandId,
    String? stockStatus,
  }) {
    final hasChanged = state.selectedCategoryId != categoryId ||
        state.selectedBrandId != brandId ||
        state.selectedStockStatus != stockStatus;

    if (hasChanged) {
      state = state.copyWith(
        selectedCategoryId: categoryId,
        selectedBrandId: brandId,
        selectedStockStatus: stockStatus,
      );
      refresh();
    }
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      selectedCategoryId: null,
      selectedBrandId: null,
      selectedStockStatus: null,
      sortBy: null,
      sortDirection: null,
    );
    refresh();
  }

  // Helper methods
  SortField _getSortField(String field) {
    switch (field) {
      case 'name':
        return SortField.name;
      case 'price':
        return SortField.price;
      case 'stock':
        return SortField.stock;
      case 'created_at':
        return SortField.createdAt;
      default:
        return SortField.name;
    }
  }

  SortDirection _getSortDirection(String direction) {
    return direction == 'desc' ? SortDirection.desc : SortDirection.asc;
  }
}
