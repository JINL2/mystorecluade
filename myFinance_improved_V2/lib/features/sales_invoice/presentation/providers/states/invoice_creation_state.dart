import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/sales_product.dart';
import '../../../domain/repositories/product_repository.dart';

part 'invoice_creation_state.freezed.dart';

/// Invoice Creation Page State - UI state for invoice creation flow
///
/// Manages product selection, quantities, search, and filtering for invoice creation
@freezed
class InvoiceCreationState with _$InvoiceCreationState {
  const InvoiceCreationState._(); // Private constructor for getters

  const factory InvoiceCreationState({
    ProductListResult? productData,
    @Default({}) Map<String, int> selectedProducts,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String searchQuery,
  }) = _InvoiceCreationState;

  /// Get total number of selected items
  int get totalSelectedItems {
    return selectedProducts.values.fold(0, (sum, count) => sum + count);
  }

  /// Get sorted and filtered products
  List<SalesProduct> get sortedFilteredProducts {
    if (productData == null) return [];

    var products = productData!.products;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      products = products.where((p) {
        return p.productName.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query) ||
            (p.barcode?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort: selected products first, then by availability, then by name
    products.sort((a, b) {
      final aSelected = selectedProducts.containsKey(a.productId);
      final bSelected = selectedProducts.containsKey(b.productId);

      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;

      final aHasStock = a.hasAvailableStock;
      final bHasStock = b.hasAvailableStock;

      if (aHasStock && !bHasStock) return -1;
      if (!aHasStock && bHasStock) return 1;

      return a.productName.compareTo(b.productName);
    });

    return products;
  }
}
