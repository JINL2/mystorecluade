import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_item.dart';
import 'states/session_detail_state.dart';

part 'session_detail_provider.g.dart';

/// Provider parameters record
typedef SessionDetailParams = ({
  String sessionId,
  String sessionType,
  String storeId,
  String? sessionName,
});

/// Notifier for session detail state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
@riverpod
class SessionDetailNotifier extends _$SessionDetailNotifier {
  static const int _pageLimit = 15;

  @override
  SessionDetailState build(SessionDetailParams params) {
    return SessionDetailState.initial(
      sessionId: params.sessionId,
      sessionType: params.sessionType,
      storeId: params.storeId,
      sessionName: params.sessionName,
    );
  }

  /// Load user's existing session items (previously added items)
  /// Called on page init to populate selectedProducts with existing items
  Future<void> loadExistingItems() async {
    if (state.isLoadingItems) return;

    state = state.copyWith(
      isLoadingItems: true,
      error: null,
    );

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final getUserSessionItems = ref.read(getUserSessionItemsUseCaseProvider);

      final response = await getUserSessionItems(
        sessionId: state.sessionId,
        userId: userId,
      );

      if (response.hasItems) {
        // Convert aggregated items to SelectedProduct list
        final aggregated = response.aggregatedByProduct;
        final selectedProducts = aggregated.values.map((item) {
          return SelectedProduct(
            productId: item.productId,
            productName: item.productName,
            sku: item.sku,
            imageUrl: item.imageUrl,
            quantity: item.totalQuantity,
            quantityRejected: item.totalRejected,
          );
        }).toList();

        state = state.copyWith(
          selectedProducts: selectedProducts,
          isLoadingItems: false,
        );
      } else {
        state = state.copyWith(isLoadingItems: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingItems: false,
        error: e.toString(),
      );
    }
  }

