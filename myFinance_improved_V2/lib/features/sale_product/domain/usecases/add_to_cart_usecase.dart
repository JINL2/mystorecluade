import '../entities/cart_item.dart';
import '../entities/sales_product.dart';
import '../exceptions/sales_exceptions.dart';

/// Add to cart use case
///
/// Business logic for adding products to shopping cart.
/// Allows adding products regardless of stock status (validation at checkout).
class AddToCartUseCase {
  const AddToCartUseCase();

  /// Execute the use case
  ///
  /// Allows adding products to cart regardless of stock status.
  /// Stock validation will be performed at checkout.
  CartItem execute({
    required SalesProduct product,
    int quantity = 1,
  }) {
    // Basic quantity validation only (no stock check)
    if (quantity <= 0) {
      throw const ValidationException('Quantity must be greater than 0');
    }

    // Get available stock for display purposes
    final availableStock = product.availableQuantity;

    // Create cart item (allow zero stock products like lib_old)
    return CartItem(
      id: product.productId,
      productId: product.productId,
      sku: product.sku,
      name: product.productName,
      image: product.images.mainImage,
      price: product.pricing.sellingPrice ?? 0,
      quantity: quantity,
      available: availableStock,
      customerOrdered: 0, // Will be updated when order is placed
    );
  }
}
