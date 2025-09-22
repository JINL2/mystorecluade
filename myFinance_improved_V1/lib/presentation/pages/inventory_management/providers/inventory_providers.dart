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
  final String sortBy;
  final String sortDirection;
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
    this.sortBy = 'name',
    this.sortDirection = 'asc',
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
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedStockStatus: selectedStockStatus ?? this.selectedStockStatus,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
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
      );
      
      print('📥 [INVENTORY_NOTIFIER] Service result: $result');
      
      if (result != null) {
        print('✅ [INVENTORY_NOTIFIER] Result is not null');
        print('📦 [INVENTORY_NOTIFIER] Products count: ${result.products.length}');
        print('📄 [INVENTORY_NOTIFIER] Pagination: page=${result.pagination.page}, total=${result.pagination.total}');
        
        if (result.products.isEmpty && result.pagination.total == 0) {
          print('ℹ️ [INVENTORY_NOTIFIER] No products found for this store');
        }
        
        state = state.copyWith(
          products: result.products,
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
      );
      
      if (result != null) {
        state = state.copyWith(
          products: [...state.products, ...result.products],
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

  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      selectedCategory: null,
      selectedBrand: null,
      selectedStockStatus: null,
      sortBy: 'name',
      sortDirection: 'asc',
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