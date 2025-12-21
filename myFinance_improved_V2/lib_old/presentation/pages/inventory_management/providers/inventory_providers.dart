import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/services/inventory_service.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../providers/app_state_provider.dart';

// Inventory Service Provider
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService();
});

// Inventory Metadata Provider
final inventoryMetadataProvider = FutureProvider.autoDispose<InventoryMetadata?>((ref) async {
  print('🔍 [METADATA_PROVIDER] Starting inventoryMetadataProvider');
  
  final appState = ref.watch(appStateProvider);
  final service = ref.read(inventoryServiceProvider);
  
  print('📋 [METADATA_PROVIDER] AppState: ${appState.toJson()}');
  
  // Handle both String and Map types for backward compatibility
  String? companyId;
  String? storeId;
  
  // Extract company ID
  final companyChoosenValue = appState.companyChoosen;
  print('🏢 [METADATA_PROVIDER] Raw companyChoosen: $companyChoosenValue (${companyChoosenValue.runtimeType})');
  
  if (companyChoosenValue is String && companyChoosenValue.isNotEmpty) {
    companyId = companyChoosenValue;
    print('✅ [METADATA_PROVIDER] Company ID extracted: $companyId');
  } else {
    print('❌ [METADATA_PROVIDER] Company ID not valid: $companyChoosenValue');
  }
  
  // Extract store ID
  final storeChoosenValue = appState.storeChoosen;
  print('🏪 [METADATA_PROVIDER] Raw storeChoosen: $storeChoosenValue (${storeChoosenValue.runtimeType})');
  
  if (storeChoosenValue is String && storeChoosenValue.isNotEmpty) {
    storeId = storeChoosenValue;
    print('✅ [METADATA_PROVIDER] Store ID extracted: $storeId');
  } else {
    print('❌ [METADATA_PROVIDER] Store ID not valid: $storeChoosenValue');
  }
  
  if (companyId == null || companyId.isEmpty || storeId == null || storeId.isEmpty) {
    print('❌ [METADATA_PROVIDER] No company or store selected. CompanyId: $companyId, StoreId: $storeId');
    return null;
  }
  
  print('🚀 [METADATA_PROVIDER] Fetching inventory metadata for company: $companyId, store: $storeId');
  final result = await service.getInventoryMetadata(
    companyId: companyId,
    storeId: storeId,
  );
  
  if (result != null) {
    print('✅ [METADATA_PROVIDER] Metadata fetched successfully');
  } else {
    print('❌ [METADATA_PROVIDER] Failed to fetch metadata');
  }
  
  return result;
});

// Inventory Page State
class InventoryPageState {
  final List<InventoryProduct> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int totalProducts;
  final bool hasNextPage;
  final String? searchQuery;
  final String? selectedCategory;
  final String? selectedBrand;
  final String? selectedStockStatus;
  final String? sortBy;
  final String? sortDirection;
  final Currency? currency;

  InventoryPageState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalProducts = 0,
    this.hasNextPage = false,
    this.searchQuery,
    this.selectedCategory,
    this.selectedBrand,
    this.selectedStockStatus,
    this.sortBy,
    this.sortDirection,
    this.currency,
  });

  InventoryPageState copyWith({
    List<InventoryProduct>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    int? totalProducts,
    bool? hasNextPage,
    String? searchQuery,
    String? selectedCategory,
    String? selectedBrand,
    String? selectedStockStatus,
    String? sortBy,
    String? sortDirection,
    Currency? currency,
    // Special flags to handle explicit null values for filters
    bool clearSearchQuery = false,
    bool clearSelectedCategory = false,
    bool clearSelectedBrand = false,
    bool clearSelectedStockStatus = false,
    bool clearSortBy = false,
    bool clearSortDirection = false,
  }) {
    return InventoryPageState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalProducts: totalProducts ?? this.totalProducts,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedBrand: clearSelectedBrand ? null : (selectedBrand ?? this.selectedBrand),
      selectedStockStatus: clearSelectedStockStatus ? null : (selectedStockStatus ?? this.selectedStockStatus),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
      sortDirection: clearSortDirection ? null : (sortDirection ?? this.sortDirection),
      currency: currency ?? this.currency,
    );
  }
}

