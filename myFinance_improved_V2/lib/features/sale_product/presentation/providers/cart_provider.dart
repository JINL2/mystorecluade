import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sales_product.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'use_case_providers.dart';

/// Cart provider - manages shopping cart state
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final addToCartUseCase = ref.watch(addToCartUseCaseProvider);
  final updateQuantityUseCase = ref.watch(updateCartQuantityUseCaseProvider);
  return CartNotifier(addToCartUseCase, updateQuantityUseCase);
});

/// Cart notifier - handles cart operations
class CartNotifier extends StateNotifier<List<CartItem>> {
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartQuantityUseCase _updateQuantityUseCase;

  CartNotifier(this._addToCartUseCase, this._updateQuantityUseCase) : super([]);

  /// Add product to cart
  void addItem(SalesProduct product) {
    try {
      final existingIndex = state.indexWhere((item) => item.productId == product.productId);

      if (existingIndex >= 0) {
        // Increase quantity if item already exists
        final existingItem = state[existingIndex];
        final updatedItem = _updateQuantityUseCase.execute(
          item: existingItem,
          newQuantity: existingItem.quantity + 1,
        );

        if (updatedItem != null) {
          final updatedItems = [...state];
          updatedItems[existingIndex] = updatedItem;
          state = updatedItems;
        }
      } else {
        // Add new item using use case
        final cartItem = _addToCartUseCase.execute(product: product);
        state = [...state, cartItem];
      }
    } catch (e) {
      // Handle exceptions (e.g., out of stock)
      rethrow;
    }
  }

  /// Remove item from cart
  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  /// Update item quantity
  void updateQuantity(String itemId, int quantity) {
    try {
      final itemIndex = state.indexWhere((item) => item.id == itemId);
      if (itemIndex < 0) return;

      final item = state[itemIndex];
      final updatedItem = _updateQuantityUseCase.execute(
        item: item,
        newQuantity: quantity,
      );

      if (updatedItem == null) {
        // Quantity is 0, remove item
        removeItem(itemId);
      } else {
        // Update quantity
        final updatedItems = [...state];
        updatedItems[itemIndex] = updatedItem;
        state = updatedItems;
      }
    } catch (e) {
      // Handle exceptions (e.g., insufficient stock)
      rethrow;
    }
  }

  /// Clear entire cart
  void clearCart() {
    state = [];
  }

  /// Get cart subtotal
  double get subtotal => state.fold(0, (sum, item) => sum + item.subtotal);

  /// Get total items count
  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}
