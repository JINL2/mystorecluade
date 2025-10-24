import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/filter_products_usecase.dart';
import '../../domain/usecases/load_products_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'sales_product_provider.dart';

/// Add to cart use case provider
final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  return const AddToCartUseCase();
});

/// Filter products use case provider
final filterProductsUseCaseProvider = Provider<FilterProductsUseCase>((ref) {
  return FilterProductsUseCase();
});

/// Update cart quantity use case provider
final updateCartQuantityUseCaseProvider = Provider<UpdateCartQuantityUseCase>((ref) {
  return const UpdateCartQuantityUseCase();
});

/// Load products use case provider
final loadProductsUseCaseProvider = Provider<LoadProductsUseCase>((ref) {
  final repository = ref.watch(salesProductRepositoryProvider);
  return LoadProductsUseCase(repository);
});
