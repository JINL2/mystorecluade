import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import 'states/session_detail_state.dart';

/// Notifier for session detail state management
class SessionDetailNotifier extends StateNotifier<SessionDetailState> {
  final Ref _ref;
  final SupabaseClient _client;
  final String _companyId;

  SessionDetailNotifier({
    required Ref ref,
    required SupabaseClient client,
    required String companyId,
    required String sessionId,
    required String sessionType,
    required String storeId,
    String? sessionName,
  })  : _ref = ref,
        _client = client,
        _companyId = companyId,
        super(SessionDetailState.initial(
          sessionId: sessionId,
          sessionType: sessionType,
          storeId: storeId,
          sessionName: sessionName,
        ));

  /// Search products by query
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchResults: [],
        searchQuery: '',
        isSearching: false,
        error: null,
      );
      return;
    }

    state = state.copyWith(
      searchQuery: query,
      isSearching: true,
      error: null,
    );

    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_inventory_page_v3',
        params: {
          'p_company_id': _companyId,
          'p_store_id': state.storeId,
          'p_page': 1,
          'p_limit': 20,
          'p_search': query,
          'p_timezone': DateTimeUtils.getLocalTimezone(),
        },
      ).single();

      // Parse response
      Map<String, dynamic> dataToProcess;
      if (response.containsKey('success')) {
        if (response['success'] == true) {
          dataToProcess = response['data'] as Map<String, dynamic>? ?? {};
        } else {
          throw Exception(response['error'] ?? 'Failed to search products');
        }
      } else {
        dataToProcess = response;
      }

      final productsJson = dataToProcess['products'] as List<dynamic>? ?? [];
      final results = productsJson
          .map((json) => SearchProductResult.fromJson(json as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        searchResults: results,
        isSearching: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
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

  /// Save items to session via RPC
  Future<({bool success, String? error})> saveItems(String userId) async {
    if (state.selectedProducts.isEmpty) {
      return (success: false, error: 'No items to save');
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Build items array for RPC
      final items = state.selectedProducts.map((p) => {
        'product_id': p.productId,
        'quantity': p.quantity,
        'quantity_rejected': p.quantityRejected,
      }).toList();

      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_add_session_items',
        params: {
          'p_session_id': state.sessionId,
          'p_user_id': userId,
          'p_items': items,
          'p_timezone': DateTimeUtils.getLocalTimezone(),
        },
      ).single();

      if (response['success'] == true) {
        // Clear selected products after successful save
        state = state.copyWith(
          selectedProducts: [],
          isSaving: false,
        );
        return (success: true, error: null);
      } else {
        final errorMsg = response['error']?.toString() ?? 'Failed to save items';
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

/// Provider parameters record
typedef SessionDetailParams = ({
  String sessionId,
  String sessionType,
  String storeId,
  String? sessionName,
});

/// Provider for session detail
final sessionDetailProvider = StateNotifierProvider.autoDispose
    .family<SessionDetailNotifier, SessionDetailState, SessionDetailParams>(
        (ref, params) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final client = Supabase.instance.client;

  return SessionDetailNotifier(
    ref: ref,
    client: client,
    companyId: companyId,
    sessionId: params.sessionId,
    sessionType: params.sessionType,
    storeId: params.storeId,
    sessionName: params.sessionName,
  );
});
