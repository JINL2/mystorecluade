import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/sales_product.dart';
import '../../domain/usecases/get_products_for_sales_usecase.dart';
import 'states/invoice_creation_state.dart';
import 'usecase_providers.dart';

/// Invoice creation state notifier
class InvoiceCreationNotifier extends StateNotifier<InvoiceCreationState> {
  final GetProductsForSalesUseCase _getProductsUseCase;
  final Ref _ref;

  InvoiceCreationNotifier(this._getProductsUseCase, this._ref) : super(const InvoiceCreationState());

  /// Load products
  Future<void> loadProducts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty || storeId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Company or store not selected',
        );
        return;
      }

      final result = await _getProductsUseCase.execute(
        companyId: companyId,
        storeId: storeId,
      );

      state = state.copyWith(
        isLoading: false,
        productData: result,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Search products
  void searchProducts(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update product count
  void updateProductCount(SalesProduct product, int count) {
    final updatedSelection = Map<String, int>.from(state.selectedProducts);

    if (count <= 0) {
      updatedSelection.remove(product.productId);
    } else {
      // Check if quantity exceeds available stock
      if (count > product.availableQuantity) {
        // Optionally, cap at available quantity or show error
        updatedSelection[product.productId] = product.availableQuantity;
      } else {
        updatedSelection[product.productId] = count;
      }
    }

    state = state.copyWith(selectedProducts: updatedSelection);
  }

  /// Get product count
  int getProductCount(String productId) {
    return state.selectedProducts[productId] ?? 0;
  }

  /// Clear all selections
  void clearSelections() {
    state = state.copyWith(selectedProducts: {});
  }

  /// Refresh products
  Future<void> refresh() async {
    await loadProducts();
  }
}

/// Invoice creation provider
final invoiceCreationProvider = StateNotifierProvider<InvoiceCreationNotifier, InvoiceCreationState>((ref) {
  final getProductsUseCase = ref.watch(getProductsForSalesUseCaseProvider);
  return InvoiceCreationNotifier(getProductsUseCase, ref);
});
