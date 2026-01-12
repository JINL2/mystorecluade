import '../entities/cart_item.dart';
import '../entities/sales_product.dart';
import '../exceptions/sales_exceptions.dart';

/// Add to cart use case
///
/// Business logic for adding products to shopping cart.
/// Allows adding products regardless of stock status (validation at checkout).
/// Supports variant products from get_inventory_page_v6.
class AddToCartUseCase {
  const AddToCartUseCase();

  /// Execute the use case
  ///
  /// Allows adding products to cart regardless of stock status.
  /// Stock validation will be performed at checkout.
  /// Uses variantId as unique identifier for variant products.
  CartItem execute({
    required SalesProduct product,
    int quantity = 1,
  }) {
    // Basic quantity validation only (no stock check)
    if (quantity <= 0) {
      throw const ValidationException('Quantity must be greater than 0');
    }

    // Price validation - prevent 0원 sales from null prices
    final sellingPrice = product.pricing.sellingPrice;
    if (sellingPrice == null || sellingPrice <= 0) {
      throw const ValidationException('Product price is not set or invalid');
    }

    // Get available stock for display purposes
    final availableStock = product.availableQuantity;

    // Generate unique ID: use variantId if exists, otherwise productId
    final uniqueId = product.variantId ?? product.productId;

    // Create cart item with variant support
    // Use effectiveName/effectiveSku for display (includes variant info)
    return CartItem(
      id: uniqueId,
      productId: product.productId,
      variantId: product.variantId,
      sku: product.effectiveSku,
      name: product.effectiveName,
      image: product.images.mainImage,
      price: sellingPrice,
      quantity: quantity,
      available: availableStock,
      customerOrdered: 0, // Will be updated when order is placed
    );
  }
}
