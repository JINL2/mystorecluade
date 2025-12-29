import '../states/session_detail_state.dart';

/// Helper class for managing selected products operations
class SelectedProductsManager {
  const SelectedProductsManager._();

  /// Adds a product to the list if not already present
  static List<SelectedProduct> addProduct(
    List<SelectedProduct> products,
    SelectedProduct newProduct,
  ) {
    final exists = products.any((p) => p.productId == newProduct.productId);
    if (exists) return products;
    return [...products, newProduct];
  }

  /// Removes a product from the list
  static List<SelectedProduct> removeProduct(
    List<SelectedProduct> products,
    String productId,
  ) {
    return products.where((p) => p.productId != productId).toList();
  }

  /// Updates quantity for a specific product
  /// Returns null if product should be removed (both quantities zero)
  static List<SelectedProduct>? updateQuantity(
    List<SelectedProduct> products,
    String productId,
    int quantity,
  ) {
    final product = products.firstWhere(
      (p) => p.productId == productId,
      orElse: () => const SelectedProduct(
        productId: '',
        productName: '',
        quantity: 0,
      ),
    );

    if (product.productId.isEmpty) return products;

    // Remove if both quantities are zero
    if (quantity <= 0 && product.quantityRejected <= 0) {
      return removeProduct(products, productId);
    }

    return products.map((p) {
      if (p.productId == productId) {
        return p.copyWith(quantity: quantity < 0 ? 0 : quantity);
      }
      return p;
    }).toList();
  }

  /// Updates rejected quantity for a specific product
  /// Returns the updated list
  static List<SelectedProduct>? updateQuantityRejected(
    List<SelectedProduct> products,
    String productId,
    int quantityRejected,
  ) {
    final product = products.firstWhere(
      (p) => p.productId == productId,
      orElse: () => const SelectedProduct(
        productId: '',
        productName: '',
        quantity: 0,
      ),
    );

    if (product.productId.isEmpty) return products;

    // Remove if both quantities are zero
    if (quantityRejected <= 0 && product.quantity <= 0) {
      return removeProduct(products, productId);
    }

    return products.map((p) {
      if (p.productId == productId) {
        return p.copyWith(
          quantityRejected: quantityRejected < 0 ? 0 : quantityRejected,
        );
      }
      return p;
    }).toList();
  }

  /// Adds product or increments quantity if already selected
  static List<SelectedProduct> addOrIncrementProduct(
    List<SelectedProduct> products,
    SelectedProduct newProduct,
  ) {
    final existingIndex = products.indexWhere(
      (p) => p.productId == newProduct.productId,
    );

    if (existingIndex >= 0) {
      // Increment quantity
      return products.map((p) {
        if (p.productId == newProduct.productId) {
          return p.copyWith(quantity: p.quantity + 1);
        }
        return p;
      }).toList();
    }

    return [...products, newProduct];
  }

  /// Checks if a product is selected
  static bool isProductSelected(
    List<SelectedProduct> products,
    String productId,
  ) {
    return products.any((p) => p.productId == productId);
  }

  /// Gets a selected product by ID
  static SelectedProduct? getProduct(
    List<SelectedProduct> products,
    String productId,
  ) {
    try {
      return products.firstWhere((p) => p.productId == productId);
    } catch (_) {
      return null;
    }
  }
}
