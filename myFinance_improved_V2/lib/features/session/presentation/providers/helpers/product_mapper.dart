import '../../../domain/entities/session_item.dart';
import '../states/session_detail_state.dart';

/// Helper class for mapping products between domain and state representations
class ProductMapper {
  const ProductMapper._();

  /// Maps ProductSearchResult to SearchProductResult (for state)
  static SearchProductResult fromProductSearchResult(ProductSearchResult product) {
    return SearchProductResult(
      productId: product.productId,
      productName: product.productName,
      sku: product.sku,
      barcode: product.barcode,
      imageUrl: product.imageUrl,
      sellingPrice: product.sellingPrice,
      stockQuantity: product.currentStock,
    );
  }

  /// Maps list of ProductSearchResults to SearchProductResults
  static List<SearchProductResult> fromProductSearchResults(
    List<ProductSearchResult> products,
  ) {
    return products.map(fromProductSearchResult).toList();
  }

  /// Creates a SelectedProduct from SearchProductResult
  static SelectedProduct toSelectedProduct(
    SearchProductResult product, {
    int quantity = 1,
    int quantityRejected = 0,
    double? unitPrice,
  }) {
    return SelectedProduct(
      productId: product.productId,
      productName: product.productName,
      sku: product.sku,
      barcode: product.barcode,
      imageUrl: product.imageUrl,
      quantity: quantity,
      quantityRejected: quantityRejected,
      unitPrice: unitPrice ?? product.sellingPrice,
    );
  }
}