  /// Load initial inventory list
  Future<void> loadInventory() async {
    if (state.isLoadingInventory) return;

    state = state.copyWith(
      isLoadingInventory: true,
      error: null,
    );

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getInventoryPage = ref.read(getInventoryPageUseCaseProvider);

      final response = await getInventoryPage(
        companyId: companyId,
        storeId: state.storeId,
        page: 1,
        limit: _pageLimit,
      );

      final results = response.products
          .map((p) => SearchProductResult(
                productId: p.productId,
                productName: p.productName,
                sku: p.sku,
                barcode: p.barcode,
                imageUrl: p.imageUrl,
                sellingPrice: p.sellingPrice,
                stockQuantity: p.currentStock,
              ),)
          .toList();

      state = state.copyWith(
        inventoryProducts: results,
        isLoadingInventory: false,
        currentPage: 1,
        hasMoreInventory: response.hasNext,
        totalInventoryCount: response.totalCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingInventory: false,
        error: e.toString(),
      );
    }
  }

  /// Load more inventory items (infinite scroll)
  Future<void> loadMoreInventory() async {
    if (state.isLoadingMoreInventory || !state.hasMoreInventory) return;

    state = state.copyWith(isLoadingMoreInventory: true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getInventoryPage = ref.read(getInventoryPageUseCaseProvider);

      final nextPage = state.currentPage + 1;
      final response = await getInventoryPage(
        companyId: companyId,
        storeId: state.storeId,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        page: nextPage,
        limit: _pageLimit,
      );

      final newResults = response.products
          .map((p) => SearchProductResult(
                productId: p.productId,
                productName: p.productName,
                sku: p.sku,
                barcode: p.barcode,
                imageUrl: p.imageUrl,
                sellingPrice: p.sellingPrice,
                stockQuantity: p.currentStock,
              ),)
          .toList();

      state = state.copyWith(
        inventoryProducts: [...state.inventoryProducts, ...newResults],
        isLoadingMoreInventory: false,
        currentPage: nextPage,
        hasMoreInventory: response.hasNext,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMoreInventory: false,
        error: e.toString(),
      );
    }
  }

  /// Search products by query (uses get_inventory_page_v3 with search param)
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      // Clear search and show inventory list
      state = state.copyWith(
        searchResults: [],
        searchQuery: '',
        isSearching: false,
        isSearchModeActive: false,
        error: null,
      );
      return;
    }

    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
      isSearchModeActive: true,
      error: null,
    );

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getInventoryPage = ref.read(getInventoryPageUseCaseProvider);

      final response = await getInventoryPage(
        companyId: companyId,
        storeId: state.storeId,
        search: query,
        page: 1,
        limit: _pageLimit,
      );

      final results = response.products
          .map((p) => SearchProductResult(
                productId: p.productId,
                productName: p.productName,
                sku: p.sku,
                barcode: p.barcode,
                imageUrl: p.imageUrl,
                sellingPrice: p.sellingPrice,
                stockQuantity: p.currentStock,
              ),)
          .toList();

      state = state.copyWith(
        searchResults: results,
        isSearching: false,
        currentPage: 1,
        hasMoreInventory: response.hasNext,
        totalInventoryCount: response.totalCount,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  /// Load more search results (infinite scroll for search)
  Future<void> loadMoreSearchResults() async {
    if (state.isLoadingMoreInventory ||
        !state.hasMoreInventory ||
        state.searchQuery.isEmpty) {
      return;
    }

    state = state.copyWith(isLoadingMoreInventory: true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getInventoryPage = ref.read(getInventoryPageUseCaseProvider);

      final nextPage = state.currentPage + 1;
      final response = await getInventoryPage(
        companyId: companyId,
        storeId: state.storeId,
        search: state.searchQuery,
        page: nextPage,
        limit: _pageLimit,
      );

      final newResults = response.products
          .map((p) => SearchProductResult(
                productId: p.productId,
                productName: p.productName,
                sku: p.sku,
                barcode: p.barcode,
                imageUrl: p.imageUrl,
                sellingPrice: p.sellingPrice,
                stockQuantity: p.currentStock,
              ),)
          .toList();

      state = state.copyWith(
        searchResults: [...state.searchResults, ...newResults],
        isLoadingMoreInventory: false,
        currentPage: nextPage,
        hasMoreInventory: response.hasNext,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMoreInventory: false,
        error: e.toString(),
      );
    }
  }

  /// Enter search mode
  void enterSearchMode() {
    if (!state.isSearchModeActive) {
      state = state.copyWith(isSearchModeActive: true);
    }
  }

  /// Exit search mode and clear results
  void exitSearchMode() {
    state = state.copyWith(
      isSearchModeActive: false,
      searchResults: [],
      searchQuery: '',
      isSearching: false,
      error: null,
    );
  }

  /// Clear search results only
  void clearSearchResults() {
    state = state.copyWith(
      searchResults: [],
      searchQuery: '',
      isSearching: false,
    );
  }

  /// Add product from search result
  void addProduct(SearchProductResult product) {
    if (state.isProductSelected(product.productId)) {
      return;
    }

    final selected = SelectedProduct(
      productId: product.productId,
      productName: product.productName,
      sku: product.sku,
      barcode: product.barcode,
      imageUrl: product.imageUrl,
      quantity: 1,
      unitPrice: product.sellingPrice,
    );

    state = state.copyWith(
      selectedProducts: [...state.selectedProducts, selected],
    );
  }

  /// Add product and exit search mode atomically
  /// If product already selected, increment quantity
  void addProductAndExitSearch(SearchProductResult product) {
    List<SelectedProduct> updatedProducts;

    if (state.isProductSelected(product.productId)) {
      // Increment quantity if already selected
      updatedProducts = state.selectedProducts.map((p) {
        if (p.productId == product.productId) {
          return p.copyWith(quantity: p.quantity + 1);
        }
        return p;
      }).toList();
    } else {
      // Add new product
      final selected = SelectedProduct(
        productId: product.productId,
        productName: product.productName,
        sku: product.sku,
        barcode: product.barcode,
        imageUrl: product.imageUrl,
        quantity: 1,
        unitPrice: product.sellingPrice,
      );
      updatedProducts = [...state.selectedProducts, selected];
    }

    state = state.copyWith(
      selectedProducts: updatedProducts,
      searchResults: [],
      searchQuery: '',
      isSearching: false,
      isSearchModeActive: false,
      error: null,
    );
  }

  /// Remove a selected product
  void removeProduct(String productId) {
    state = state.copyWith(
      selectedProducts: state.selectedProducts
          .where((p) => p.productId != productId)
          .toList(),
    );
  }

  /// Update product quantity (good condition)
  void updateQuantity(String productId, int quantity) {
    final product = state.getSelectedProduct(productId);
    if (product == null) return;

    // Remove if both quantities are zero
    if (quantity <= 0 && product.quantityRejected <= 0) {
      removeProduct(productId);
      return;
    }

    state = state.copyWith(
      selectedProducts: state.selectedProducts.map((p) {
        if (p.productId == productId) {
          return p.copyWith(quantity: quantity < 0 ? 0 : quantity);
        }
        return p;
      }).toList(),
    );
  }

  /// Update rejected quantity
  void updateQuantityRejected(String productId, int quantityRejected) {
    final product = state.getSelectedProduct(productId);
    if (product == null) return;

    // Remove if both quantities are zero
    if (quantityRejected <= 0 && product.quantity <= 0) {
      removeProduct(productId);
      return;
    }

    state = state.copyWith(
      selectedProducts: state.selectedProducts.map((p) {
        if (p.productId == productId) {
          return p.copyWith(
            quantityRejected: quantityRejected < 0 ? 0 : quantityRejected,
          );
        }
        return p;
      }).toList(),
    );
  }

  /// Increment product quantity (good condition)
  void incrementQuantity(String productId) {
    final product = state.getSelectedProduct(productId);
    if (product != null) {
      updateQuantity(productId, product.quantity + 1);
    }
  }

  /// Decrement product quantity (good condition)
  void decrementQuantity(String productId) {
    final product = state.getSelectedProduct(productId);
    if (product != null) {
      updateQuantity(productId, product.quantity - 1);
    }
  }

  /// Increment rejected quantity
  void incrementQuantityRejected(String productId) {
    final product = state.getSelectedProduct(productId);
    if (product != null) {
      updateQuantityRejected(productId, product.quantityRejected + 1);
    }
  }

  /// Decrement rejected quantity
  void decrementQuantityRejected(String productId) {
    final product = state.getSelectedProduct(productId);
    if (product != null) {
      updateQuantityRejected(productId, product.quantityRejected - 1);
    }
  }

  /// Clear all selected products
  void clearSelectedProducts() {
    state = state.copyWith(selectedProducts: []);
  }

  /// Save items to session via UseCase (uses inventory_update_session_item RPC)
  /// This RPC updates existing items, inserts new ones, and consolidates duplicates
  Future<({bool success, String? error})> saveItems(String userId) async {
    if (state.selectedProducts.isEmpty) {
      return (success: false, error: 'No items to save');
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updateSessionItems = ref.read(updateSessionItemsUseCaseProvider);

      // Build items for UseCase
      final items = state.selectedProducts
          .map((p) => SessionItemInput(
                productId: p.productId,
                quantity: p.quantity,
                quantityRejected: p.quantityRejected,
              ),)
          .toList();

      final response = await updateSessionItems(
        sessionId: state.sessionId,
        userId: userId,
        items: items,
      );

      if (response.success) {
        // Clear selected products after successful save
        state = state.copyWith(
          selectedProducts: [],
          isSaving: false,
        );
        return (success: true, error: null);
      } else {
        const errorMsg = 'Failed to save items';
        state = state.copyWith(isSaving: false, error: errorMsg);
        return (success: false, error: errorMsg);
      }
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isSaving: false, error: errorMsg);
      return (success: false, error: errorMsg);
    }
  }
}
