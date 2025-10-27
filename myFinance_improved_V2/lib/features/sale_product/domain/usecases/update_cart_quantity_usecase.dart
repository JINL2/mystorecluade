import '../entities/cart_item.dart';

/// Update cart quantity use case
///
/// Business logic for updating cart item quantities.
/// Allows any quantity (validation at checkout).
class UpdateCartQuantityUseCase {
  const UpdateCartQuantityUseCase();

  /// Execute the use case
  ///
  /// Returns updated cart item if quantity is valid.
  /// Returns null if quantity is 0 or less (indicates removal).
  CartItem? execute({
    required CartItem item,
    required int newQuantity,
  }) {
    // Remove item if quantity is 0 or less
    if (newQuantity <= 0) {
      return null;
    }

    // Return updated cart item (no stock validation like lib_old)
    return item.copyWith(quantity: newQuantity);
  }
}
