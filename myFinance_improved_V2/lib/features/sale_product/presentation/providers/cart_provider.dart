import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sales_product.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'use_case_providers.dart';

part 'cart_provider.g.dart';

/// Cart notifier - manages shopping cart state
///
/// Uses @Riverpod(keepAlive: true) to persist cart data across navigation.
/// State is List<CartItem> for synchronous updates.
@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  /// Map to store SalesProduct by productId for later retrieval
  final Map<String, SalesProduct> _productsMap = {};

  @override
  List<CartItem> build() {
    // Initialize with empty cart
    return [];
  }

  /// Get use cases from ref
  AddToCartUseCase get _addToCartUseCase => ref.read(addToCartUseCaseProvider);
  UpdateCartQuantityUseCase get _updateQuantityUseCase =>
      ref.read(updateCartQuantityUseCaseProvider);

  /// Get list of SalesProducts in cart
  List<SalesProduct> get cartProducts =>
      state.map((item) => _productsMap[item.productId]).whereType<SalesProduct>().toList();

  /// Add product to cart
  void addItem(SalesProduct product) {
    try {
      // Store the SalesProduct for later retrieval
      _productsMap[product.productId] = product;

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
    _productsMap.clear();
    state = [];
  }

  /// Get cart subtotal
  double get subtotal => state.fold(0, (sum, item) => sum + item.subtotal);

  /// Get total items count
  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}
