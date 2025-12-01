// Presentation Providers: Inventory Management
// Riverpod providers for inventory feature

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/value_objects/pagination_params.dart';
import '../../domain/value_objects/product_filter.dart';
import '../../domain/value_objects/sort_option.dart';
import 'repository_providers.dart';
import 'states/inventory_metadata_state.dart';
import 'states/inventory_page_state.dart';

// ============================================================================
// Metadata Provider
// ============================================================================

/// Inventory Metadata Provider
/// Fetches categories, brands, units, etc.
final inventoryMetadataProvider =
    StateNotifierProvider.autoDispose<InventoryMetadataNotifier, InventoryMetadataState>(
  (ref) {
    final repository = ref.watch(inventoryRepositoryProvider);
    final appState = ref.watch(appStateProvider);

    return InventoryMetadataNotifier(
      ref: ref,
      repository: repository,
      companyId: appState.companyChoosen as String?,
      storeId: appState.storeChoosen as String?,
    );
  },
);

/// Inventory Metadata Notifier
class InventoryMetadataNotifier extends StateNotifier<InventoryMetadataState> {
  final Ref ref;
  final InventoryRepository repository;
  final String? companyId;
  final String? storeId;

  InventoryMetadataNotifier({
    required this.ref,
    required this.repository,
    required this.companyId,
    required this.storeId,
  }) : super(const InventoryMetadataState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (companyId == null || storeId == null) {
      state = state.copyWith(
        error: 'Company or store not selected',
        isLoading: false,
      );
      return;
    }

    await loadMetadata();
  }

  Future<void> loadMetadata() async {
    if (companyId == null || storeId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final metadata = await repository.getMetadata(
        companyId: companyId!,
        storeId: storeId!,
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

  Future<void> refresh() => loadMetadata();
}

// ============================================================================
// Main Inventory Page Provider
// ============================================================================

/// Inventory Page Provider
/// Manages product list, filters, sorting, and pagination
final inventoryPageProvider =
    StateNotifierProvider.autoDispose<InventoryPageNotifier, InventoryPageState>(
  (ref) {
    final repository = ref.watch(inventoryRepositoryProvider);
    final appState = ref.watch(appStateProvider);

    // Watch for company/store changes
    ref.listen(
      appStateProvider.select((state) => state.companyChoosen),
      (_, __) {
        // Reset and reload when company changes
      },
    );

    ref.listen(
      appStateProvider.select((state) => state.storeChoosen),
      (_, __) {
        // Reset and reload when store changes
      },
    );

    return InventoryPageNotifier(
      ref: ref,
      repository: repository,
      companyId: appState.companyChoosen as String?,
      storeId: appState.storeChoosen as String?,
    );
  },
);

/// Inventory Page Notifier
class InventoryPageNotifier extends StateNotifier<InventoryPageState> {
  final Ref ref;
  final InventoryRepository repository;
  final String? companyId;
  final String? storeId;
  Timer? _searchDebounceTimer;

  InventoryPageNotifier({
    required this.ref,
    required this.repository,
    required this.companyId,
    required this.storeId,
  }) : super(const InventoryPageState()) {
    _initialize();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (companyId == null || storeId == null) {
      state = state.copyWith(
        error: 'Company or store not selected',
        isLoading: false,
      );
      return;
    }

    await loadInitialData();
  }

  /// Load initial products
  Future<void> loadInitialData() async {
    if (companyId == null || storeId == null) return;
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

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

      final result = await repository.getProducts(
        companyId: companyId!,
        storeId: storeId!,
        pagination: const PaginationParams(page: 1, limit: 10),
        filter: filter,
        sortOption: sortOption,
      );

      if (result != null) {
        state = state.copyWith(
          products: result.products,
          pagination: result.pagination,
          currency: result.currency,
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

  /// Load next page (pagination)
  Future<void> loadNextPage() async {
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
        companyId: companyId!,
        storeId: storeId!,
        pagination: PaginationParams(page: nextPage, limit: 10),
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
        page: 1,
        limit: 10,
        total: 0,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false,
      ),
    );
    await loadInitialData();
  }

  /// Set search query with debounce
  void setSearchQuery(String? query) {
    if (state.searchQuery != query) {
      state = state.copyWith(searchQuery: query);

      _searchDebounceTimer?.cancel();
      _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
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
