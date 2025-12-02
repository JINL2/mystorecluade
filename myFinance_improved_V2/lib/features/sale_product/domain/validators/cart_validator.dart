import '../entities/cart_item.dart';
import '../entities/sales_product.dart';
import '../value_objects/stock_status.dart';
import 'cart_validation_result.dart';

/// Pure business rule validator for cart operations
///
/// Contains domain logic for:
/// - Stock availability validation
/// - Quantity limit validation
/// - Cart item business rules
///
/// Note: This validator contains pure functions only - no external dependencies
class CartValidator {
  const CartValidator();

  /// Validates adding a product to cart
  ///
  /// Business rules:
  /// - Product must have available stock
  /// - Quantity must be positive
  /// - Quantity must not exceed available stock
  /// - Warns if requesting large quantities
  CartValidationResult validateAddToCart({
    required SalesProduct product,
    required int quantity,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate quantity is positive
    if (quantity <= 0) {
      errors.add('Quantity must be greater than 0');
    }

    // Validate product has stock
    if (!product.hasAvailableStock) {
      errors.add('Product "${product.productName}" is out of stock');
    }

    // Validate quantity doesn't exceed available stock
    final availableStock = product.availableQuantity;
    if (quantity > availableStock) {
      errors.add(
        'Requested quantity ($quantity) exceeds available stock ($availableStock)',
      );
    }

    // Warning for large quantities (>50% of available stock)
    if (quantity > availableStock * 0.5 && availableStock > 0) {
      warnings.add(
        'Large quantity requested: $quantity of $availableStock available',
      );
    }

    // Warning for products with low stock (using Domain business rule)
    final stockStatus = StockStatus.fromQuantity(availableStock);
    if (stockStatus == StockStatus.lowStock) {
      warnings.add('Low stock alert: Only $availableStock units available');
    }

    return CartValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validates updating cart item quantity
  ///
  /// Business rules:
  /// - New quantity must be non-negative
  /// - New quantity must not exceed available stock
  /// - Quantity of 0 indicates item should be removed
  CartValidationResult validateUpdateQuantity({
    required CartItem item,
    required int newQuantity,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate non-negative quantity
    if (newQuantity < 0) {
      errors.add('Quantity cannot be negative');
    }

    // Quantity of 0 is valid (means remove item)
    if (newQuantity == 0) {
      warnings.add('Quantity of 0 will remove item from cart');
    }

    // Validate doesn't exceed available stock
    if (newQuantity > item.available) {
      errors.add(
        'Requested quantity ($newQuantity) exceeds available stock (${item.available})',
      );
    }

    // Warning for large quantities
    if (newQuantity > item.available * 0.5 && item.available > 0) {
      warnings.add(
        'Large quantity: $newQuantity of ${item.available} available',
      );
    }

    return CartValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validates cart total value
  ///
  /// Business rules:
  /// - Total must be non-negative
  /// - Warns for unusually large orders
  CartValidationResult validateCartTotal({
    required double total,
    double warningThreshold = 1000000, // 1M KRW
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate non-negative total
    if (total < 0) {
      errors.add('Cart total cannot be negative');
    }

    // Warning for large orders
    if (total > warningThreshold) {
      warnings.add(
        'Large order total: ₩${total.toStringAsFixed(0)} (>₩${warningThreshold.toStringAsFixed(0)})',
      );
    }

    return CartValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validates cart item count
  ///
  /// Business rules:
  /// - Item count must be non-negative
  /// - Warns for empty cart
  /// - Warns for unusually large cart
  CartValidationResult validateCartItemCount({
    required int itemCount,
    int maxRecommendedItems = 50,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // Validate non-negative count
    if (itemCount < 0) {
      errors.add('Cart item count cannot be negative');
    }

    // Warning for empty cart
    if (itemCount == 0) {
      warnings.add('Cart is empty');
    }

    // Warning for large cart
    if (itemCount > maxRecommendedItems) {
      warnings.add(
        'Large cart: $itemCount items (recommended max: $maxRecommendedItems)',
      );
    }

    return CartValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