// Inventory Page Notifier
class InventoryPageNotifier extends StateNotifier<InventoryPageState> {
  final Ref ref;
  final InventoryService _service;
  Timer? _searchDebounceTimer;
  
  InventoryPageNotifier(this.ref, this._service) : super(InventoryPageState()) {
    _initialize();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    print('🔍 [INVENTORY_NOTIFIER] Initializing...');
    
    // Skip connection test - it's causing unnecessary delays
    // await _service.testConnection();
    
    // Load data immediately
    await loadInitialData();
  }
  
  // Apply client-side filtering to products
  List<InventoryProduct> _filterProducts(List<InventoryProduct> products) {
    var filteredProducts = List<InventoryProduct>.from(products);
    
    print('🔍 [INVENTORY_NOTIFIER] Starting filter - Category: ${state.selectedCategory}, Brand: ${state.selectedBrand}, Stock: ${state.selectedStockStatus}');
    
    // Apply category filter
    if (state.selectedCategory != null) {
      filteredProducts = filteredProducts.where((p) => 
        p.categoryId == state.selectedCategory
      ).toList();
      print('📂 [INVENTORY_NOTIFIER] After category filter: ${filteredProducts.length} products');
    }
    
    // Apply brand filter  
    if (state.selectedBrand != null) {
      filteredProducts = filteredProducts.where((p) => 
        p.brandId == state.selectedBrand
      ).toList();
      print('🏷️ [INVENTORY_NOTIFIER] After brand filter: ${filteredProducts.length} products');
    }
    
    // Apply stock status filter
    if (state.selectedStockStatus != null) {
      if (state.selectedStockStatus == 'error') {
        // Show only products with negative stock
        filteredProducts = filteredProducts.where((p) => p.stock < 0).toList();
        print('❌ [INVENTORY_NOTIFIER] Filtering for error (negative stock) products: ${filteredProducts.length}');
      } else if (state.selectedStockStatus == 'normal') {
        // Show only products with non-negative stock
        filteredProducts = filteredProducts.where((p) => p.stock >= 0).toList();
        print('✅ [INVENTORY_NOTIFIER] Filtering for normal (non-negative stock) products: ${filteredProducts.length}');
      }
    } else {
      print('🔓 [INVENTORY_NOTIFIER] No stock status filter applied - showing all');
    }
    
    print('📊 [INVENTORY_NOTIFIER] Final filtered products: ${filteredProducts.length} from ${products.length}');
    return filteredProducts;
  }
  
  // Apply client-side sorting to products
  List<InventoryProduct> _sortProducts(List<InventoryProduct> products) {
    if (state.sortBy == null || state.sortDirection == null) {
      return products;
    }
    
    // Create a copy to avoid modifying the original list
    final sortedProducts = List<InventoryProduct>.from(products);
    
    switch (state.sortBy) {
      case 'name':
        sortedProducts.sort((a, b) {
          final comparison = a.name.compareTo(b.name);
          return state.sortDirection == 'desc' ? -comparison : comparison;
        });
        break;
      case 'price':
        sortedProducts.sort((a, b) {
          final comparison = a.price.compareTo(b.price);
          return state.sortDirection == 'desc' ? -comparison : comparison;
        });
        break;
      case 'stock':
        sortedProducts.sort((a, b) {
          final comparison = a.stock.compareTo(b.stock);
          return state.sortDirection == 'desc' ? -comparison : comparison;
        });
        break;
      case 'created_at':
        sortedProducts.sort((a, b) {
          // Use createdAt if available, otherwise fall back to ID comparison
          if (a.createdAt != null && b.createdAt != null) {
            final comparison = a.createdAt!.compareTo(b.createdAt!);
            return state.sortDirection == 'desc' ? -comparison : comparison;
          }
          // Fallback to ID comparison
          final comparison = a.id.compareTo(b.id);
          return state.sortDirection == 'desc' ? -comparison : comparison;
        });
        break;
    }
    
    print('🔄 [INVENTORY_NOTIFIER] Applied client-side sorting: ${state.sortBy} ${state.sortDirection}');
    return sortedProducts;
  }

  Future<void> loadInitialData() async {
    print('🔍 [INVENTORY_NOTIFIER] Starting loadInitialData');
    
    if (state.isLoading) {
      print('⏳ [INVENTORY_NOTIFIER] Already loading, skipping');
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    print('✅ [INVENTORY_NOTIFIER] Set loading state to true');
    
    final appState = ref.read(appStateProvider);
    print('📋 [INVENTORY_NOTIFIER] AppState: ${appState.toJson()}');
    
    // Handle both String and Map types for backward compatibility
    String? companyId;
    String? storeId;
    
    // Extract company ID
    final companyChoosenValue = appState.companyChoosen;
    print('🏢 [INVENTORY_NOTIFIER] Raw companyChoosen: $companyChoosenValue (${companyChoosenValue.runtimeType})');
    
    if (companyChoosenValue is String && companyChoosenValue.isNotEmpty) {
      companyId = companyChoosenValue;
      print('✅ [INVENTORY_NOTIFIER] Company ID extracted: $companyId');
    } else {
      print('❌ [INVENTORY_NOTIFIER] Company ID not valid: $companyChoosenValue');
    }
    
    // Extract store ID
    final storeChoosenValue = appState.storeChoosen;
    print('🏪 [INVENTORY_NOTIFIER] Raw storeChoosen: $storeChoosenValue (${storeChoosenValue.runtimeType})');
    
    if (storeChoosenValue is String && storeChoosenValue.isNotEmpty) {
      storeId = storeChoosenValue;
      print('✅ [INVENTORY_NOTIFIER] Store ID extracted: $storeId');
    } else {
      print('❌ [INVENTORY_NOTIFIER] Store ID not valid: $storeChoosenValue');
    }
    
    if (companyId == null || companyId.isEmpty || storeId == null || storeId.isEmpty) {
      print('❌ [INVENTORY_NOTIFIER] No company or store selected. CompanyId: $companyId, StoreId: $storeId');
      state = state.copyWith(
        isLoading: false,
        error: 'Company or store not selected',
      );
      return;
    }
    
    try {
      print('🚀 [INVENTORY_NOTIFIER] Calling getInventoryPage');
      final result = await _service.getInventoryPage(
        companyId: companyId,
        storeId: storeId,
        page: 1,
        limit: 10,
        search: state.searchQuery,
        sortBy: state.sortBy,
        sortDirection: state.sortDirection,
        categoryId: state.selectedCategory,
        brandId: state.selectedBrand,
        stockStatus: state.selectedStockStatus,
      );
      
      print('📥 [INVENTORY_NOTIFIER] Service result: $result');
      
      if (result != null) {
        print('✅ [INVENTORY_NOTIFIER] Result is not null');
        print('📦 [INVENTORY_NOTIFIER] Products count: ${result.products.length}');
        print('📄 [INVENTORY_NOTIFIER] Pagination: page=${result.pagination.page}, total=${result.pagination.total}');
        
        if (result.products.isEmpty && result.pagination.total == 0) {
          print('ℹ️ [INVENTORY_NOTIFIER] No products found for this store');
        }
        
        // Apply client-side filtering and sorting
        final filteredProducts = _filterProducts(result.products);
        final sortedProducts = _sortProducts(filteredProducts);
        
        state = state.copyWith(
          products: sortedProducts,
          currentPage: result.pagination.page,
          totalPages: result.pagination.totalPages,
          totalProducts: result.pagination.total,
          hasNextPage: result.pagination.hasNext,
          currency: result.currency,
          isLoading: false,
          error: null, // Clear any previous errors
        );
        print('✅ [INVENTORY_NOTIFIER] State updated successfully');
      } else {
        print('❌ [INVENTORY_NOTIFIER] Result is null');
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load products',
        );
      }
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_NOTIFIER] Exception caught: $e');
      print('📋 [INVENTORY_NOTIFIER] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    
    state = state.copyWith(isLoadingMore: true);
    
    final appState = ref.read(appStateProvider);
    
    // Handle both String and Map types for backward compatibility
    String? companyId;
    String? storeId;
    
    // Extract company ID
    final companyChoosenValue = appState.companyChoosen;
    if (companyChoosenValue is String && companyChoosenValue.isNotEmpty) {
      companyId = companyChoosenValue;
    }
    
    // Extract store ID
    final storeChoosenValue = appState.storeChoosen;
    if (storeChoosenValue is String && storeChoosenValue.isNotEmpty) {
      storeId = storeChoosenValue;
    }
    
    if (companyId == null || companyId.isEmpty || storeId == null || storeId.isEmpty) return;
    
    try {
      final nextPage = state.currentPage + 1;
      final result = await _service.getInventoryPage(
        companyId: companyId,
        storeId: storeId,
        page: nextPage,
        limit: 10,
        search: state.searchQuery,
        sortBy: state.sortBy,
        sortDirection: state.sortDirection,
        categoryId: state.selectedCategory,
        brandId: state.selectedBrand,
        stockStatus: state.selectedStockStatus,
      );
      
      if (result != null) {
        // For pagination with filters, we need to be careful
        // We should filter the new products and add them to existing filtered products
        // Note: This might not show all products if filter is very restrictive
        // A better approach would be to fetch all products and then filter
        // But for now, we'll filter the new batch and append
        final newFilteredProducts = _filterProducts(result.products);
        final allProducts = [...state.products, ...newFilteredProducts];
        final sortedProducts = _sortProducts(allProducts);
        
        state = state.copyWith(
          products: sortedProducts,
          currentPage: result.pagination.page,
          totalPages: result.pagination.totalPages,
          totalProducts: result.pagination.total,
          hasNextPage: result.pagination.hasNext,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(isLoadingMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      products: [],
      currentPage: 1,
      totalPages: 1,
      totalProducts: 0,
      hasNextPage: false,
    );
    await loadInitialData();
  }

  void setSearchQuery(String? query) {
    if (state.searchQuery != query) {
      state = state.copyWith(searchQuery: query);
      
      // Cancel previous timer if it exists
      _searchDebounceTimer?.cancel();
      
      // Use shorter debounce since TossSearchField already debounces
      // This provides a quick response while preventing excessive API calls
      _searchDebounceTimer = Timer(const Duration(milliseconds: 100), () {
        refresh();
      });
    }
  }

  void setCategory(String? categoryId) {
    if (state.selectedCategory != categoryId) {
      state = state.copyWith(selectedCategory: categoryId);
      refresh();
    }
  }

  void setBrand(String? brandId) {
    if (state.selectedBrand != brandId) {
      state = state.copyWith(selectedBrand: brandId);
      refresh();
    }
  }

  void setStockStatus(String? status) {
    if (state.selectedStockStatus != status) {
      state = state.copyWith(selectedStockStatus: status);
      refresh();
    }
  }

  void setSorting(String sortBy, String sortDirection) {
    if (state.sortBy != sortBy || state.sortDirection != sortDirection) {
      state = state.copyWith(
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      refresh();
    }
  }

  // Set multiple filters at once to avoid multiple refreshes
  void setFilters({
    String? categoryId,
    String? brandId,
    String? stockStatus,
  }) {
    // Check if any filter has actually changed
    bool hasChanged = false;
    
    if (state.selectedCategory != categoryId) {
      hasChanged = true;
    }
    if (state.selectedBrand != brandId) {
      hasChanged = true;
    }
    if (state.selectedStockStatus != stockStatus) {
      hasChanged = true;
    }
    
    // Only update and refresh if something changed
    if (hasChanged) {
      // Use clear flags when we want to explicitly set to null
      state = state.copyWith(
        selectedCategory: categoryId,
        selectedBrand: brandId,
        selectedStockStatus: stockStatus,
        clearSelectedCategory: categoryId == null,
        clearSelectedBrand: brandId == null,
        clearSelectedStockStatus: stockStatus == null,
      );
      print('🔄 [INVENTORY_NOTIFIER] Filters updated - Category: $categoryId, Brand: $brandId, Stock: $stockStatus');
      refresh();
    }
  }
  
  void clearFilters() {
    state = state.copyWith(
      clearSearchQuery: true,
      clearSelectedCategory: true,
      clearSelectedBrand: true,
      clearSelectedStockStatus: true,
      clearSortBy: true,
      clearSortDirection: true,
    );
    refresh();
  }
}

// Main Inventory Page Provider
final inventoryPageProvider = StateNotifierProvider.autoDispose<InventoryPageNotifier, InventoryPageState>((ref) {
  final service = ref.watch(inventoryServiceProvider);
  
  // Watch for company/store changes
  ref.watch(appStateProvider.select((state) => state.companyChoosen));
  ref.watch(appStateProvider.select((state) => state.storeChoosen));
  
  return InventoryPageNotifier(ref, service);
});